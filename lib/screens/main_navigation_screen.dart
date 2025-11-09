import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finview_lite/screens/dashboard_screen.dart';
import 'package:finview_lite/screens/settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadDarkModePreference();
  }

  Future<void> _loadDarkModePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
    });
  }

  Future<void> _saveDarkModePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
  }

  void _toggleDarkMode(bool value) {
    setState(() => _isDarkMode = value);
    _saveDarkModePreference(value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF06B6D4),
          surface: Color(0xFFFFFFFF),
          onSurface: Color(0xFF1E293B),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF22D3EE),
          surface: Color(0xFF0F1419),
          onSurface: Color(0xFFF8FAFC),
        ),
      ),
      home: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            DashboardScreen(isDarkMode: _isDarkMode),
            SettingsScreen(
              isDarkMode: _isDarkMode,
              onThemeChanged: _toggleDarkMode,
            ),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() => _selectedIndex = index);
            },
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            height: 60,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined, size: 20),
                selectedIcon: Icon(Icons.dashboard, size: 20),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined, size: 20),
                selectedIcon: Icon(Icons.settings, size: 20),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
