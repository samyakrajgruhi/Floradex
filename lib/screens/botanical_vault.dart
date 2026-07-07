import 'dart:async';
import 'dart:io';
import 'package:floradex/models/user_info.dart';
import 'package:floradex/screens/botanical_dossier.dart';
import 'package:floradex/services/rank_service.dart';
import 'package:floradex/services/user_service.dart';
import 'package:floradex/theme/app_theme.dart';
import 'package:floradex/widgets/rank_timeline.dart';
import 'package:intl/intl.dart';
import 'package:floradex/models/plant_record.dart';
import 'package:floradex/services/database_service.dart';
import 'package:flutter/material.dart';

class VaultData {
  UserInfo user;
  Rank? currentRank;
  double progress;

  VaultData({
    required this.user,
    required this.currentRank,
    required this.progress,
  });
}

class BotanicalVaultPage extends StatefulWidget {
  const BotanicalVaultPage({super.key});

  @override
  State<BotanicalVaultPage> createState() => _BotanicalVaultPageState();
}

class _BotanicalVaultPageState extends State<BotanicalVaultPage> {
  final dbService = DatabaseService();
  final userService = UserService();
  final rankService = RankService();
  final TextEditingController _searchController = TextEditingController();

  List<PlantRecord> PlantRecords = [];
  late Future<VaultData> vaultData;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadPlants();
    vaultData = loadVaultData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<VaultData> loadVaultData() async {
    final user = await userService.getUserInfo();
    final currentRank = await rankService.getRankForProgress(user.userProgress);
    final progress = await rankService.progressRatioToNext(user.userProgress);

    return VaultData(user: user, currentRank: currentRank, progress: progress);
  }

  Future<void> _loadPlants() async {
    final plants = await dbService.fetchPlants();
    if (mounted) {
      setState(() {
        PlantRecords = plants;
      });
    }
  }

  List<PlantRecord> get _filteredPlantRecords {
    final query = _normalizeSearchTerm(_searchQuery);
    if (query.isEmpty) {
      return PlantRecords;
    }

    final matches = PlantRecords.map((plant) {
      final score = _fuzzyMatchScore(
        query,
        _normalizeSearchTerm(plant.plantName),
      );
      return _PlantSearchMatch(plant: plant, score: score);
    }).where((match) => match.score > 0).toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    return matches.map((match) => match.plant).toList();
  }

