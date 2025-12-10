import 'package:flutter/material.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/add_birthday/add_birthday_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String addBirthday = '/add-birthday';
  static const String settings = '/settings';

  static Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case addBirthday:
        return MaterialPageRoute(builder: (_) => const AddBirthdayScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
