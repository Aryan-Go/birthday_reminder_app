import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'app.dart';
import 'core/utils/notification_service.dart';
import 'data/repositories/birthday_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone data
  tz.initializeTimeZones();

  // Initialize notification service
  await NotificationService().initialize();

  // Initialize repository
  final birthdayRepository = BirthdayRepository();
  await birthdayRepository.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => birthdayRepository),
      ],
      child: const BirthdayReminderApp(),
    ),
  );
}
