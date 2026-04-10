import 'dart:io';
import 'package:floradex/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';

class BotanicalDossierScreen extends StatelessWidget {
  final String plantName;
  final Map<String, dynamic>? plantDetails;
  final XFile? plantImage;

  const BotanicalDossierScreen({
    super.key,
    required this.plantName,
    this.plantDetails,
    required this.plantImage,
  });

  void _showFullImageDialog(BuildContext context, XFile imageFile) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              InteractiveViewer(child: Image.file(File(imageFile.path))),
              Positioned(
                top: -10,
                right: -10,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FLORADEX'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Navigate to Profile
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppTheme.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE SECTION
            Stack(
              children: [
                // Shadow block
                Positioned(
                  top: 8,
                  left: 8,
                  right: -8,
                  bottom: -8,
                  child: Container(color: AppTheme.primary),
                ),
                // Main image container
                Container(
                  color: AppTheme.surfaceContainerLowest,
                  padding: const EdgeInsets.all(AppTheme.space2),
                  child: Stack(
                    children: [
                      plantImage != null
                          ? Stack(
                              children: [
                                AspectRatio(
                                  aspectRatio: 1.0,
                                  child: Image.file(
                                    File(plantImage!.path),
                                    fit: BoxFit
                                        .cover, // Ensures the image fills the square
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors
                                          .black54, // Semi-transparent background for visibility
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.fullscreen,
                                        color: Colors.white,
                                      ),
                                      onPressed: () => _showFullImageDialog(
                                        context,
                                        plantImage!,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          :
                            // Placeholder for actual image
                            Column(
                              children: [
                                AspectRatio(
                                  aspectRatio: 1.0,
                                  child: Container(
                                    color: AppTheme.surfaceContainerLow,
                                    child: const Icon(
                                      Icons.eco,
                                      size: 100,
                                      color: AppTheme.outlineVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      // ID Tag
                      Positioned(
                        bottom: AppTheme.space2,
                        left: AppTheme.space2,
                        child: Container(
                          color: AppTheme.tertiary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.space3,
                            vertical: AppTheme.space2,
                          ),
                          child: Text(
                            'ID: #0042',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: AppTheme.onTertiary,
                                  fontFamily:
                                      'Press Start 2P', // Force font for tag
                                  fontSize: 10,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.space6),

            // HEADER TEXT
            Text(
              plantDetails?['common_name'] ?? plantName,
              style: Theme.of(
                context,
              ).textTheme.displayLarge?.copyWith(color: AppTheme.primary),
            ),
            const SizedBox(height: AppTheme.space2),
            Text(
              'SCIENTIFIC NAME',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppTheme.tertiary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppTheme.space1),
            Text(
              plantDetails?['scientific_name'] ?? 'Unknown species',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: AppTheme.space6),

            // RARITY BLOCK
            Container(
              color: AppTheme.primaryContainer,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(width: 8, color: AppTheme.primary),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.space3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'RARITY',
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    fontFamily: 'Press Start 2P',
                                    fontSize: 10,
                                  ),
                            ),
                            const SizedBox(height: AppTheme.space2),
                            Row(
                              children: [
                                _buildRaritySquare(true),
                                const SizedBox(width: AppTheme.space1),
                                _buildRaritySquare(true),
                                const SizedBox(width: AppTheme.space1),
                                _buildRaritySquare(true),
                                const SizedBox(width: AppTheme.space1),
                                _buildRaritySquare(false),
                                const SizedBox(width: AppTheme.space1),
                                _buildRaritySquare(false),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.space4),

            // ENVIRONMENT BLOCK
            Container(
              color: AppTheme.surfaceContainer,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(width: 8, color: AppTheme.tertiary),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.space3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ENVIRONMENT',
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    fontFamily: 'Press Start 2P',
                                    fontSize: 10,
                                  ),
                            ),
                            const SizedBox(height: AppTheme.space2),
                            Row(
                              children: [
                                const Icon(
                                  Icons.wb_sunny_outlined,
                                  color: AppTheme.onSurface,
                                  size: 20,
                                ),
                                const SizedBox(width: AppTheme.space2),
                                Text(
                                  'ARID / SUNNY',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.space6),

            // MEDICAL USES CARD
            FloraDataCard(
              header: Row(
                children: [
                  const Icon(
                    Icons.medical_services_outlined,
                    size: 14,
                    color: AppTheme.onTertiaryContainer,
                  ),
                  const SizedBox(width: AppTheme.space2),
                  const Text('MEDICAL USES'),
                ],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFactRow(
                    context,
                    '1',
                    (plantDetails?['medical_uses'] as List?)?.isNotEmpty == true
                        ? plantDetails!['medical_uses'][0]
                        : 'Soothing burns and skin hydration.',
                  ),
                  const SizedBox(height: AppTheme.space3),
                  _buildFactRow(
                    context,
                    '2',
                    (plantDetails?['medical_uses'] as List?)?.isNotEmpty == true
                        ? plantDetails!['medical_uses'][1]
                        : 'Anti-inflammatory properties for topical treatment.',
                  ),
                  const SizedBox(height: AppTheme.space3),
                  _buildFactRow(
                    context,
                    '3',
                    (plantDetails?['medical_uses'] as List?)?.isNotEmpty == true
                        ? plantDetails!['medical_uses'][2]
                        : 'Supports digestive health when consumed.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.space6),

            // EDIBILITY CARD
            FloraDataCard(
              header: Row(
                children: [
                  const Icon(
                    Icons.restaurant_outlined,
                    size: 14,
                    color: AppTheme.onTertiaryContainer,
                  ),
                  const SizedBox(width: AppTheme.space2),
                  const Text('EDIBILITY'),
                ],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plantDetails?['edibility'] ??
                        'Edible gel can be used in drinks, but the yellow aloin in the outer skin should be strictly avoided.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if ((plantDetails?['taste'] as String?)?.isNotEmpty ==
                      true) ...[
                    const SizedBox(height: AppTheme.space3),
                    Row(
                      children: [
                        Text(
                          'TASTE: ',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        Expanded(
                          child: Text(
                            plantDetails!['taste'] ?? '',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if ((plantDetails?['harvest_season'] as String?)
                          ?.isNotEmpty ==
                      true) ...[
                    const SizedBox(height: AppTheme.space2),
                    Row(
                      children: [
                        Text(
                          'SEASON: ',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        Expanded(
                          child: Text(
                            plantDetails!['harvest_season'] ?? '',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if ((plantDetails?['growth_time'] as String?)?.isNotEmpty ==
                      true) ...[
                    const SizedBox(height: AppTheme.space2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 2,
                      children: [
                        Text(
                          'GROWS IN: ',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        Expanded(
                          child: Text(
                            plantDetails!['growth_time'] ?? '',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppTheme.space6),

            // ORIGIN CARD
            FloraDataCard(
              header: Row(
                children: [
                  const Icon(
                    Icons.public,
                    size: 14,
                    color: AppTheme.onTertiaryContainer,
                  ),
                  const SizedBox(width: AppTheme.space2),
                  const Text('ORIGIN'),
                ],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    color: AppTheme.surfaceContainerHigh,
                    child: const Center(
                      child: Icon(
                        Icons.map_outlined,
                        size: 40,
                        color: AppTheme.outline,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.space3),
                  Text(
                    'Originates from the Arabian Peninsula, thriving in wild, semi-tropical climates worldwide.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.space6),

            // QUICK FACTS CARD
            FloraDataCard(
              header: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    size: 14,
                    color: AppTheme.onTertiaryContainer,
                  ),
                  const SizedBox(width: AppTheme.space2),
                  const Text('QUICK FACTS'),
                ],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFactRow(
                    context,
                    '1',
                    (plantDetails?['facts'] as List?)?.isNotEmpty == true
                        ? plantDetails!['facts'][0]
                        : 'A resilient succulent known for extreme drought tolerance.',
                  ),
                  const SizedBox(height: AppTheme.space3),
                  _buildFactRow(
                    context,
                    '2',
                    (plantDetails?['facts'] as List?)?.isNotEmpty == true
                        ? plantDetails!['facts'][1]
                        : 'Used medicinally for over 6,000 years by ancient civilizations.',
                  ),
                  const SizedBox(height: AppTheme.space3),
                  _buildFactRow(
                    context,
                    '3',
                    (plantDetails?['facts'] as List?)?.isNotEmpty == true
                        ? plantDetails!['facts'][2]
                        : 'Contains over 75 active vitamins and minerals.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.space8),

            // BUTTONS
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (plantDetails == null || plantImage == null) return;
                  final dbService = new DatabaseService();
                  await dbService.savePlantToVault(plantDetails!, plantImage!);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Plant successfully saved.')
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.save_alt, size: 16),
                label: const Text('SAVE TO VAULT'),
              ),
            ),
            const SizedBox(height: AppTheme.space3),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text('BACK TO LIST'),
              ),
            ),
            const SizedBox(height: AppTheme.space6),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Assume this is accessed from Collection/Vault
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
            label: 'COLLECTION',
          ),
        ],
        onTap: (index) {
          // Navigation logic
        },
      ),
    );
  }

  Widget _buildRaritySquare(bool isFilled) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: isFilled ? AppTheme.primary : Colors.transparent,
        border: Border.all(
          color: isFilled ? AppTheme.primary : AppTheme.surfaceContainerHighest,
          width: 2,
        ),
      ),
    );
  }

  Widget _buildFactRow(BuildContext context, String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$number.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppTheme.primary,
            fontWeight: FontWeight.w800,
            fontFamily: 'Press Start 2P',
            fontSize: 10,
          ),
        ),
        const SizedBox(width: AppTheme.space3),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
