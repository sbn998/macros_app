import 'package:flutter/material.dart';

import 'package:macros_app/widgets/settings/settings_screen/meals_settings/saved_user_meals_dialog_content.dart';

Future<void> showUserMealsDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) {
      return const SavedUserMealsDialogContent();
    },
  );
}
