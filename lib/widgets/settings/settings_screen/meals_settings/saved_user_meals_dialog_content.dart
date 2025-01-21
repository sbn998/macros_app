import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:macros_app/widgets/buttons/close_button_widget.dart';
import 'package:macros_app/widgets/buttons/confirm_button_widget.dart';
import 'package:macros_app/widgets/settings/user_meals_list.dart';

class SavedUserMealsDialogContent extends StatelessWidget {
  const SavedUserMealsDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    void closeDialog() {
      Navigator.of(context).pop();
    }

    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.settingsAddEditMeals,
        textAlign: TextAlign.center,
      ),
      content: const SizedBox(
        width: double.maxFinite,
        child: UserMealsListView(),
      ),
      actions: [
        const CloseButtonWidget(),
        ConfirmButtonWidget(callback: closeDialog),
      ],
    );
  }
}
