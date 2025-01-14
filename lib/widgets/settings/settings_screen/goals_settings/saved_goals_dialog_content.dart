import 'package:flutter/material.dart';
import 'package:macros_app/constants/enums.dart';
import 'package:macros_app/widgets/settings/settings_screen/goals_settings/add_goal_modal.dart';
import 'package:macros_app/widgets/settings/settings_screen/goals_settings/saved_goals_modal.dart';

class SavedGoalsDialogContent extends StatefulWidget {
  const SavedGoalsDialogContent({super.key});

  @override
  State<SavedGoalsDialogContent> createState() {
    return _SavedGoalsDialogContentState();
  }
}

class _SavedGoalsDialogContentState extends State<SavedGoalsDialogContent> {
  Mode _currentMode = Mode.normal;

  void _changeMode() {
    setState(() {
      if (_currentMode == Mode.normal) {
        _currentMode = Mode.adding;
      } else {
        _currentMode = Mode.normal;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: _currentMode == Mode.normal
          ? SavedGoalsModal(onTapGoal: _changeMode)
          : const AddGoalModal(),
    );
  }
}