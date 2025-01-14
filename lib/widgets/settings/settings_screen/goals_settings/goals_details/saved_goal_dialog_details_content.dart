import 'package:flutter/material.dart';

import 'package:macros_app/constants/enums.dart';
import 'package:macros_app/databases/daily_macro_goals_db.dart';
import 'package:macros_app/functions/initialize_goal_days_map.dart';
import 'package:macros_app/models/macro_goal_model.dart';
import 'package:macros_app/widgets/settings/settings_screen/goals_settings/goals_details/editing_goal_modal.dart';
import 'package:macros_app/widgets/settings/settings_screen/goals_settings/goals_details/normal_goal_details_modal.dart';

class SavedGoalDetailsDialogContent extends StatefulWidget {
  final MacroGoal tappedGoal;

  const SavedGoalDetailsDialogContent({
    super.key,
    required this.tappedGoal,
  });

  @override
  State<SavedGoalDetailsDialogContent> createState() {
    return _SavedGoalDetailsDialogContentState();
  }
}

class _SavedGoalDetailsDialogContentState extends State<SavedGoalDetailsDialogContent> {
  Mode _currentMode = Mode.normal;
  final Map<int, bool> _selectedDays = initializeGoalDaysMap();
  bool _isDataLoaded = false;

  Future<void> _getDaysForMacroGoal() async {
    final List<int> fetchedMacroGoalDays =
        await getDaysForGoal(widget.tappedGoal.id);

    for (var value in fetchedMacroGoalDays) {
      _selectedDays[value] = true;
    }
    setState(() {
      _isDataLoaded = true;
    });
  }

  void _changeMode() {
    setState(() {
      if (_currentMode == Mode.normal) {
        _currentMode = Mode.editing;
      } else {
        _currentMode = Mode.normal;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getDaysForMacroGoal();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: _isDataLoaded
          ? _currentMode == Mode.normal
              ? SavedGoalDetailsModal(
                  tappedGoal: widget.tappedGoal,
                  selectedDays: _selectedDays,
                  onPressEdit: _changeMode,
                )
              : EditingGoalModal(
                  selectedDays: _selectedDays,
                  tappedGoal: widget.tappedGoal,
                )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
