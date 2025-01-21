import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:macros_app/constants/map_entries.dart';
import 'package:macros_app/functions/update_map_values.dart';

class DoubleTextField extends StatelessWidget {
  final Map<String, dynamic> callbackMap;
  final TextEditingController controller;
  final String mapKey;

  const DoubleTextField({
    super.key,
    required this.callbackMap,
    required this.controller,
    required this.mapKey,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translations = AppLocalizations.of(context)!;
    final bool isServingName = mapKey == kServingNameKey;
    final Map<String, String> localizationMap = {
      kCaloriesKey: translations.calories,
      kFatsKey: translations.fats,
      kCarbsKey: translations.carbs,
      kProteinKey: translations.protein,
      kServingQuantityKey: translations.servingQuantity,
      kServingNameKey: translations.servingName,
    };

    void updateValues(String newValue) {
      if (isServingName) {
        updateStringValue(callbackMap, mapKey, newValue);
      } else {
        updateDoubleValue(callbackMap, mapKey, newValue);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        keyboardType: isServingName
            ? TextInputType.visiblePassword
            : TextInputType.number,
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
            updateValues(newValue);
          }
        },
      ),
    );
  }
}
