// ignore_for_file: unused_field, unused_local_variable
import 'package:floradex/services/plant_info.dart';
import 'package:floradex/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:floradex/screens/botanical_dossier.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _setupCamera() async {
    final cameras = await availableCameras();

    if (cameras.isNotEmpty) {
      final backCamera = cameras.first;

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _openCamera() async {
    if (!_isCameraInitialized || _cameraController == null) {
      return null;
    }
    try {
      final XFile? photo = await _cameraController?.takePicture();
      await _identifyPlant(photo!);
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  Future<void> _openGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
      if (photo != null) {
        _identifyPlant(photo);
      }
    } catch (e) {
      print('Error taking image from gallery: $e');
    }
  }

  Future<void> _identifyPlant(XFile photo) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _LoadingScreen(),
    );

    try {
      final plantInfoService = PlantInfoService();

      final plantDetails = await plantInfoService.analyzePlantImage(photo);

      Navigator.pop(context);

      if (plantDetails != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BotanicalDossierScreen(
              plantName: plantDetails['common_name'] ?? 'Unkown Plant',
              plantImage: photo,
              plantDetails: plantDetails,
            ),
          ),
        );
      } else {
        print("Could not gather plant details.");
      }
    } catch (e) {
      print("Error during plant analysis : $e");
      Navigator.pop(context);
    }
  }

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
                    color: const Color(0xFFE8E5D8), 
                    border: Border.all(
                      color: const Color(0xFF007523), 
                      width: 4,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          margin: const EdgeInsets.all(4), 
                          color: const Color(0xFF1A1A1A),
                          child: _isCameraInitialized
                              ? CameraPreview(_cameraController!)
                              : Center(
                                  child: Icon(
                                    Icons.energy_savings_leaf,
                                    color: Color(0xFF007523),
                                    size: 64,
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
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // --- NEW UI UPDATES BELOW VIEWFINDER ---
            const SizedBox(height: 16),

            const SizedBox(height: 16),

            // 2. Buttons Row (Gallery + Snap)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Gallery Button
                IconButton(
                  onPressed: _openGallery,
                  icon: const Icon(Icons.photo_library_outlined),
                  color: Colors.white,
                  iconSize: 32,
                ),
                const SizedBox(width: 24),

                // Snap Button
                _SnapButton(onTap: _openCamera),

                const SizedBox(width: 56),
              ],
            ),
            const SizedBox(height: 32),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SnapButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SnapButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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

class _LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        color: AppTheme.surface,
        padding: const EdgeInsets.all(AppTheme.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: AppTheme.surfaceContainerHighest,
              padding: const EdgeInsets.all(AppTheme.space4),
              child: Column(
                children: [
                  Text(
                    'ANALYZING',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppTheme.primary,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: AppTheme.space4),
                  const SizedBox(
                    width: 200,
                    child: LinearProgressIndicator(
                      backgroundColor: AppTheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.primary,
                      ),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: AppTheme.space4),
                  Text(
                    'Scanning botanical data...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
