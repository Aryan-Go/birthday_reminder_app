import 'package:intl/intl.dart';

class DateHelper {
  static String formatDate(DateTime date) {
    return DateFormat('MMMM d').format(date);
  }

  static String formatDateWithYear(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }

  static int getDaysUntil(DateTime birthday) {
    final now = DateTime.now();
    final thisYearBirthday = DateTime(now.year, birthday.month, birthday.day);

    if (thisYearBirthday.isBefore(now)) {
      final nextYearBirthday =
          DateTime(now.year + 1, birthday.month, birthday.day);
      return nextYearBirthday.difference(now).inDays;
    }

    return thisYearBirthday.difference(now).inDays;
  }

  static String getDaysUntilText(DateTime birthday) {
    final days = getDaysUntil(birthday);
    if (days == 0) return 'Today';
    if (days == 1) return 'Tomorrow';
    return 'in $days days';
  }

  static String getMonthName(int month) {
    return DateFormat('MMMM').format(DateTime(2024, month));
  }
}
