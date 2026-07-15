import 'dart:io';

import 'package:floradex/models/user_info.dart';
import 'package:floradex/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../theme/app_theme.dart';

class ResearcherProfileScreen extends StatefulWidget {
  final UserInfo user;
  const ResearcherProfileScreen({required this.user, super.key});

  @override
  State<ResearcherProfileScreen> createState() =>
      _ResearcherProfileScreenState();
}

class _ResearcherProfileScreenState extends State<ResearcherProfileScreen> {
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

  final ImagePicker _imagePicker = ImagePicker();
  final UserService _userService = UserService();

  final TextEditingController _nameController = TextEditingController();

  late Future<int> _scanCountFuture;

  String _selectedAssetPath = 'assets/default_profile/male1.png';
  File? _selectedGalleryImage;

  @override
  void initState() {
    super.initState();
    _scanCountFuture = _loadScanCount();
    _loadProfileImage();
    _nameController.text = widget.user.userName;
  }

  Future<int> _loadScanCount() async {
    final user = await _userService.getUserInfo();
    return user.userProgress;
  }

  Future<void> _loadProfileImage() async {
    final user = await _userService.getUserInfo();
    final savedPath = user.profileImagePath;

    if (!mounted) return;
    setState(() {
      if (savedPath.startsWith('assets/')) {
        _selectedAssetPath = savedPath;
        _selectedGalleryImage = null;
      } else {
        _selectedGalleryImage = File(savedPath);
      }
    });
  }

