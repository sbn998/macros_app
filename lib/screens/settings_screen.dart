import 'package:flutter/material.dart';

import 'package:macros_app/widgets/settings/settings_screen/settings_list.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SettingsList(),
          ],
        ));
  }
}
