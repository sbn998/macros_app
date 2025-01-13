import 'package:flutter/material.dart';

import 'package:macros_app/models/logged_meal_model.dart';
import 'package:macros_app/models/user_meal_model.dart';
import 'package:macros_app/widgets/logging_screen/logging_dialog.dart';

void showAddMealDialog(
  BuildContext context,
  UserMeal? selectedUserMeal,
  LoggedMeal? selectedLoggedMeal,
) {
  showDialog(
    context: context,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: LoggingDialog(
          selectedUserMeal: selectedUserMeal,
          selectedLoggedMeal: selectedLoggedMeal,
        ),
      );
    },
  );
}
