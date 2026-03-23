import 'package:flutter/material.dart';

class BotanicalVaultPage extends StatelessWidget {
  const BotanicalVaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

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
                        color: colorScheme.surfaceContainerLowest, // #FFFFFF
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
                                .tertiaryContainer, // AppTheme.tertiaryContainer (#FFE08A)
                            border: Border.all(
                              color: colorScheme.onSurface,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TOTAL DISCOVERED',
                                style: textTheme.labelSmall?.copyWith(
                                  fontFamily: 'Press Start 2P',
                                  fontSize: 8,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '42',
                                    style: textTheme.headlineMedium?.copyWith(
                                      fontFamily: 'Press Start 2P',
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text(
                                      '/ 151 SPECIES',
                                      style: textTheme.bodySmall?.copyWith(
                                        fontFamily: 'Space Grotesk',
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Simple 8-bit Progress Bar
                              Container(
                                height: 8,
                                width: double.infinity,
                                color: colorScheme.surfaceContainerHighest,
                                alignment: Alignment.centerLeft,
                                child: FractionallySizedBox(
                                  widthFactor: 42 / 151,
                                  child: Container(color: colorScheme.primary),
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
                      child: _PixelShadowContainer(
                        child: Container(
                          // Removed hardcoded height to allow stretching
                          decoration: BoxDecoration(
                            color: colorScheme
                                .primaryContainer, // AppTheme.primaryContainer (#8EFE91)
                            border: Border.all(
                              color: colorScheme.onSurface,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.emoji_events_outlined,
                                color: colorScheme.onPrimaryContainer,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'MASTER\nRANGER',
                                textAlign: TextAlign.center,
                                style: textTheme.labelSmall?.copyWith(
                                  fontFamily: 'Press Start 2P',
                                  fontSize: 7,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ],
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
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                  children: [
                    _PlantDataChip(
                      name: 'OAK',
                      scientificName: 'QUERCUS ROBUR',
                      tagLabel: 'NEW',
                      tagColor: colorScheme.error, // Reddish tag
                      imagePath:
                          'assets/oak.png', // Replace with real asset/network
                    ),
                    _PlantDataChip(
                      name: 'HIBISCUS',
                      scientificName: 'HIBISCUS ROSA',
                      tagLabel: 'RARE',
                      tagColor: colorScheme.tertiary, // Brownish tag
                      imagePath: 'assets/hibiscus.png',
                    ),
                    _PlantDataChip(
                      name: 'NEEM',
                      scientificName: 'AZADIRACHTA',
                      imagePath: 'assets/neem.png',
                    ),
                    _PlantDataChip(
                      name: 'CACTUS',
                      scientificName: 'CACTACEAE',
                      imagePath: 'assets/cactus.png',
                    ),

                    // Locked / Unknown Placeholder
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh,
                        border: Border.all(
                          color: colorScheme.outline.withOpacity(0.5),
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '?',
                              style: textTheme.headlineLarge?.copyWith(
                                fontFamily: 'Press Start 2P',
                                color: colorScheme.outline,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '???',
                              style: textTheme.labelSmall?.copyWith(
                                fontFamily: 'Press Start 2P',
                                color: colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    _PlantDataChip(
                      name: 'SUNFLOWER',
                      scientificName: 'HELIANTHUS',
                      imagePath: 'assets/sunflower.png',
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
          top: 6,
          left: 6,
          right: -6,
          bottom: -6,
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

  const _PlantDataChip({
    required this.name,
    required this.scientificName,
    this.tagLabel,
    this.tagColor,
    required this.imagePath,
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
                  Center(
                    // Placeholder icon for missing assets in snippet
                    child: Icon(
                      Icons.park,
                      size: 64,
                      color: colorScheme.primary,
                    ),
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
                    fontSize: 9,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
