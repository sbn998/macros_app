import 'package:flutter/material.dart';

import 'package:macros_app/widgets/settings/settings_screen/goals_settings/goals_normal_dialog/saved_goals_dialog_content.dart';

Future<void> showMacroGoalsDialog(BuildContext context) async {
  if (!context.mounted) {
    return;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const SavedGoalsDialogContent(),
      );
    },
  );
}
