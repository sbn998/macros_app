import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:macros_app/dialogs/settings/settings_macro_goals_dialog.dart';
import 'package:macros_app/dialogs/settings/settings_meals_dialog.dart';

late WidgetRef _ref;

class SettingsScreen extends StatelessWidget {
  final WidgetRef ref;

  const SettingsScreen({super.key, required this.ref});

  @override
  Widget build(BuildContext context) {
    _ref = ref;

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
        settingName: 'Add/Edit your meals',
        icon: Icons.edit,
      ),
      _buildInkWell(
        onTap: () {
          showMacroGoalsDialog(context, _ref);
        },
        settingName: 'Add/Edit your macro goals',
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
