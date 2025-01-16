import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:macros_app/dialogs/settings/settings_macro_goals_dialog.dart';

class EmptyDailyMacroGoal extends StatelessWidget {
  final DateTime? date;

  const EmptyDailyMacroGoal({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.18,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.noGoals,
            style: const TextStyle(fontSize: 15.0),
          ),
          const SizedBox(
            height: 18,
          ),
          GestureDetector(
            onTap: () {
              showMacroGoalsDialog(
                context,
                date,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.buttonsStartAddingGoal,
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Theme.of(context).colorScheme.primary),
                ),
                Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
