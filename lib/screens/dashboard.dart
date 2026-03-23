import 'package:floradex/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppTheme.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeroCard(context),
          const SizedBox(height: AppTheme.space6),
          _buildRecentDiscoveryRow(context),
          const SizedBox(height: AppTheme.space6),
          _buildBotanicalFact(context),
          const SizedBox(height: AppTheme.space6),
          _buildStatsRow(context),
          const SizedBox(height: AppTheme.space6),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer,
            border: Border.all(color: AppTheme.onSurface, width: 4),
            boxShadow: const [
              BoxShadow(color: AppTheme.onSurface, offset: Offset(4, 4)),
            ],
          ),
          padding: const EdgeInsets.all(AppTheme.space6),
          child: Column(
            children: [
              Text(
                'PLANTS DISCOVERED',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppTheme.onSurface,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.space2),
              Text(
                '42',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppTheme.primaryDim,
                  fontSize: 64,
                  height: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.space3),
              Text(
                "YOU'RE BECOMING A MASTER BOTANIST!",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: 8,
                  color: AppTheme.onSurface,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.space4),
              const FloraProgressBar(value: 0.72),
            ],
          ),
        ),
        Positioned(
          top: -12,
          right: -12,
          child: Icon(
            Icons.energy_savings_leaf,
            size: 48,
            color: AppTheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentDiscoveryRow(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'RECENT DISCOVERY',
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(color: AppTheme.secondary),
            ),
            Text(
              'VIEW ALL',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.outline,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.space4),
        Row(
          children: [
            Expanded(
              child: _buildPlantCard(
                context,
                title: 'JADE PLANT',
                subtitle: 'Crassula ovata',
                iconData: Icons.yard_outlined,
              ),
            ),
            const SizedBox(width: AppTheme.space4),
            Expanded(
              child: _buildPlantCard(
                context,
                title: 'MONSTERA',
                subtitle: 'M. deliciosa',
                iconData: Icons.eco_outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlantCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData iconData,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        border: Border.all(color: AppTheme.primary, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 120,
            color: AppTheme.surfaceContainerHigh,
            alignment: Alignment.center,
            child: Icon(iconData, size: 64, color: AppTheme.primary),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppTheme.primary, width: 2),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.space2,
              vertical: AppTheme.space3,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.displaySmall?.copyWith(fontSize: 9),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppTheme.space1),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(color: AppTheme.secondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotanicalFact(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.tertiaryContainer,
        border: Border.all(color: AppTheme.onSurface, width: 2),
      ),
      padding: const EdgeInsets.all(AppTheme.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.space1),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLowest,
              border: Border.all(color: AppTheme.onSurface, width: 2),
            ),
            child: const Icon(Icons.lightbulb, color: AppTheme.tertiary),
          ),
          const SizedBox(width: AppTheme.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BOTANICAL FACT',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: 10,
                    color: AppTheme.onTertiaryContainer,
                  ),
                ),
                const SizedBox(height: AppTheme.space2),
                Text(
                  'Aloe Vera contains over 75 active components including vitamins, minerals, and amino acids!',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatBox(
            context,
            icon: Icons.water_drop_outlined,
            title: 'WATER NEEDS',
            value: 'LOW',
            iconColor: AppTheme.primary,
          ),
        ),
        const SizedBox(width: AppTheme.space4),
        Expanded(
          child: _buildStatBox(
            context,
            icon: Icons.wb_sunny_outlined,
            title: 'SUN ACCESS',
            value: 'HIGH',
            iconColor: AppTheme.tertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return FloraGhostBorder(
      child: Container(
        color: AppTheme.surfaceContainerLow,
        padding: const EdgeInsets.all(AppTheme.space3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: AppTheme.space3),
            Text(
              title,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.outline,
              ),
            ),
            const SizedBox(height: AppTheme.space1),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}