import 'dart:async';
import 'dart:io';
import 'package:floradex/models/user_info.dart';
import 'package:floradex/services/rank_service.dart';
import 'package:floradex/services/user_service.dart';
import 'package:floradex/theme/app_theme.dart';
import 'package:hive/hive.dart';
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

class BotanicalVaultPage extends StatefulWidget {
  const BotanicalVaultPage({super.key});

  @override
  State<BotanicalVaultPage> createState() => _BotanicalVaultPageState();
}

class _BotanicalVaultPageState extends State<BotanicalVaultPage> {
  final dbService = DatabaseService();
  final userService = UserService();
  final rankService = RankService();

  List<PlantRecord> PlantRecords = [];
  late Future<VaultData> vaultData;

  @override
  void initState() {
    super.initState();
    _loadPlants();
    vaultData = loadVaultData();
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

  void _showRankTimelineDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.72),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: _RankTimelineDialog(
            onClose: () => Navigator.of(dialogContext).pop(),
          ),
        );
      },
    );
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
                              onTap: _showRankTimelineDialog,
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
                    child: PlantRecords.isEmpty
                        ? const Center(child: Text('No Plants Discovered Yet.'))
                        : GridView.builder(
                            itemCount: PlantRecords.length,
                            itemBuilder: (context, index) {
                              return _PlantDataChip(
                                name: PlantRecords[index].plantName,
                                scientificName: PlantRecords[index]
                                    .scientificName, // Reddish tag
                                imagePath: PlantRecords[index].imagePath,
                                tagLabel: '',
                                tagColor: null,
                                timestamp: PlantRecords[index]
                                    .timestamp, // Replace with real asset/network
                              );
                            },
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.8,
                                ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
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

class _RankTimelineDialog extends StatelessWidget {
  final VoidCallback onClose;

  const _RankTimelineDialog({required this.onClose});

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
