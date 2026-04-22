// ignore_for_file: unused_element_parameter

import 'package:floradex/services/database_service.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ResearcherProfileScreen extends StatelessWidget {
  const ResearcherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FLORADEX'),
        actions: [
          Container(
            padding: const EdgeInsets.all(AppTheme.space2),
            child: const Icon(Icons.person),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppTheme.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PROFILE IMAGE & LEVEL
            Stack(
              clipBehavior: Clip.none,
              children: [
                _RetroShadowCard(
                  padding: const EdgeInsets.all(AppTheme.space2),
                  child: Container(
                    color: AppTheme.surfaceContainerLow,
                    width: 100,
                    height: 100,
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: AppTheme.outlineVariant,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -AppTheme.space2,
                  right: -AppTheme.space2,
                  child: _RetroShadowCard(
                    backgroundColor: AppTheme.tertiary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.space3,
                      vertical: AppTheme.space1,
                    ),
                    child: Text(
                      'LVL 15',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppTheme.onTertiary,
                        fontFamily: 'Press Start 2P',
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.space8),

            // NAME
            Text(
              'BOTANIST SAM',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: AppTheme.primary,
                height: 1.2,
              ),
            ),
            const SizedBox(height: AppTheme.space3),

            // BADGE
            Container(
              decoration: BoxDecoration(
                color: AppTheme.secondaryContainer,
                border: Border.all(color: AppTheme.secondary, width: 1.5),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space3,
                vertical: AppTheme.space1,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.military_tech_outlined,
                    size: 14,
                    color: AppTheme.secondary,
                  ),
                  const SizedBox(width: AppTheme.space1),
                  Text(
                    'MASTER RANGER',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppTheme.secondary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.space4),

            // BIO
            Text(
              'Dedicated researcher of rare mountain flora.\nSpecialized in high-altitude medicinal herbs and moss variations.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.outline,
                height: 1.6,
              ),
            ),
            const SizedBox(height: AppTheme.space6),

            // STATS
            Row(
              children: [
                Expanded(
                  child: _RetroShadowCard(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.space4,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Text(
                            '142',
                            style: Theme.of(context).textTheme.displayLarge
                                ?.copyWith(color: AppTheme.primary),
                          ),
                          const SizedBox(height: AppTheme.space2),
                          Text(
                            'TOTAL SCANS',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: AppTheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.space4),
                Expanded(
                  child: _RetroShadowCard(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.space4,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Text(
                            '12',
                            style: Theme.of(context).textTheme.displayLarge
                                ?.copyWith(color: AppTheme.secondary),
                          ),
                          const SizedBox(height: AppTheme.space2),
                          Text(
                            'RARE FINDS',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: AppTheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.space8),

            // ACHIEVEMENTS
            GestureDetector(
              child: _RetroShadowCard(
                backgroundColor: AppTheme.tertiaryContainer,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.space4,
                  vertical: AppTheme.space3,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ACHIEVEMENTS',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontFamily: 'Press Start 2P',
                        fontSize: 10,
                        color: AppTheme.onTertiaryContainer,
                      ),
                    ),
                    Text(
                      '8 / 24 UNLOCKED',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppTheme.onTertiaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.space4),
            GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: AppTheme.space3,
              mainAxisSpacing: AppTheme.space3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildAchievementBox(icon: Icons.eco, unlocked: true),
                _buildAchievementBox(icon: Icons.park, unlocked: true),
                _buildAchievementBox(icon: Icons.water_drop, unlocked: true),
                _buildAchievementBox(icon: Icons.wb_sunny, unlocked: true),
                _buildAchievementBox(icon: Icons.psychology, unlocked: false),
                _buildAchievementBox(icon: Icons.shield, unlocked: false),
                _buildAchievementBox(icon: Icons.stars, unlocked: false),
                _buildAchievementBox(icon: Icons.science, unlocked: false),
              ],
            ),
            const SizedBox(height: AppTheme.space8),

            // FIELD OPERATIONS
            Text(
              'FIELD OPERATIONS',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontFamily: 'Press Start 2P',
                fontSize: 10,
                color: AppTheme.secondary,
              ),
            ),
            const SizedBox(height: AppTheme.space4),
            _buildOperationButton(
              context,
              icon: Icons.person_outline,
              label: 'EDIT PROFILE',
            ),
            _buildOperationButton(
              context,
              icon: Icons.notifications_none,
              label: 'NOTIFICATION SETTINGS',
            ),
            _buildOperationButton(
              context,
              icon: Icons.sync,
              label: 'SYNC DATA',
              trailingIcon: Icons.check_box_outlined,
              trailingColor: AppTheme.primary,
            ),
            _buildOperationButton(
              context,
              icon: Icons.restart_alt,
              label: 'RESET VAULT',
              color: AppTheme.error,
              trailingIcon: null, // No trailing icon
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('RESET VAULT'),
                      content: const Text(
                        'Are you sure you want to reset your vault? Your Saved Plants will be deleted.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(dialogContext);
                            await DatabaseService().clearVault();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Vault successfully reset.'),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'CONFIRM',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            _buildOperationButton(
              context,
              icon: Icons.logout,
              label: 'LOGOUT',
              color: AppTheme.error,
              trailingIcon: null, // No trailing icon
            ),
            const SizedBox(height: AppTheme.space8),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Placeholder
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            activeIcon: Icon(Icons.camera_alt),
            label: 'SCAN',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'VAULT',
          ),
        ],
        onTap: (index) {},
      ),
    );
  }

  Widget _buildAchievementBox({
    required IconData icon,
    required bool unlocked,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: unlocked
                ? AppTheme.surfaceContainerLowest
                : AppTheme.surfaceContainer,
            border: Border.all(
              color: unlocked
                  ? AppTheme.primary
                  : AppTheme.surfaceContainerHigh,
              width: 2,
            ),
          ),
          child: Center(
            child: Icon(
              icon,
              color: unlocked ? AppTheme.primary : AppTheme.outlineVariant,
              size: 28,
            ),
          ),
        ),
        if (unlocked)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                border: Border.all(color: AppTheme.primary, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildOperationButton(
    BuildContext context, {
    VoidCallback? onTap,
    required IconData icon,
    required String label,
    Color? color,
    IconData? trailingIcon = Icons.chevron_right,
    Color? trailingColor,
  }) {
    final effectiveColor = color ?? AppTheme.onSurface;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.space4),
      child: GestureDetector(
        onTap: onTap,
        child: _RetroShadowCard(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.space4,
            vertical: AppTheme.space4,
          ),
          child: Row(
            children: [
              Icon(icon, color: effectiveColor, size: 24),
              const SizedBox(width: AppTheme.space4),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: effectiveColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              if (trailingIcon != null)
                Icon(
                  trailingIcon,
                  color: trailingColor ?? AppTheme.onSurface,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RetroShadowCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color borderColor;
  final Color shadowColor;
  final EdgeInsetsGeometry padding;

  const _RetroShadowCard({
    required this.child,
    this.backgroundColor = AppTheme.surfaceContainerLowest,
    this.borderColor = AppTheme.onSurface,
    this.shadowColor = AppTheme.onSurface,
    this.padding = const EdgeInsets.all(AppTheme.space4),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: AppTheme.space1,
          left: AppTheme.space1,
          right: -AppTheme.space1,
          bottom: -AppTheme.space1,
          child: Container(color: shadowColor),
        ),
        Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 2),
          ),
          padding: padding,
          child: child,
        ),
      ],
    );
  }
}
