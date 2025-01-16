import 'package:flutter/material.dart';
import 'package:macros_app/constants/enums.dart';
import 'package:macros_app/widgets/settings/settings_screen/goals_settings/goals_normal_dialog/add_goal_modal.dart';
import 'package:macros_app/widgets/settings/settings_screen/goals_settings/goals_normal_dialog/saved_goals_modal.dart';

class SavedGoalsDialogContent extends StatefulWidget {
  final DateTime? date;

  const SavedGoalsDialogContent({
    super.key,
    required this.date,
  });

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
          ? SavedGoalsModal(onTapGoal: _changeMode, date: widget.date)
          : AddGoalModal(onAddedGoal: _changeMode),
    );
  }
}
