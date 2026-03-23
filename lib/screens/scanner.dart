// ignore_for_file: unused_local_variable

import 'package:floradex/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Assuming AppTheme colors are available in colorScheme
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.black, // Dark lab environment
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Header Text
            Text(
              'LABORATORY MODE',
              style: textTheme.labelSmall?.copyWith(
                fontFamily: 'Space Grotesk',
                color: AppTheme.primary, // AppTheme.primary
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Align the leaf within the frame for best results',
              style: textTheme.bodyMedium?.copyWith(
                fontFamily: 'Manrope',
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 24),

            // Viewfinder Frame
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E5D8), // surfaceContainerHigh
                    border: Border.all(
                      color: const Color(0xFF007523), // primary
                      width: 4,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Simulated Camera Feed (Dark placeholder for now)
                      Positioned.fill(
                        child: Container(
                          margin: const EdgeInsets.all(4), // Inner gap
                          color: const Color(0xFF1A1A1A),
                          child: Center(
                            // Circular lens aperture cutout
                            child: Container(
                              width: 280,
                              height: 280,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                                border: Border.all(
                                  color: const Color(0xFF2A2A2A),
                                  width: 40, // Thick lens barrel
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.energy_savings_leaf,
                                  color: Color(0xFF007523),
                                  size: 64,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // REC Indicator Block
                      Positioned(
                        top: 24,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            color: const Color(0xFF383833), // onSurface
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'REC  00:14:21',
                                  style: textTheme.titleSmall?.copyWith(
                                    fontFamily: 'Press Start 2P',
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Corner Reticles
                      const Positioned(
                        top: 16,
                        left: 16,
                        child: _ScannerReticle(angle: 0),
                      ),
                      const Positioned(
                        top: 16,
                        right: 16,
                        child: _ScannerReticle(angle: 1),
                      ),
                      const Positioned(
                        bottom: 16,
                        left: 16,
                        child: _ScannerReticle(angle: 3),
                      ),
                      const Positioned(
                        bottom: 16,
                        right: 16,
                        child: _ScannerReticle(angle: 2),
                      ),

                      // SNAP Button Container (Bottom Center)
                      Positioned(
                        bottom: 32,
                        left: 0,
                        right: 0,
                        child: Center(child: _SnapButton()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SnapButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Handle Image Capture
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 8-bit shadow (Color block layering, 0 blur)
          Positioned(
            top: 6,
            left: 6,
            bottom: -6,
            right: -6,
            child: Container(color: Colors.black),
          ),
          // Main Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(
                0xFFFFDBC8,
              ), // secondaryContainer matching the image peach color
              border: Border.all(color: Colors.black, width: 4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.black,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Text(
                  'SNAP',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontFamily: 'Press Start 2P',
                    color: Colors.black,
                    fontSize: 16,
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

class _ScannerReticle extends StatelessWidget {
  final int angle; // 0: TL, 1: TR, 2: BR, 3: BL

  const _ScannerReticle({required this.angle});

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: angle,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFF007523), width: 4),
            left: BorderSide(color: Color(0xFF007523), width: 4),
          ),
        ),
      ),
    );
  }
}
