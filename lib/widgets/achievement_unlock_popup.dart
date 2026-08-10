import 'package:floradex/services/achievement_service.dart';
import 'package:floradex/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// A centered modal overlay shown when an [Achievement] is newly unlocked.
///
/// Design notes (per Floradex product spec):
/// - Sits above the screen with a dimmed backdrop.
/// - Underlying screen cannot be interacted with while shown.
/// - Stays visible until the user presses the primary button — no timeout,
///   no tap-to-dismiss, no barrier-dismiss.
/// - The entrance animation is decorative; it does NOT control the lifetime
///   of the modal. Once it finishes, the modal simply sits there.
class AchievementUnlockPopup extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback onDismiss;

  const AchievementUnlockPopup({
    super.key,
    required this.achievement,
    required this.onDismiss,
  });

  @override
  State<AchievementUnlockPopup> createState() => _AchievementUnlockPopupState();
}

class _AchievementUnlockPopupState extends State<AchievementUnlockPopup>
    with TickerProviderStateMixin {
  late final AnimationController _entry;
  late final Animation<double> _backdropFade;
  late final Animation<double> _cardScale;
  late final Animation<double> _cardFade;

  late final AnimationController _iconPulse;
  late final Animation<double> _iconScale;

  @override
  void initState() {
    super.initState();

    _entry = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _backdropFade = CurvedAnimation(parent: _entry, curve: Curves.easeOut);
    _cardFade = CurvedAnimation(parent: _entry, curve: Curves.easeOut);
    _cardScale = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _entry, curve: Curves.easeOutBack));

    // Icon pulse runs once after the entry finishes.
    _iconPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _iconScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.08), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _iconPulse, curve: Curves.easeInOut));

    _entry.forward();
    _entry.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _iconPulse.forward();
      }
    });
  }

  @override
  void dispose() {
    _entry.dispose();
    _iconPulse.dispose();
    super.dispose();
  }

  String _primaryButtonLabel() {
    switch (widget.achievement.rarity) {
      case Rarity.legendary:
        return 'Claim Achievement';
      case Rarity.uncommon:
      case Rarity.rare:
        return 'Awesome!';
      case Rarity.common:
        return 'Continue';
    }
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.achievement;

    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _entry,
        builder: (context, _) {
          return Stack(
            children: [
              // Dimmed backdrop. No tap handler — it's purely visual.
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: Colors.black.withValues(
                      alpha: 0.55 * _backdropFade.value,
                    ),
                  ),
                ),
              ),

              // Opaque hit-test region underneath the card so the underlying
              // screen can't be interacted with, but taps in the dimmed area
              // also do nothing (no GestureDetector with onTap).
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: const SizedBox.expand(),
                ),
              ),

              // Centered card.
              Center(
                child: FadeTransition(
                  opacity: _cardFade,
                  child: ScaleTransition(
                    scale: _cardScale,
                    child: _buildCard(a),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

   Widget _buildCard(Achievement a) {
      final media = MediaQuery.of(context);
      final maxWidth = media.size.width - AppTheme.space6 * 2;

      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth.clamp(280.0, 420.0),
        ),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLowest,
              border: Border.all(
                color: AppTheme.onSurface,
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppTheme.onSurface,
                  offset: Offset(5, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppTheme.space4,
                    horizontal: AppTheme.space5,
                  ),
                  color: AppTheme.primaryContainer,
                  child: Column(
                    children: [
                      Text(
                        'ACHIEVEMENT UNLOCKED',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppTheme.onPrimaryContainer,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                            ),
                      ),
                      const SizedBox(height: AppTheme.space1),
                      Container(
                        width: 48,
                        height: 3,
                        color: AppTheme.primary,
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(AppTheme.space5),
                  child: Column(
                    children: [
                      const SizedBox(height: AppTheme.space2),

                      AnimatedBuilder(
                        animation: _iconPulse,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _iconScale.value,
                            child: child,
                          );
                        },
                        child: Container(
                          width: 136,
                          height: 136,
                          padding: const EdgeInsets.all(AppTheme.space4),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceContainerLow,
                            border: Border.all(
                              color: AppTheme.primary,
                              width: 3,
                            ),
                          ),
                          child: _buildIcon(a),
                        ),
                      ),

                      const SizedBox(height: AppTheme.space5),

                      Text(
                        a.title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppTheme.onSurface,
                              fontWeight: FontWeight.w800,
                            ),
                      ),

                      if (a.description.isNotEmpty) ...[
                        const SizedBox(height: AppTheme.space3),
                        Text(
                          a.description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.onSurface.withValues(alpha: 0.75),
                              ),
                        ),
                      ],

                      const SizedBox(height: AppTheme.space4),

                      _RarityPill(rarity: a.rarity),

                      const SizedBox(height: AppTheme.space5),

                      _PrimaryButton(
                        label: _primaryButtonLabel(),
                        onPressed: widget.onDismiss,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildIcon(Achievement a) {
      final path = a.iconPath.startsWith('_')
          ? 'assets/icons/achievements/_placeholder.png'
          : a.iconPath;

      return Image.asset(
        path,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.emoji_events_outlined,
            color: AppTheme.primary,
            size: 64,
          );
        },
      );
    }
  }

  class _RarityPill extends StatelessWidget {
    final Rarity rarity;

    const _RarityPill({
      required this.rarity,
    });

    @override
    Widget build(BuildContext context) {
      final color = switch (rarity) {
        Rarity.common => AppTheme.outline,
        Rarity.uncommon => AppTheme.primary,
        Rarity.rare => AppTheme.tertiary,
        Rarity.legendary => AppTheme.secondary,
      };

      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.space4,
          vertical: AppTheme.space2,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          border: Border.all(
            color: color,
            width: 1.5,
          ),
        ),
        child: Text(
          rarity.label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
        ),
      );
    }
  }

  class _PrimaryButton extends StatelessWidget {
    final String label;
    final VoidCallback onPressed;

    const _PrimaryButton({
      required this.label,
      required this.onPressed,
    });

    @override
    Widget build(BuildContext context) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(label),
        ),
      );
    }
  }

