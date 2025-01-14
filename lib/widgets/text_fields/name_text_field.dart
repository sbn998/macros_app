import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:macros_app/constants/map_entries.dart';
import 'package:macros_app/functions/update_map_values.dart';

class NameTextField extends StatelessWidget {
  final Map<String, dynamic> callbackMap;
  final TextEditingController controller;
  final String mapKey;

  const NameTextField({
    super.key,
    required this.callbackMap,
    required this.controller,
    required this.mapKey,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translations = AppLocalizations.of(context)!;
    final localizationMap = {
      kFoodNameKey: translations.foodName,
      kServingNameKey: translations.servingName,
      kGoalNameKey: translations.macroGoalName,
    };

    return TextField(
      keyboardType: TextInputType.visiblePassword,
      controller: controller,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: localizationMap[mapKey],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      onChanged: (newValue) {
        if (newValue.isNotEmpty) {
          updateStringValue(
            callbackMap,
            mapKey,
            newValue,
          );
        }
      },
    );
  }
}
