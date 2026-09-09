import 'package:flutter/material.dart';
import '../navigation/main_navigation_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/register_screen.dart';
import '../views/splash_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String navigation = '/navigation';

  static final routes = <String, WidgetBuilder>{
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    navigation: (context) => const MainNavigationScreen(),
  };
}
