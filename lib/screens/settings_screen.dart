import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:macros_app/dialogs/settings/settings_macro_goals_dialog.dart';
import 'package:macros_app/dialogs/settings/settings_meals_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: _buildSettingsScreenContent(context),
    );
  }
}

Widget _buildSettingsScreenContent(BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: _buildListView(context),
        ),
      ),
    ],
  );
}

Widget _buildListView(BuildContext context) {
  return ListView(
    shrinkWrap: true,
    children: [
      _buildInkWell(
        onTap: () {
          showUserMealsDialog(context);
        },
        settingName: AppLocalizations.of(context)!.settingsAddEditMeals,
        icon: Icons.edit,
      ),
      _buildInkWell(
        onTap: () {
          showMacroGoalsDialog(context);
        },
        settingName: AppLocalizations.of(context)!.settingsAddEditGoals,
        icon: Icons.edit,
      ),
    ],
  );
}

Widget _buildInkWell({
  VoidCallback? onTap,
  required String settingName,
  required IconData icon,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: InkWell(
      onTap: onTap,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Text(
                    settingName,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Icon(icon),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
