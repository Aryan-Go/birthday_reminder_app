import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colours.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_router.dart';
import '../../../data/repositories/birthday_repository.dart';
import 'widgets/birthday_list_item.dart';
import 'widgets/month_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State {
  bool _isListView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.cake, size: 28),
          onPressed: () {},
        ),
        title: const Text(AppStrings.birthdays),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.settings);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildViewToggle(),
          Expanded(
            child: _isListView ? _buildListView() : _buildCalendarView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRouter.addBirthday);
        },
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }

  Widget _buildViewToggle() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
              AppStrings.list,
              _isListView,
              () => setState(() => _isListView = true),
            ),
          ),
          Expanded(
            child: _buildToggleButton(
              AppStrings.calendar,
              !_isListView,
              () => setState(() => _isListView = false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return Consumer<BirthdayRepository>(
      builder: (context, repository, child) {
        final birthdaysByMonth = repository.getBirthdaysByMonth();

        if (birthdaysByMonth.isEmpty) {
          return const Center(
            child: Text(
              'No birthdays added yet.\nTap + to add one!',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: birthdaysByMonth.length,
          itemBuilder: (context, index) {
            final month = birthdaysByMonth.keys.elementAt(index);
            final birthdays = birthdaysByMonth[month]!;
            return MonthSection(month: month, birthdays: birthdays);
          },
        );
      },
    );
  }

  Widget _buildCalendarView() {
    return const Center(
      child: Text(
        'Calendar View\n(Coming Soon)',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
      ),
    );
  }
}
