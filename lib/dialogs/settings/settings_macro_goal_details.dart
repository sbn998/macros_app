import 'package:flutter/material.dart';

import 'package:macros_app/models/macro_goal_model.dart';
import 'package:macros_app/widgets/settings/settings_screen/goals_settings/goals_details/saved_goal_dialog_details_content.dart';

enum MacroGoalFields {
  calories,
  protein,
  carbs,
  fats,
}

void showMacroGoalDetails(BuildContext context, MacroGoal tappedMacroGoal) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SavedGoalDetailsDialogContent(tappedGoal: tappedMacroGoal),
      );
    },
  );
}