  Future<void> _saveProfileImage() async {
    final user = await _userService.getUserInfo();
    final oldPath = user.profileImagePath;

    String newPath;
    if (_selectedGalleryImage != null) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savePath = '${directory.path}/${fileName}';
      await _selectedGalleryImage!.copy(savePath);

      await _userService.updateProfileImage(savePath);
    } else {
      await _userService.updateProfileImage(_selectedAssetPath);
    }
  }

  Future<void> _showProfileImageDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppTheme.surfaceContainerLowest,
          insetPadding: const EdgeInsets.symmetric(horizontal: AppTheme.space4),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.onSurface, width: 2),
            ),
            padding: const EdgeInsets.all(AppTheme.space4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    Navigator.of(dialogContext).pop();
                    await _pickImageFromGallery();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppTheme.space4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer,
                      border: Border.all(color: AppTheme.primary, width: 2),
                    ),
                    child: Text(
                      '+ Upload From Gallery',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppTheme.primaryDim,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.space4),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: _defaultProfileImages.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: AppTheme.space3,
                    mainAxisSpacing: AppTheme.space3,
                  ),
                  itemBuilder: (context, index) {
                    final assetPath = _defaultProfileImages[index];
                    final isSelected =
                        _selectedGalleryImage == null &&
                        _selectedAssetPath == assetPath;
                    return InkWell(
                      onTap: () async {
                        setState(() {
                          _selectedGalleryImage = null;
                          _selectedAssetPath = assetPath;
                        });
                        await _saveProfileImage();
                        Navigator.of(dialogContext).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceContainerLow,
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primary
                                : AppTheme.onSurface,
                            width: 2,
                          ),
                          boxShadow: isSelected
                              ? const [
                                  BoxShadow(
                                    color: AppTheme.primary,
                                    offset: Offset(2, 2),
                                  ),
                                ]
                              : const [],
                        ),
                        padding: const EdgeInsets.all(AppTheme.space1),
                        child: Image.asset(assetPath, fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final file = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (file == null || !mounted) return;
    setState(() {
      _selectedGalleryImage = File(file.path);
    });
    await _saveProfileImage();
  }

  Future<void> _showEditNameDialog() async {
    _nameController.text = widget.user.userName;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppTheme.surfaceContainerLowest,
          insetPadding: const EdgeInsets.symmetric(horizontal: AppTheme.space4),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              final trimmed = _nameController.text.trim();
              final canSave = trimmed.isNotEmpty;
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.onSurface, width: 2),
                ),
                padding: const EdgeInsets.all(AppTheme.space4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EDIT USERNAME',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppTheme.secondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: AppTheme.space4),
                    TextField(
                      controller: _nameController,
                      autofocus: true,
                      textCapitalization: TextCapitalization.words,
                      cursorColor: AppTheme.primary,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.space3,
                          vertical: AppTheme.space3,
                        ),
                        hintText: 'ENTER NAME',
                        hintStyle: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppTheme.outline,
                              fontWeight: FontWeight.w800,
                            ),
                        filled: true,
                        fillColor: AppTheme.surfaceContainerLowest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: const BorderSide(
                            color: AppTheme.onSurface,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: const BorderSide(
                            color: AppTheme.onSurface,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: const BorderSide(
                            color: AppTheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (_) => setDialogState(() {}),
                    ),
                    const SizedBox(height: AppTheme.space4),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.of(dialogContext).pop(),
                            child: Container(
                              padding: const EdgeInsets.all(AppTheme.space4),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceContainerLow,
                                border: Border.all(
                                  color: AppTheme.onSurface,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                'CANCEL',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      color: AppTheme.onSurface,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppTheme.space3),
                        Expanded(
                          child: InkWell(
                            onTap: canSave
                                ? () async {
                                    await _userService.updateUserName(trimmed);
                                    if (!mounted) return;
                                    setState(() {
                                      widget.user.userName = trimmed;
                                    });
                                    Navigator.of(dialogContext).pop();
                                  }
                                : null,
                            child: Container(
                              padding: const EdgeInsets.all(AppTheme.space4),
                              decoration: BoxDecoration(
                                color: canSave
                                    ? AppTheme.primary
                                    : AppTheme.surfaceContainerLow,
                                border: Border.all(
                                  color: AppTheme.onSurface,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                'SAVE',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      color: canSave
                                          ? AppTheme.onPrimary
                                          : AppTheme.outline,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  ImageProvider<Object> _buildProfileImageProvider() {
    if (_selectedGalleryImage != null) {
      return FileImage(_selectedGalleryImage!);
    }
    return AssetImage(_selectedAssetPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.menu),
        ),
        title: const Text('FLORADEX'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppTheme.space4),
            child: Center(
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLowest,
                  border: Border.all(color: AppTheme.onSurface, width: 2),
                  boxShadow: const [
                    BoxShadow(color: AppTheme.primary, offset: Offset(-2, -2)),
                    BoxShadow(color: AppTheme.onSurface, offset: Offset(2, 2)),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.space1),
                  child: Image(
                    image: _buildProfileImageProvider(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(height: 4, color: const Color(0xFF78F38E)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppTheme.space4,
          AppTheme.space8,
          AppTheme.space4,
          AppTheme.space10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerLowest,
                    border: Border.all(color: AppTheme.onSurface, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: AppTheme.surfaceContainerHighest,
                        offset: Offset(2, 2),
                      ),
                      BoxShadow(
                        color: AppTheme.onSurface,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(AppTheme.space3),
                  child: Container(
                    width: 140,
                    height: 140,
                    color: AppTheme.secondaryContainer.withOpacity(0.4),
                    child: Image(
                      image: _buildProfileImageProvider(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: -6,
                  right: -6,
                  child: InkWell(
                    onTap: _showProfileImageDialog,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        border: Border.all(color: AppTheme.onSurface, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: AppTheme.onSurface,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 18,
                        color: AppTheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 68,
                  bottom: -16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.space4,
                      vertical: AppTheme.space2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.tertiary,
                      border: Border.all(color: AppTheme.onSurface, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: AppTheme.onSurface,
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      'LVL 15',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppTheme.onTertiary,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 44),
            Row(
              children: [
                Text(
                  widget.user.userName.toUpperCase(),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppTheme.primary,
                    fontSize: 28,
                    height: 1.3,
                  ),
                ),
                const SizedBox(width: AppTheme.space2),
                InkWell(
                  onTap: _showEditNameDialog,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      border: Border.all(color: AppTheme.onSurface, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: AppTheme.onSurface,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 18,
                      color: AppTheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.space3),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.secondaryContainer,
                border: Border.all(color: AppTheme.secondary, width: 2),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space3,
                vertical: AppTheme.space1,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.workspace_premium_outlined,
                    size: 14,
                    color: AppTheme.secondary,
                  ),
                  const SizedBox(width: AppTheme.space1),
                  Text(
                    widget.user.rankName.toUpperCase(),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppTheme.secondary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.space4),

            Text(
              'Dedicated researcher of rare mountain flora.\nSpecialized in high-altitude medicinal herbs and moss variations.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.outline,
                fontSize: 18,
                height: 1.9,
              ),
            ),
            const SizedBox(height: AppTheme.space6),
            FutureBuilder<int>(
              future: _scanCountFuture,
              builder: (context, snapshot) {
                final scanCount = snapshot.data ?? widget.user.userProgress;
                return Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        value: '$scanCount',
                        label: 'TOTAL SCANS',
                        valueColor: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppTheme.space4),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        value: '12',
                        label: 'RARE FINDS',
                        valueColor: AppTheme.secondary,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppTheme.space8),
            Text(
              'CATEGORIES DISCOVERED',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppTheme.secondary,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: AppTheme.space4),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: AppTheme.space4,
              mainAxisSpacing: AppTheme.space4,
              childAspectRatio: 1.7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStatCard(
                  context,
                  value: '42',
                  label: 'MEDICINAL',
                  valueColor: AppTheme.primary,
                ),
                _buildStatCard(
                  context,
                  value: '12',
                  label: 'POISONOUS',
                  valueColor: AppTheme.primary,
                ),
                _buildStatCard(
                  context,
                  value: '28',
                  label: 'EDIBLE',
                  valueColor: AppTheme.primary,
                ),
                _buildStatCard(
                  context,
                  value: '60',
                  label: 'DECORATIVE',
                  valueColor: AppTheme.primary,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.space8),
            _buildAchievementsHeader(context),
            const SizedBox(height: AppTheme.space4),
            GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: AppTheme.space4,
              mainAxisSpacing: AppTheme.space4,
              childAspectRatio: 0.85,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildAchievementBox(icon: Icons.eco, unlocked: true),
                _buildAchievementBox(icon: Icons.forest, unlocked: true),
                _buildAchievementBox(icon: Icons.water_drop, unlocked: true),
                _buildAchievementBox(icon: Icons.wb_sunny, unlocked: true),
                _buildAchievementBox(
                  icon: Icons.psychology_alt,
                  unlocked: false,
                ),
                _buildAchievementBox(
                  icon: Icons.shield_outlined,
                  unlocked: false,
                ),
                _buildAchievementBox(
                  icon: Icons.workspace_premium_outlined,
                  unlocked: false,
                ),
                _buildAchievementBox(
                  icon: Icons.science_outlined,
                  unlocked: false,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.space10),
            Text(
              'FIELD OPERATIONS',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppTheme.secondary,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: AppTheme.space4),
            _buildOperationButton(
              context,
              icon: Icons.notifications_none,
              label: 'NOTIFICATION SETTINGS',
            ),
            _buildOperationButton(
              context,
              icon: Icons.sync,
              label: 'SYNC DATA',
              trailingIcon: Icons.mail_outline,
              trailingColor: AppTheme.primary,
            ),
            _buildOperationButton(
              context,
              icon: Icons.logout,
              label: 'LOGOUT',
              color: AppTheme.error,
              borderColor: AppTheme.error,
              trailingIcon: null,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
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
            label: 'VAULT',
          ),
        ],
        onTap: (index) {
          Navigator.of(context).maybePop();
        },
      ),
    );
  }

  Widget _buildAchievementsHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFC90A),
        border: Border.all(color: AppTheme.onSurface, width: 2),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.space4,
        vertical: AppTheme.space4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'ACHIEVEMENTS',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: const Color(0xFF6C4E00),
              fontSize: 11,
            ),
          ),
          Text(
            '8 / 24 UNLOCKED',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: const Color(0xFF6C4E00),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String value,
    required String label,
    required Color valueColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        border: Border.all(color: AppTheme.outlineVariant, width: 2),
        boxShadow: const [
          BoxShadow(
            color: AppTheme.surfaceContainerHighest,
            offset: Offset(2, 2),
          ),
          BoxShadow(color: AppTheme.onSurface, offset: Offset(4, 4)),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        vertical: AppTheme.space6,
        horizontal: AppTheme.space3,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: valueColor,
              fontSize: 24,
              height: 1,
            ),
          ),
          const SizedBox(height: AppTheme.space3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppTheme.outline,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBox({
    required IconData icon,
    required bool unlocked,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: unlocked
            ? AppTheme.surfaceContainerLowest
            : AppTheme.surfaceContainerLowest.withOpacity(0.35),
        border: Border.all(
          color: unlocked ? AppTheme.primary : AppTheme.outlineVariant,
          width: 2,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Icon(
              icon,
              color: unlocked ? AppTheme.primary : AppTheme.outlineVariant,
              size: 34,
            ),
          ),
          if (unlocked)
            Positioned(
              top: -3,
              right: -3,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  border: Border.all(color: AppTheme.primary, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOperationButton(
    BuildContext context, {
    VoidCallback? onTap,
    required IconData icon,
    required String label,
    Color? color,
    Color? borderColor,
    IconData? trailingIcon = Icons.chevron_right,
    Color? trailingColor,
  }) {
    final effectiveColor = color ?? AppTheme.onSurface;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.space4),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLowest,
            border: Border.all(
              color: borderColor ?? AppTheme.onSurface,
              width: 2,
            ),
            boxShadow: const [
              BoxShadow(color: AppTheme.onSurface, offset: Offset(3, 3)),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.space4,
            vertical: AppTheme.space4,
          ),
          child: SizedBox(
            height: 40,
            child: Row(
              children: [
                Icon(icon, color: effectiveColor, size: 26),
                const SizedBox(width: AppTheme.space4),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: effectiveColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (trailingIcon != null)
                  Icon(
                    trailingIcon,
                    color: trailingColor ?? AppTheme.outline,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
