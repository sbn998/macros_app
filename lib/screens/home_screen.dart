import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:macros_app/functions/detect_swipe_direction.dart';
import 'package:macros_app/functions/format_date.dart';
import 'package:macros_app/providers/date_provider.dart';
import 'package:macros_app/screens/food_screen.dart';
import 'package:macros_app/screens/logging_screen.dart';
import 'package:macros_app/screens/settings_screen.dart';
import 'package:macros_app/dialogs/show_calendar.dart';
import 'package:macros_app/widgets/home_screen/app_bar.dart';
import 'package:macros_app/widgets/home_screen/home_bottom_navigation_bar.dart';
import 'package:macros_app/widgets/home_screen/screen_body_selector.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeScreenAppBar(
        screenIndex: _selectedScreenIndex,
      ),
      body: HomeScreenBody(screenIndex: _selectedScreenIndex),
      bottomNavigationBar: HomeScreenBottomNavigationBar(
        onTap: _changeScreen,
        selectedScreenIndex: _selectedScreenIndex,
      ),
    );
  }
}
