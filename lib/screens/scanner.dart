// ignore_for_file: unused_field, unused_local_variable

import 'package:floradex/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:floradex/services/plant_info.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  String? _identifiedPlantName;
  Map<String, dynamic>? _plantDetails;

  bool _isLoading = false;
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

  XFile? _capturedImage;

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
    setState(() {
      _isLoading = true;
      _identifiedPlantName = null;
      _capturedImage = photo;
    });

    try {
      final bytes = await photo.readAsBytes();
      final base64Image = base64Encode(bytes);
      final apiKey = dotenv.env['PLANT_ID_API_KEY'];

      if (apiKey == null) {
        setState(() {
          _identifiedPlantName = "Error: Missing API Key";
          _isLoading = false;
        });
        return;
      }

      final url = Uri.parse('https://api.plant.id/v2/identify');
      final headers = {'Content-Type': 'application/json', 'Api-Key': apiKey};
      final body = jsonEncode({
        'images': [base64Image],
      });
      print("Sending image to Plant.id");

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['suggestions'] != null && data['suggestions'].isNotEmpty) {
          final bestMatchName = data['suggestions'][0]['plant_name'];
          setState(() {
            _identifiedPlantName = bestMatchName;
          });

          final infoService = PlantInfoService();
          final details = await infoService.getPlantDetails(bestMatchName);

          setState(() {
            _plantDetails = details;
          });
        } else {
          setState(() => _identifiedPlantName = "No plant found!");
        }
      } else {
        setState(
          () => _identifiedPlantName = "API Error: ${response.statusCode}",
        );
      }
    } catch (e) {
      setState(() => _identifiedPlantName = "Network Error");
    } finally {
      // Whether it succeeds or fails, hide the loading spinner
      setState(() => _isLoading = false);
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

            // 1. Temporary Text / Loading Indicator
            if (_isLoading)
              const CircularProgressIndicator(color: AppTheme.primary)
            else if (_identifiedPlantName != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Text(
                      '🌿 ${_plantDetails?['common_name'] ?? _identifiedPlantName}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Space Grotesk',
                      ),
                    ),

                                        // Show LLM details once they arrive!
                    if (_plantDetails != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        _plantDetails!['scientific_name'] ?? '',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Environment Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.greenAccent.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          _plantDetails!['environment'] ?? 'UNKNOWN ENV',
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                      
                      // Origin & Rarity
                      Text(
                        '📍 ${_plantDetails!['origin'] ?? 'Unknown'}   •   ⭐ ${_plantDetails!['rarity'] ?? '?'}/5',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 16),

                      // Medical Uses
                      const Text(
                        'MEDICAL USES',
                        style: TextStyle(color: AppTheme.primary, fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (_plantDetails!['medical_uses'] is List)
                            ? '• ' + (_plantDetails!['medical_uses'] as List).join('\n• ')
                            : _plantDetails!['medical_uses']?.toString() ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      
                      const SizedBox(height: 12),

                      // Edibility
                      const Text(
                        'EDIBILITY',
                        style: TextStyle(color: AppTheme.primary, fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _plantDetails!['edibility']?.toString() ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),

                      const SizedBox(height: 12),

                      // Facts
                      const Text(
                        'FACTS',
                        style: TextStyle(color: AppTheme.primary, fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (_plantDetails!['facts'] is List)
                            ? '• ' + (_plantDetails!['facts'] as List).join('\n• ')
                            : _plantDetails!['facts']?.toString() ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              )
            else
              const SizedBox(height: 30), // Empty space so layout doesn't jump

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
