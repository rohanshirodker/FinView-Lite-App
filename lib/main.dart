import 'package:flutter/material.dart';
import 'package:finview_lite/theme.dart';
import 'package:finview_lite/services/auth_service.dart';
import 'package:finview_lite/screens/login_screen.dart';
import 'package:finview_lite/screens/main_navigation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinView Lite',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService().isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        final isLoggedIn = snapshot.data ?? false;
        return isLoggedIn ? const MainNavigationScreen() : const LoginScreen();
      },
    );
  }
}
