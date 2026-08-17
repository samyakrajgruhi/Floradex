import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../services/user_service.dart';
import '../theme/app_theme.dart';
import '../main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const List<String> _defaultProfileImages = [
    'assets/default_profile/female1.png',
    'assets/default_profile/female2.png',
    'assets/default_profile/female3.png',
    'assets/default_profile/female4.png',
    'assets/default_profile/male1.png',
    'assets/default_profile/male2.png',
    'assets/default_profile/male3.png',
    'assets/default_profile/male4.png',
  ];

  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final UserService _userService = UserService();

  int _currentPage = 0;
  String _selectedAssetPath = 'assets/default_profile/male1.png';
  File? _selectedGalleryImage;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage == 0) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else if (_currentPage == 1) {
      final trimmed = _nameController.text.trim();
      if (trimmed.isNotEmpty) {
        FocusScope.of(context).unfocus();
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  Future<void> _completeOnboarding() async {
    final trimmed = _nameController.text.trim();
    if (trimmed.isEmpty) return;

    if (_selectedGalleryImage != null) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savePath = '${directory.path}/$fileName';
      await _selectedGalleryImage!.copy(savePath);
      await _userService.updateProfileImage(savePath);
    } else {
      await _userService.updateProfileImage(_selectedAssetPath);
    }

    await _userService.updateUserName(trimmed);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  Future<void> _pickFromGallery() async {
    final file = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (file == null || !mounted) return;
    setState(() {
      _selectedGalleryImage = File(file.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  _buildWelcomePage(),
                  _buildUsernamePage(),
                  _buildProfileImagePage(),
                ],
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.space4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              border: Border.all(color: AppTheme.primary, width: 3),
              boxShadow: const [
                BoxShadow(color: AppTheme.primary, offset: Offset(-4, -4)),
                BoxShadow(color: AppTheme.onSurface, offset: Offset(4, 4)),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.space4),
              child: Image.asset(
                'assets/default_profile/male1.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.space8),
          Text(
            'WELCOME TO',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: AppTheme.secondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppTheme.space2),
          Text(
            'FLORADEX',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: AppTheme.primary,
              fontSize: 32,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.space6),
          Text(
            'Your pocket botanist.\nScan. Discover. Collect.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.onSurface,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUsernamePage() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.space4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WHAT SHOULD WE\nCALL YOU?',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppTheme.primary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: AppTheme.space8),
          TextField(
            controller: _nameController,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            cursorColor: AppTheme.primary,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space4,
                vertical: AppTheme.space4,
              ),
              hintText: 'ENTER YOUR NAME',
              hintStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.outline,
                fontWeight: FontWeight.w800,
              ),
              filled: true,
              fillColor: AppTheme.surfaceContainerLowest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: const BorderSide(color: AppTheme.onSurface, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: const BorderSide(color: AppTheme.onSurface, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: const BorderSide(color: AppTheme.primary, width: 3),
              ),
            ),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _nextPage(),
          ),
          const SizedBox(height: AppTheme.space4),
          Text(
            'This will be your researcher identity.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImagePage() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CHOOSE YOUR\nAVATAR',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppTheme.primary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: AppTheme.space3),
          Text(
            'Pick a default or upload your own.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.outline,
            ),
          ),
          const SizedBox(height: AppTheme.space6),
          _buildProfilePreview(),
          const SizedBox(height: AppTheme.space6),
          Expanded(
            child: Column(
              children: [
                InkWell(
                  onTap: _pickFromGallery,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppTheme.space4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer,
                      border: Border.all(color: AppTheme.primary, width: 2),
                      boxShadow: const [
                        BoxShadow(color: AppTheme.onSurface, offset: Offset(2, 2)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_outlined, color: AppTheme.primaryDim, size: 24),
                        const SizedBox(width: AppTheme.space3),
                        Text(
                          '+ UPLOAD FROM GALLERY',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppTheme.primaryDim,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.space4),
                Expanded(
                  child: GridView.builder(
                    itemCount: _defaultProfileImages.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: AppTheme.space3,
                      mainAxisSpacing: AppTheme.space3,
                    ),
                    itemBuilder: (context, index) {
                      final assetPath = _defaultProfileImages[index];
                      final isSelected = _selectedGalleryImage == null && _selectedAssetPath == assetPath;
                      return InkWell(
                        onTap: () => setState(() {
                          _selectedGalleryImage = null;
                          _selectedAssetPath = assetPath;
                        }),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceContainerLow,
                            border: Border.all(
                              color: isSelected ? AppTheme.primary : AppTheme.onSurface,
                              width: 2,
                            ),
                            boxShadow: isSelected
                                ? const [BoxShadow(color: AppTheme.primary, offset: Offset(2, 2))]
                                : const [],
                          ),
                          padding: const EdgeInsets.all(AppTheme.space1),
                          child: Image.asset(assetPath, fit: BoxFit.cover),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePreview() {
    final imageProvider = _selectedGalleryImage != null
        ? FileImage(_selectedGalleryImage!) as ImageProvider
        : AssetImage(_selectedAssetPath);

    return Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          border: Border.all(color: AppTheme.onSurface, width: 2),
          boxShadow: const [
            BoxShadow(color: AppTheme.surfaceContainerHighest, offset: Offset(2, 2)),
            BoxShadow(color: AppTheme.onSurface, offset: Offset(4, 4)),
          ],
        ),
        padding: const EdgeInsets.all(AppTheme.space3),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.secondaryContainer.withValues(alpha: 0.4),
            border: Border.all(color: AppTheme.outlineVariant, width: 1),
          ),
          child: ClipRect(
            child: Image(
              image: imageProvider,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space4),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.outlineVariant.withValues(alpha: 0.2), width: 1)),
        color: AppTheme.surface,
      ),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: InkWell(
                onTap: () => _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppTheme.space4),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerLow,
                    border: Border.all(color: AppTheme.onSurface, width: 2),
                  ),
                  child: Text(
                    'BACK',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppTheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: AppTheme.space3),
          Expanded(
            flex: _currentPage == 0 ? 1 : 1,
            child: InkWell(
              onTap: _currentPage == 2 ? _completeOnboarding : _nextPage,
              child: Container(
                padding: const EdgeInsets.all(AppTheme.space4),
                decoration: BoxDecoration(
                  color: _canProceed() ? AppTheme.primary : AppTheme.surfaceContainerLow,
                  border: Border.all(color: AppTheme.onSurface, width: 2),
                  boxShadow: _canProceed()
                      ? const [BoxShadow(color: AppTheme.onSurface, offset: Offset(2, 2))]
                      : const [],
                ),
                child: Text(
                  _currentPage == 2 ? 'BEGIN' : 'NEXT',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: _canProceed() ? AppTheme.onPrimary : AppTheme.outline,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    if (_currentPage == 0) return true;
    if (_currentPage == 1) return _nameController.text.trim().isNotEmpty;
    if (_currentPage == 2) return _selectedGalleryImage != null || _selectedAssetPath.isNotEmpty;
    return false;
  }
}