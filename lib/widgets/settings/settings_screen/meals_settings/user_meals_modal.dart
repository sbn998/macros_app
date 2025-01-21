import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:macros_app/widgets/buttons/close_button_widget.dart';
import 'package:macros_app/widgets/settings/user_meals_list.dart';

class UserMealsModal extends StatelessWidget {
  const UserMealsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translations = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(
        translations.settingsAddEditMeals,
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: UserMealsListView(
          onChangedMeals: (changedData) {},
          userMeals: [],
        ),
      ),
      actions: [
        const CloseButtonWidget(),
        TextButton(
          onPressed: () async {
            // await handleConfirmation(dbUserMeals, callbackList);
            // if (!context.mounted) return;
            // Navigator.of(context).pop();
          },
          child: Text(translations.buttonsConfirm),
        ),
      ],
    );
  }
}
