import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macros_app/functions/detect_swipe_direction.dart';
import 'package:macros_app/providers/date_provider.dart';

import 'package:macros_app/screens/food_screen.dart';
import 'package:macros_app/screens/logging_screen.dart';
import 'package:macros_app/screens/settings_screen.dart';

class HomeScreenBody extends StatelessWidget {
  final int screenIndex;

  const HomeScreenBody({
    super.key,
    required this.screenIndex,
  });

  @override
  Widget build(BuildContext context) {
    switch (screenIndex) {
      case 0:
        return const FoodScreen();
      case 1:
        return Consumer(
          builder: (contet, ref, _) {
            final DateTime selectedDate = ref.watch(selectedDateProvider);
            return GestureDetector(
              onHorizontalDragEnd: (details) => ref
                  .read(selectedDateProvider.notifier)
                  .state = detectSwipeDirection(selectedDate, details),
              child: const LoggingScreen(),
            );
          },
        );
      case 2:
        return const SettingsScreen();
      default:
        return const Center();
    }
  }
}
