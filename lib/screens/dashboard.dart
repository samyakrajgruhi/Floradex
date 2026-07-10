import 'dart:io';

import 'package:floradex/models/plant_record.dart';
import 'package:floradex/models/user_info.dart';
import 'package:floradex/screens/botanical_dossier.dart';
import 'package:floradex/services/fact_service.dart';
import 'package:floradex/services/database_service.dart';
import 'package:floradex/services/rank_service.dart';
import 'package:floradex/services/user_service.dart';
import 'package:floradex/theme/app_theme.dart';
import 'package:floradex/widgets/rank_timeline.dart';
import 'package:flutter/material.dart';

class DashboardData {
  UserInfo user;
  Rank currentRank;
  Rank? nextRank;
  double progress;

  DashboardData({
    required this.user,
    required this.currentRank,
    required this.nextRank,
    required this.progress,
  });
}

class DashboardPage extends StatefulWidget {
  final VoidCallback onViewAllTap;
  const DashboardPage({super.key, required this.onViewAllTap});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final userService = UserService();
  final rankService = RankService();
  final dataBaseService = DatabaseService();
  final factService = BotanicalFactService();

  late Future<List<PlantRecord>> recentDiscoveries;

  late Future<DashboardData> dashboardData;

  late Future<String?> dailyFact;

  @override
  void initState() {
    super.initState();
    dashboardData = loadDashboardData();
    recentDiscoveries = dataBaseService.getRecentDiscoveries();
    dailyFact = fetchDailyFact();
  }

  Future<DashboardData> loadDashboardData() async {
    final user = await userService.getUserInfo();
    final currentRank = await rankService.getRankForProgress(user.userProgress);
    final nextRank = await rankService.getNextRank(user.userProgress);
    final progress = await rankService.progressRatioToNext(user.userProgress);

    return DashboardData(
      user: user,
      currentRank: currentRank!,
      nextRank: nextRank,
      progress: progress,
    );
  }

  Future<String?> fetchDailyFact() async {
    final fact;
    try {
      fact = (await factService.fetchDailyFactJson());
      return fact;
    } catch (e) {
      print("Failed to fetch botanical fact");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dashboardData,
      builder: (context, AsyncSnapshot) {
        if (AsyncSnapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (AsyncSnapshot.hasError) {
          return Center(child: Text('Failed to load Dashboard'));
        }

        final data = AsyncSnapshot.data;
        return SingleChildScrollView(
          padding: AppTheme.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeroCard(context, data!),
              const SizedBox(height: AppTheme.space6),
              _buildBotanicalFact(context),
              const SizedBox(height: AppTheme.space6),
              FutureBuilder<List<PlantRecord>>(
                future: recentDiscoveries,
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (asyncSnapshot.hasError) {
                    return const Text('Failed to load recent discoveries');
                  }

                  final plants = asyncSnapshot.data ?? [];
                  return _buildRecentDiscoveryRow(context, plants);
                },
              ),
              const SizedBox(height: AppTheme.space6),
              _buildStatsRow(context),
              const SizedBox(height: AppTheme.space6),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeroCard(BuildContext context, DashboardData data) {
    return FloraGhostBorder(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLow,
          border: Border.all(color: AppTheme.primary, width: 2),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                border: Border(
                  bottom: BorderSide(color: AppTheme.primary, width: 2),
                ),
              ),
              padding: const EdgeInsets.all(AppTheme.space4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CURRENT RANK',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.outline,
                              ),
                        ),
                        const SizedBox(height: AppTheme.space1),
                        Text(
                          data.currentRank.title,
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(
                                color: AppTheme.primaryDim,
                                fontSize: 18,
                              ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => showRankTimelineDialog(context),
                    child: Container(
                      color: AppTheme.surfaceContainerLowest,
                      padding: const EdgeInsets.all(AppTheme.space2),
                      child: Image.asset(
                        data.currentRank.iconPath,
                        width: 56,
                        height: 56,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: AppTheme.surfaceContainerLowest,
              padding: const EdgeInsets.all(AppTheme.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PLANTS DISCOVERED',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.outline,
                            ),
                      ),
                      const SizedBox(height: AppTheme.space4),
                      Text(
                        '${data.user.userProgress}',
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(
                              color: AppTheme.primaryDim,
                              fontSize: 56,
                              height: 1.0,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.space4),
                  Text(
                    data.currentRank.dashboardText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppTheme.space4),
                  _buildRankProgressBar(context, data),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankProgressBar(BuildContext context, DashboardData data) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerHigh,
        border: Border.all(color: AppTheme.primary),
      ),

      padding: const EdgeInsets.all(AppTheme.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.tertiaryContainer,
                  border: Border.all(color: Colors.black),
                ),
                padding: EdgeInsetsGeometry.all(4),
                child: Text(
                  '${data.currentRank.threshold}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.onSurface,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.tertiaryContainer,
                  border: Border.all(color: Colors.black),
                ),
                child: Text(
                  '${data.nextRank!.threshold}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.onSurface,
                    backgroundColor: AppTheme.tertiaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.space2),
          Container(
            height: 12,
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerHighest,
              border: Border.all(color: Colors.black),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: data.progress,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4CAF50), AppTheme.primary],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.space1),
          Text(
            'PROGRESS TO NEXT RANK',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppTheme.outline,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentDiscoveryRow(
    BuildContext context,
    List<PlantRecord> plants,
  ) {
    final items = plants.take(2).toList();

    if (items.isEmpty) {
      return const Text('No discoveries yet');
    }

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
            InkWell(
              onTap: widget.onViewAllTap,
              child: Text(
                'VIEW ALL',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.outline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.space4),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: AppTheme.space2),
                child: _buildPlantCard(context, plant: items[0]),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: AppTheme.space2),
                child: items.length > 1
                    ? _buildPlantCard(context, plant: items[1])
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlantCard(BuildContext context, {required PlantRecord plant}) {
    return InkWell(
      onTap: () => _openPlantDossier(context, plant),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          border: Border.all(color: AppTheme.primary, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 145,
              child: Container(
                color: AppTheme.surfaceContainerHigh,
                alignment: Alignment.center,
                child: Image.file(
                  File(plant.imagePath),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
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
                    plant.plantName,
                    style: Theme.of(
                      context,
                    ).textTheme.displaySmall?.copyWith(fontSize: 9),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppTheme.space1),
                  Text(
                    plant.scientificName,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppTheme.secondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openPlantDossier(BuildContext context, PlantRecord plant) {
    final details = {
      'common_name': plant.plantName,
      'scientific_name': plant.scientificName,
      'medical_uses': plant.medicalUses,
      'edibility': plant.edibility,
      'taste': plant.taste,
      'harvest_season': plant.harvestSeason,
      'growth_time': plant.growthTime,
      'origin': plant.origin,
      'facts': plant.facts,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BotanicalDossierScreen(
          plantName: plant.plantName,
          imagePath: plant.imagePath,
          plantDetails: details,
        ),
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
                FutureBuilder(
                  future: dailyFact,
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final data = asyncSnapshot.data;
                     if (data == null) {
                        return const Center(child: Text('No Data!!'));
                      }
                    return Text(
                      data,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
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
