import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/birthday_model.dart';
import '../../core/utils/notification_service.dart';

class BirthdayRepository extends ChangeNotifier {
  List _birthdays = [];
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
  
  List get birthdays => _birthdays;
  TimeOfDay get reminderTime => _reminderTime;

  Future initialize() async {
    await _loadBirthdays();
    await _loadReminderTime();
  }

  Future _loadBirthdays() async {
    final prefs = await SharedPreferences.getInstance();
    final birthdaysJson = prefs.getStringList('birthdays') ?? [];
    _birthdays = birthdaysJson
        .map((json) => Birthday.fromJson(jsonDecode(json)))
        .toList();
    _sortBirthdays();
    notifyListeners();
  }

  Future _saveBirthdays() async {
    final prefs = await SharedPreferences.getInstance();
    final birthdaysJson = _birthdays
        .map((birthday) => jsonEncode(birthday.toJson()))
        .toList();
    await prefs.setStringList('birthdays', birthdaysJson);
  }

  Future _loadReminderTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt('reminder_hour') ?? 9;
    final minute = prefs.getInt('reminder_minute') ?? 0;
    _reminderTime = TimeOfDay(hour: hour, minute: minute);
    notifyListeners();
  }

  Future setReminderTime(TimeOfDay time) async {
    _reminderTime = time;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reminder_hour', time.hour);
    await prefs.setInt('reminder_minute', time.minute);
    
    // Reschedule all notifications with new time
    for (final birthday in _birthdays) {
      await NotificationService().scheduleBirthdayReminder(birthday, _reminderTime);
    }
    
    notifyListeners();
  }

  Future addBirthday(Birthday birthday) async {
    _birthdays.add(birthday);
    _sortBirthdays();
    await _saveBirthdays();
    await NotificationService().scheduleBirthdayReminder(birthday, _reminderTime);
    notifyListeners();
  }

  Future updateBirthday(Birthday birthday) async {
    final index = _birthdays.indexWhere((b) => b.id == birthday.id);
    if (index != -1) {
      _birthdays[index] = birthday;
      _sortBirthdays();
      await _saveBirthdays();
      await NotificationService().scheduleBirthdayReminder(birthday, _reminderTime);
      notifyListeners();
    }
  }

  Future deleteBirthday(String id) async {
    _birthdays.removeWhere((b) => b.id == id);
    await _saveBirthdays();
    await NotificationService().cancelAllNotifications(id);
    notifyListeners();
  }

  void _sortBirthdays() {
    _birthdays.sort((a, b) {
      final now = DateTime.now();
      final aThisYear = DateTime(now.year, a.date.month, a.date.day);
      final bThisYear = DateTime(now.year, b.date.month, b.date.day);
      
      final aNext = aThisYear.isBefore(now) 
          ? DateTime(now.year + 1, a.date.month, a.date.day)
          : aThisYear;
      final bNext = bThisYear.isBefore(now)
          ? DateTime(now.year + 1, b.date.month, b.date.day)
          : bThisYear;
      
      return aNext.compareTo(bNext);
    });
  }

  Map<int, List<Birthday>> getBirthdaysByMonth() {
    final Map<int, List<Birthday>> grouped = {};
    for (final birthday in _birthdays) {
      final month = birthday.date.month;
      if (!grouped.containsKey(month)) {
        grouped[month] = [];
      }
      grouped[month]!.add(birthday);
    }
    return grouped;
  }
}