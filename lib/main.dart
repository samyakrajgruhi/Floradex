import 'package:floradex/screens/botanical_vault.dart';
import 'package:floradex/screens/dashboard.dart';
import 'package:floradex/screens/researcher_profile.dart';
import 'package:floradex/screens/scanner.dart';
import 'package:flutter/material.dart';
import 'package:floradex/theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:floradex/models/plant_record.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PlantRecordAdapter());
  await Hive.openBox<PlantRecord>('plants_vault');

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
      home: const MainScreen(),
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
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    ScannerPage(),
    BotanicalVaultPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FLORADEX'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: AppTheme.space4),
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ResearcherProfileScreen()),
                );
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.secondaryContainer,
                  border: Border.all(color: AppTheme.onSurface, width: 2),
                ),
                child: const Icon(
                  Icons.person,
                  size: 20,
                  color: AppTheme.onSecondaryContainer,
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
