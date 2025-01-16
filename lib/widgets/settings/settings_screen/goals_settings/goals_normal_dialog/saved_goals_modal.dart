import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macros_app/databases/daily_macro_goals_db.dart';
import 'package:macros_app/models/macro_goal_model.dart';

import 'package:macros_app/widgets/buttons/close_button_widget.dart';
import 'package:macros_app/widgets/settings/macro_goals_list.dart';

class SavedGoalsModal extends StatelessWidget {
  final DateTime? date;
  final Function() onTapGoal;

  const SavedGoalsModal({
    super.key,
    required this.onTapGoal,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translations = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);

    return contentColumn(translations, theme);
  }

  Column contentColumn(
    AppLocalizations translations,
    ThemeData theme,
  ) {
    return Column(
      verticalDirection: VerticalDirection.up,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CloseButtonWidget(
              buttonText: translations.buttonsClose,
            ),
          ],
        ),
        addGoalButton(translations, theme),
        MacroGoalsListView(date: date),
        const SizedBox(
          height: 25,
        ),
        Text(
          translations.yourMacroGoals,
          style: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget addGoalButton(AppLocalizations translations, ThemeData theme) {
    return Consumer(builder: (context, ref, _) {
      return TextButton(
          onPressed: null,
          child: GestureDetector(
            onTap: () {
              onTapGoal();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  translations.addNewGoal,
                  style: TextStyle(
                      fontSize: 15.0, color: theme.colorScheme.primary),
                ),
                Icon(
                  Icons.add,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ));
    });
  }
}
