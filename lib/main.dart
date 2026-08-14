import 'package:floradex/models/user_info.dart';
import 'package:floradex/screens/botanical_vault.dart';
import 'package:floradex/screens/dashboard.dart';
import 'package:floradex/screens/debug_vault_screen.dart';
import 'package:floradex/screens/researcher_profile.dart';
import 'package:floradex/screens/scanner.dart';
import 'package:floradex/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:floradex/theme/app_theme.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:floradex/models/plant_record.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:floradex/services/achievement_event_bus_scope.dart';

late final UserInfo currentUser;

Future<void> bootstrapUserInfo() async {
  final userBox = await Hive.openBox<UserInfo>('user_data');
  final uuid = Uuid();
  final storedUser = userBox.get('current_user');

  if (storedUser == null) {
    final defaultUser = UserInfo()
      ..userId = uuid.v8()
      ..userName = 'Unknown User'
      ..userEmail = ''
      ..rankName = 'Wild Seed'
      ..userProgress = 0
      ..profileImagePath = 'assets/default_profile/male1.png';

    await userBox.put('current_user', defaultUser);
    currentUser = defaultUser;
  } else {
    currentUser = storedUser;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(PlantRecordAdapter());
  Hive.registerAdapter(UserInfoAdapter());

  await Hive.openBox<PlantRecord>('plants_vault');
  await bootstrapUserInfo();

  await dotenv.load(fileName: ".env");
  runApp(const FloraDexApp());
}

class FloraDexApp extends StatelessWidget {
  const FloraDexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloraDex',
      theme: AppTheme.theme,
      home: const AchievementEventBusScope(child: MainScreen()),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final UserService _userService = UserService();

  String _profileImagePath = 'assets/default_profile/male1.png';
  File? _profileGalleryImage;
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _pages = [
      DashboardPage(
        onViewAllTap: () {
          setState(() {
            _currentIndex = 2;
          });
        },
      ),
      ScannerPage(),
      BotanicalVaultPage(),
    ];
  }

  Future<void> _loadProfileImage() async {
    final user = await _userService.getUserInfo();
    final savedPath = user.profileImagePath.isEmpty
        ? 'assets/default_profile/male1.png'
        : user.profileImagePath;

    if (!mounted) return;

    setState(() {
      if (savedPath.startsWith('assets/')) {
        _profileImagePath = savedPath;
        _profileGalleryImage = null;
      } else {
        _profileGalleryImage = File(savedPath);
      }
    });
  }

  ImageProvider<Object> _buildProfileImageProvider() {
    if (_profileGalleryImage != null) {
      return FileImage(_profileGalleryImage!);
    }
    return AssetImage(_profileImagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FLORADEX'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppTheme.space4),
            child: Center(
              child: InkWell(
                onTap: () async {
                  if (_currentIndex == 1) {
                    setState(() {
                      _currentIndex = 0;
                    });
                  }

                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          ResearcherProfileScreen(user: currentUser),
                    ),
                  );

                  await _loadProfileImage();
                },
                onLongPress: () {
                  if (_currentIndex == 1) {
                    setState(() {
                      _currentIndex = 0;
                    });
                  }

                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => DebugVaultScreen()));
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerLowest,
                    border: Border.all(color: AppTheme.onSurface, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: AppTheme.primary,
                        offset: Offset(-2, -2),
                      ),
                      BoxShadow(
                        color: AppTheme.onSurface,
                        offset: Offset(2, 2),
                      ),
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
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppTheme.outlineVariant.withOpacity(0.2)),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.home_outlined, _currentIndex == 0),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(
                Icons.camera_alt_outlined,
                _currentIndex == 1,
              ),
              label: 'SCAN',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(
                Icons.inventory_2_outlined,
                _currentIndex == 2,
              ),
              label: 'VAULT',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, bool isActive) {
    if (isActive) {
      return Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppTheme.primaryContainer,
          border: Border.all(color: AppTheme.onSurface, width: 2),
          boxShadow: const [
            BoxShadow(color: AppTheme.onSurface, offset: Offset(2, 2)),
          ],
        ),
        child: Icon(icon, color: AppTheme.primary, size: 20),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Icon(icon, size: 24),
    );
  }
}