  String _normalizeSearchTerm(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '')
        .trim();
  }

  double _fuzzyMatchScore(String query, String target) {
    if (query.isEmpty || target.isEmpty) {
      return 0;
    }

    if (target == query) {
      return 100;
    }

    if (target.startsWith(query)) {
      return 90 + (query.length / target.length);
    }

    if (target.contains(query)) {
      return 75 + (query.length / target.length);
    }

    final subsequenceScore = _subsequenceScore(query, target);
    final editScore = _editSimilarityScore(query, target);
    return subsequenceScore > editScore ? subsequenceScore : editScore;
  }

  double _subsequenceScore(String query, String target) {
    var queryIndex = 0;
    var firstMatchIndex = -1;
    var lastMatchIndex = -1;

    for (var targetIndex = 0; targetIndex < target.length; targetIndex++) {
      if (target[targetIndex] == query[queryIndex]) {
        firstMatchIndex = firstMatchIndex == -1 ? targetIndex : firstMatchIndex;
        lastMatchIndex = targetIndex;
        queryIndex++;

        if (queryIndex == query.length) {
          final span = lastMatchIndex - firstMatchIndex + 1;
          final compactness = query.length / span;
          final coverage = query.length / target.length;
          return 45 + (compactness * 20) + (coverage * 10);
        }
      }
    }

    return 0;
  }

  double _editSimilarityScore(String query, String target) {
    final maxLength = query.length > target.length
        ? query.length
        : target.length;
    final distance = _levenshteinDistance(query, target);
    final similarity = 1 - (distance / maxLength);

    return similarity >= 0.58 ? similarity * 70 : 0;
  }

  int _levenshteinDistance(String source, String target) {
    final previous = List<int>.generate(target.length + 1, (index) => index);
    final current = List<int>.filled(target.length + 1, 0);

    for (var sourceIndex = 0; sourceIndex < source.length; sourceIndex++) {
      current[0] = sourceIndex + 1;

      for (var targetIndex = 0; targetIndex < target.length; targetIndex++) {
        final substitutionCost =
            source[sourceIndex] == target[targetIndex] ? 0 : 1;
        current[targetIndex + 1] = [
          current[targetIndex] + 1,
          previous[targetIndex + 1] + 1,
          previous[targetIndex] + substitutionCost,
        ].reduce((value, element) => value < element ? value : element);
      }

      previous.setAll(0, current);
    }

    return previous[target.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return FutureBuilder(
      future: vaultData,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = asyncSnapshot.data;
        if (data == null) {
          return const Center(child: Text('No Data!!'));
        }
        final filteredPlantRecords = _filteredPlantRecords;
        return Scaffold(
          backgroundColor: colorScheme.surface, // AppTheme.surface (#FDFFDA)
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),

                  // SEARCH SECTION
                  Text(
                    'SEARCH CATALOG',
                    style: textTheme.labelSmall?.copyWith(
                      fontFamily: 'Press Start 2P',
                      color: colorScheme.primary, // AppTheme.primary (#007523)
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                colorScheme.surfaceContainerLowest, // #FFFFFF
                            border: Border(
                              bottom: BorderSide(
                                color: colorScheme.primary,
                                width: 4, // Thick 8-bit border
                              ),
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'TYPE PLANT NAME...',
                              hintStyle: textTheme.bodyMedium?.copyWith(
                                fontFamily: 'Space Grotesk',
                                color: colorScheme.outline,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: colorScheme.outline,
                              ),
                              suffixIcon: _searchQuery.isEmpty
                                  ? null
                                  : IconButton(
                                      tooltip: 'Clear search',
                                      icon: Icon(
                                        Icons.close,
                                        color: colorScheme.outline,
                                      ),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {
                                          _searchQuery = '';
                                        });
                                      },
                                    ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                            ),
                            style: textTheme.bodyMedium?.copyWith(
                              fontFamily: 'Manrope',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Filter Button (Tactile Switch)
                      _PixelShadowContainer(
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: colorScheme
                                .secondary, // AppTheme.secondary (#9A511E)
                            border: Border.all(
                              color: colorScheme.onSurface,
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.filter_list, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // STATS ROW SECTION
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Total Discovered Card
                        Expanded(
                          flex: 2,
                          child: _PixelShadowContainer(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colorScheme
                                    .primaryContainer, // AppTheme.tertiaryContainer (#FFE08A)
                                border: Border.all(
                                  color: colorScheme.onSurface,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'TOTAL DISCOVERED',
                                    style: textTheme.labelSmall?.copyWith(
                                      fontFamily: 'Press Start 2P',
                                      fontSize: 12,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text(
                                      '${data.user.userProgress} SPECIES',
                                      style: textTheme.bodySmall?.copyWith(
                                        fontFamily: 'Space Grotesk',
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onSurface,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Simple 8-bit Progress Bar
                                  Container(
                                    decoration: BoxDecoration(
                                      color:
                                          colorScheme.surfaceContainerHighest,
                                      border: Border.all(
                                        color: AppTheme.onPrimaryContainer,
                                      ),
                                    ),
                                    height: 8,
                                    width: double.infinity,
                                    alignment: Alignment.centerLeft,
                                    child: FractionallySizedBox(
                                      widthFactor: data.progress,
                                      child: Container(
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Rank Badge Card
                        Expanded(
                          flex: 1,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => showRankTimelineDialog(context),
                              child: _PixelShadowContainer(
                                child: Container(
                                  // Removed hardcoded height to allow stretching
                                  padding: EdgeInsets.only(top: 8, bottom: 8),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: colorScheme
                                        .tertiaryContainer, // AppTheme.primaryContainer (#8EFE91)
                                    border: Border.all(
                                      color: colorScheme.onSurface,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        color: AppTheme.onPrimary,
                                        child: Image.asset(
                                          data.currentRank!.iconPath,
                                          height: 46,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        data.currentRank!.title,
                                        textAlign: TextAlign.center,
                                        style: textTheme.labelMedium?.copyWith(
                                          fontFamily: 'Press Start 2P',
                                          fontSize: 16,
                                          color: colorScheme.onPrimaryContainer,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ), // Close IntrinsicHeight
                  const SizedBox(height: 32),

                  // GRID SECTION
                  Expanded(
                    child: _buildPlantGrid(filteredPlantRecords),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlantGrid(List<PlantRecord> filteredPlantRecords) {
    if (PlantRecords.isEmpty) {
      return const Center(child: Text('No Plants Discovered Yet.'));
    }

    if (filteredPlantRecords.isEmpty) {
      return const Center(child: Text('No Matching Plants Found.'));
    }

    return GridView.builder(
      itemCount: filteredPlantRecords.length,
      itemBuilder: (context, index) {
        final plant = filteredPlantRecords[index];
        return InkWell(
          onTap: () {
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
          },
          child: _PlantDataChip(
            name: plant.plantName,
            scientificName: plant.scientificName, // Reddish tag
            imagePath: plant.imagePath,
            tagLabel: '',
            tagColor: null,
            timestamp: plant.timestamp, // Replace with real asset/network
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
    );
  }
}

class _PlantSearchMatch {
  final PlantRecord plant;
  final double score;

  const _PlantSearchMatch({required this.plant, required this.score});
}

/// Helper widget to create the sharp right/bottom 8-bit shadow effect
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

/// Data Chip pattern mapped to the grid view cell
class _PlantDataChip extends StatelessWidget {
  final String name;
  final String scientificName;
  final String? tagLabel;
  final Color? tagColor;
  final String imagePath;
  final DateTime timestamp;
  const _PlantDataChip({
    required this.name,
    required this.scientificName,
    required this.imagePath,
    required this.tagLabel,
    required this.tagColor,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        border: Border.all(color: colorScheme.onSurface, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Block with shifting background
          Expanded(
            child: Container(
              color: colorScheme.surfaceContainerHigh,
              child: Stack(
                children: [
                  Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  if (tagLabel != null && tagColor != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        color: tagColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        child: Text(
                          tagLabel!,
                          style: textTheme.labelSmall?.copyWith(
                            fontFamily: 'Press Start 2P',
                            fontSize: 7,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Info Block
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: colorScheme.onSurface, width: 2),
              ),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: textTheme.labelMedium?.copyWith(
                    fontFamily: 'Press Start 2P',
                    fontSize: 12,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  scientificName,
                  style: textTheme.bodySmall?.copyWith(
                    fontFamily: 'Space Grotesk',
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM d, yyyy h:mm a').format(timestamp),
                  style: textTheme.bodySmall?.copyWith(
                    fontFamily: 'Space Grotesk',
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
