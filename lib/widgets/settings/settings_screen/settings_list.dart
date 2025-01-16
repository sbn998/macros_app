import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:macros_app/dialogs/settings/settings_macro_goals_dialog.dart';
import 'package:macros_app/dialogs/settings/settings_meals_dialog.dart';
import 'package:macros_app/widgets/settings/settings_screen/settings_inkwell.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translations = AppLocalizations.of(context)!;
    final ScrollController scrollController = ScrollController();

    return Expanded(
      child: Scrollbar(
        controller: scrollController,
        child: ListView(
          controller: scrollController,
          shrinkWrap: true,
          children: [
            SettingsInkwell(
              onTap: () {
                showUserMealsDialog(context);
              },
              settingName: translations.settingsAddEditMeals,
              icon: Icons.edit,
            ),
            SettingsInkwell(
              onTap: () {
                showMacroGoalsDialog(context, null);
              },
              settingName: translations.settingsAddEditGoals,
              icon: Icons.edit,
            ),
          ],
        ),
      ),
    );
  }
}
