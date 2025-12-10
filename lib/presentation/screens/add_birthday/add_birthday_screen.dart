import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colours.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/birthday_model.dart';
import '../../../data/repositories/birthday_repository.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/reminder_chip.dart';

class AddBirthdayScreen extends StatefulWidget {
  const AddBirthdayScreen({super.key});

  @override
  State createState() => _AddBirthdayScreenState();
}

class _AddBirthdayScreenState extends State {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedReminder = 'On the day';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(AppStrings.addBirthday),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              AppStrings.cancel,
              style: TextStyle(color: AppColors.primary, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.name,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _nameController,
              hint: AppStrings.enterName,
            ),
            const SizedBox(height: 32),
            const Text(
              AppStrings.birthday,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate == null
                          ? AppStrings.selectDate
                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      style: TextStyle(
                        color: _selectedDate == null
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                    const Icon(Icons.calendar_today,
                        color: AppColors.iconColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Phone Number (Optional)',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _phoneController,
              hint: 'Enter phone number with country code',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 32),
            const Text(
              AppStrings.remindMe,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: [
                ReminderChip(
                  label: AppStrings.onTheDay,
                  isSelected: _selectedReminder == 'On the day',
                  onTap: () => setState(() => _selectedReminder = 'On the day'),
                ),
                ReminderChip(
                  label: AppStrings.oneDayBefore,
                  isSelected: _selectedReminder == '1 day before',
                  onTap: () =>
                      setState(() => _selectedReminder = '1 day before'),
                ),
                ReminderChip(
                  label: AppStrings.oneWeekBefore,
                  isSelected: _selectedReminder == '1 week before',
                  onTap: () =>
                      setState(() => _selectedReminder = '1 week before'),
                ),
              ],
            ),
            const SizedBox(height: 48),
            CustomButton(
              text: AppStrings.saveBirthday,
              onPressed: _saveBirthday,
            ),
          ],
        ),
      ),
    );
  }

  Future _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  void _saveBirthday() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name')),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date')),
      );
      return;
    }

    final birthday = Birthday(
      name: _nameController.text,
      date: _selectedDate!,
      phoneNumber:
          _phoneController.text.isNotEmpty ? _phoneController.text : null,
      remindOnDay: _selectedReminder == 'On the day',
      remindOneDayBefore: _selectedReminder == '1 day before',
      remindOneWeekBefore: _selectedReminder == '1 week before',
    );

    context.read<BirthdayRepository>().addBirthday(birthday);
    Navigator.pop(context);
  }
}
