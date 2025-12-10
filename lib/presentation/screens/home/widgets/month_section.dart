import 'package:flutter/material.dart';
import '../../../../core/constants/app_colours.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../data/models/birthday_model.dart';
import 'birthday_list_item.dart';

class MonthSection extends StatelessWidget {
  final int month;
  final List birthdays;

  const MonthSection({
    super.key,
    required this.month,
    required this.birthdays,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            DateHelper.getMonthName(month),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...birthdays.map((birthday) => BirthdayListItem(birthday: birthday)),
      ],
    );
  }
}
