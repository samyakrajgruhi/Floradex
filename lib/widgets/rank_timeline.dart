import 'package:flutter/material.dart';

class _PixelShadowContainer extends StatelessWidget {
  final Widget child;
  const _PixelShadowContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Shadow block
        Positioned(
          top: 3,
          left: 3,
          right: -3,
          bottom: -3,
          child: Container(
            color: const Color(0xFF383833), // onSurface for shadow
          ),
        ),
        // Main content
        child,
      ],
    );
  }
}

class _StaticRankEntry {
  final String id;
  final String title;
  final int threshold;
  final String iconPath;

  const _StaticRankEntry({
    required this.id,
    required this.title,
    required this.threshold,
    required this.iconPath,
  });
}

const List<_StaticRankEntry> _rankTimeline = [
  _StaticRankEntry(
    id: 'wild_seed',
    title: 'Wild Seed',
    threshold: 0,
    iconPath: 'assets/icons/wild_seed.png',
  ),
  _StaticRankEntry(
    id: 'sprout_seeker',
    title: 'Sprout Seeker',
    threshold: 1,
    iconPath: 'assets/icons/sprout_seeker.png',
  ),
  _StaticRankEntry(
    id: 'seedling',
    title: 'Seedling',
    threshold: 3,
    iconPath: 'assets/icons/seedling.png',
  ),
  _StaticRankEntry(
    id: 'sapling',
    title: 'Sapling',
    threshold: 6,
    iconPath: 'assets/icons/sapling.png',
  ),
  _StaticRankEntry(
    id: 'forager',
    title: 'Forager',
    threshold: 10,
    iconPath: 'assets/icons/forager.png',
  ),
  _StaticRankEntry(
    id: 'wildflower_scout',
    title: 'Wildflower Scout',
    threshold: 15,
    iconPath: 'assets/icons/wildflower_scout.png',
  ),
  _StaticRankEntry(
    id: 'naturalist',
    title: 'Naturalist',
    threshold: 22,
    iconPath: 'assets/icons/naturalist.png',
  ),
  _StaticRankEntry(
    id: 'botanist',
    title: 'Botanist',
    threshold: 30,
    iconPath: 'assets/icons/botanist.png',
  ),
  _StaticRankEntry(
    id: 'field_researcher',
    title: 'Field Researcher',
    threshold: 40,
    iconPath: 'assets/icons/field_researcher.png',
  ),
  _StaticRankEntry(
    id: 'flora_specialist',
    title: 'Flora Specialist',
    threshold: 55,
    iconPath: 'assets/icons/flora_specialist.png',
  ),
  _StaticRankEntry(
    id: 'forest_warden',
    title: 'Forest Warden',
    threshold: 75,
    iconPath: 'assets/icons/forest_warden.png',
  ),
  _StaticRankEntry(
    id: 'master_botanist',
    title: 'Master Botanist',
    threshold: 100,
    iconPath: 'assets/icons/master_botanist.png',
  ),
  _StaticRankEntry(
    id: 'botanical_sage',
    title: 'Botanical Sage',
    threshold: 140,
    iconPath: 'assets/icons/botanical_sage.png',
  ),
  _StaticRankEntry(
    id: 'floradex_legend',
    title: 'Floradex Legend',
    threshold: 200,
    iconPath: 'assets/icons/floradex_legend.png',
  ),
];

void showRankTimelineDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.72),
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: RankTimelineDialog(
          onClose: () => Navigator.of(dialogContext).pop(),
        ),
      );
    },
  );
}

class RankTimelineDialog extends StatelessWidget {
  final VoidCallback onClose;

  const RankTimelineDialog({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560, maxHeight: 680),
      child: _PixelShadowContainer(
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            border: Border.all(color: colorScheme.onSurface, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'RANK TIMELINE',
                            style: textTheme.displaySmall?.copyWith(
                              fontFamily: 'Press Start 2P',
                              fontSize: 12,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'STATIC PREVIEW OF THE CURRENT RANK PATH',
                            style: textTheme.labelSmall?.copyWith(
                              fontFamily: 'Space Grotesk',
                              color: colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    _CloseButton(onPressed: onClose),
                  ],
                ),
              ),
              Container(height: 2, color: colorScheme.onSurface),
              Flexible(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _rankTimeline.length,
                  itemBuilder: (context, index) {
                    final rank = _rankTimeline[index];
                    final isLast = index == _rankTimeline.length - 1;
                    return Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                      child: _RankTimelineRow(
                        rank: rank,
                        showLineBelow: !isLast,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CloseButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.tertiaryContainer,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.onSurface, width: 2),
          ),
          child: Icon(Icons.close, color: colorScheme.onSurface, size: 20),
        ),
      ),
    );
  }
}

class _RankTimelineRow extends StatelessWidget {
  final _StaticRankEntry rank;
  final bool showLineBelow;

  const _RankTimelineRow({required this.rank, required this.showLineBelow});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 40,
          child: SizedBox(
            height: 72,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  bottom: showLineBelow ? 0 : 36,
                  child: Container(width: 2, color: colorScheme.outlineVariant),
                ),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.onSurface, width: 2),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              border: Border.all(color: colorScheme.onSurface, width: 2),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    border: Border.all(color: colorScheme.onSurface, width: 2),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(
                    rank.iconPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.local_florist_outlined,
                        color: colorScheme.onSurface,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        rank.title.toUpperCase(),
                        style: textTheme.labelSmall?.copyWith(
                          fontFamily: 'Press Start 2P',
                          fontSize: 11,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        color: colorScheme.tertiaryContainer,
                        child: Text(
                          'THRESHOLD ${rank.threshold}',
                          style: textTheme.labelSmall?.copyWith(
                            fontFamily: 'Space Grotesk',
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onTertiaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
