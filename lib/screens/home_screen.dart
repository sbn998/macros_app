import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:macros_app/constants/durations.dart';
import 'package:macros_app/providers/date_provider.dart';
import 'package:macros_app/screens/food_screen.dart';
import 'package:macros_app/screens/logging_screen.dart';
import 'package:macros_app/screens/settings_screen.dart';
import 'package:macros_app/dialogs/show_calendar.dart';

// TODO: Implement database to save settings.

class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScreen> createState() {
    return _HomeScreenState();
  }

  const HomeScreen({super.key});
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedScreenIndex = 1;

  void _changeScreen(int screenTabIndex) {
    setState(() {
      _selectedScreenIndex = screenTabIndex;
    });
  }

  void _detectSwipeDirection(DateTime date, DragEndDetails dragDetails) {
    if (dragDetails.primaryVelocity! > 0) {
      // Velocity > 0 = dragging right.
      ref.read(selectedDateProvider.notifier).state =
          date.subtract(const Duration(days: 1));
    } else if (dragDetails.primaryVelocity! < 0) {
      // Velocity < 0 = dragging left.
      ref.read(selectedDateProvider.notifier).state =
          date.add(const Duration(days: 1));
    }
  }

  Widget _buildGestureDetector(DateTime date) {
    return GestureDetector(
      onHorizontalDragEnd: (details) => _detectSwipeDirection(date, details),
      child: const SingleChildScrollView(
        child: LoggingScreen(),
      ),
    );
  }

  Widget _bottomTabScreensSelector(int selectedTab, DateTime date) {
    switch (selectedTab) {
      // 0 = LoggingScreen.
      case 0:
        return const FoodScreen();
      case 1:
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: _buildGestureDetector(date),
        );
      case 2:
        return const SettingsScreen();
      default:
        return const Text('');
    }
  }

  String _formatDate(DateTime selectedDate) {
    final today = DateTime.now();
    if (isSameDay(today, selectedDate)) {
      return AppLocalizations.of(context)!.dateToday;
    } else if (isSameDay(today.subtract(kOneDayDuration), selectedDate)) {
      return AppLocalizations.of(context)!.dateYesterday;
    } else if (isSameDay(today.add(kOneDayDuration), selectedDate)) {
      return AppLocalizations.of(context)!.dateTomorrow;
    } else {
      // Formats as 'January 1'.
      return DateFormat('MMMM d').format(selectedDate);
    }
  }

  String _setAppBarTitle(DateTime selectedDate) {
    switch (_selectedScreenIndex) {
      case 0:
        return AppLocalizations.of(context)!.screensYourFood;
      case 1:
        return _formatDate(selectedDate);
      case 2:
        return AppLocalizations.of(context)!.screensSettings;
      default:
        return '';
    }
  }

  PreferredSizeWidget _buildAppBar(DateTime selectedDate) {
    return AppBar(
      title: Text(
        _setAppBarTitle(selectedDate),
        style: Theme.of(context).textTheme.titleLarge,
      ),
      centerTitle: true,
      actions: [
        if (_selectedScreenIndex == 1)
          IconButton(
            onPressed: () {
              showCalendar(context);
            },
            icon: const Icon(Icons.calendar_month),
          ),
      ],
    );
  }

  Widget _buildBottomNavigationbar() {
    return BottomNavigationBar(
      onTap: _changeScreen,
      currentIndex: _selectedScreenIndex,
      items: [
        BottomNavigationBarItem(
            icon: const Icon(Icons.food_bank),
            label: AppLocalizations.of(context)!.labelsYourFood),
        BottomNavigationBarItem(
            icon: const Icon(Icons.note_add),
            label: AppLocalizations.of(context)!.labelsMeals),
        BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppLocalizations.of(context)!.labelsSettings),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);

    return Scaffold(
      appBar: _buildAppBar(selectedDate),
      body: _bottomTabScreensSelector(_selectedScreenIndex, selectedDate),
      bottomNavigationBar: _buildBottomNavigationbar(),
    );
  }
}
