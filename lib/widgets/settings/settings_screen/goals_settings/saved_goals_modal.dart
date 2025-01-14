import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:macros_app/databases/macro_goals_db.dart';
import 'package:macros_app/models/macro_goal_model.dart';
import 'package:macros_app/widgets/buttons/close_button_widget.dart';
import 'package:macros_app/widgets/settings/macro_goals_list.dart';

class SavedGoalsModal extends StatelessWidget {
  final Function() onTapGoal;

  const SavedGoalsModal({
    super.key,
    required this.onTapGoal,
  });

  Future<List<MacroGoal>> _loadMacroGoals() async {
    return await getMacroGoals();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translations = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);

    return FutureBuilder(
        future: _loadMacroGoals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return contentColumn(translations, theme, snapshot);
          }
        });
  }

  Column contentColumn(
    AppLocalizations translations,
    ThemeData theme,
    AsyncSnapshot<List<MacroGoal>> snapshot,
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
        MacroGoalsListView(dbMacroGoals: snapshot.data!),
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

  TextButton addGoalButton(AppLocalizations translations, ThemeData theme) {
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
                style:
                    TextStyle(fontSize: 15.0, color: theme.colorScheme.primary),
              ),
              Icon(
                Icons.add,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ));
  }
}
