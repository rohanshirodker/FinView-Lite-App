import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:finview_lite/services/auth_service.dart';
import 'package:finview_lite/screens/main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  bool _isLoading = false;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserFromPortfolio();
  }

  Future<void> _loadUserFromPortfolio() async {
    try {
      final jsonString = await rootBundle.loadString('assets/portfolio.json');
      final data = jsonDecode(jsonString);
      setState(() {
        _userName = data['user'];
      });
    } catch (e) {
      debugPrint('Error loading user: $e');
    }
  }

  Future<void> _handleLogin() async {
    if (_userName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load user name')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));

    final success = await _authService.login(_userName!);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1A1F26) : const Color(0xFFF8FAFC);
    final border = isDark ? const Color(0xFF2A3340) : const Color(0xFFE8EDF2);
    final textSecondary =
    isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/logo.png',
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: 24),
                Text(
                  'FinView Lite',
                  style: theme.textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your Investment Dashboard',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 48),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cardBg,
                    border: Border.all(color: border, width: 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _userName != null
                            ? 'Welcome,  $_userName'
                            : 'Loading user...',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed:
                          _isLoading || _userName == null ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          )
                              : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
