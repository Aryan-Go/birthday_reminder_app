import 'package:flutter/material.dart';
import 'core/constants/app_theme.dart';
import 'core/routes/app_router.dart';

class BirthdayReminderApp extends StatelessWidget {
  const BirthdayReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Birthday Reminders',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRouter.home,
    );
  }
}
