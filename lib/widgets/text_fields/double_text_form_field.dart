import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:macros_app/constants/map_entries.dart';
import 'package:macros_app/functions/validators/validators.dart';

class DoubleTextFormField extends StatelessWidget {
  final int maxLength;
  final String fieldLabel;
  final Function(String, String) onSavedCallback;

  const DoubleTextFormField({
    super.key,
    required this.maxLength,
    required this.fieldLabel,
    required this.onSavedCallback,
  });

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    final Map<String, String> localizationsMap = {
      kCaloriesKey: translations.calories,
      kProteinKey: translations.protein,
      kCarbsKey: translations.carbs,
      kFatsKey: translations.fats,
      kServingQuantityKey: translations.servingQuantity,
    };

    return TextFormField(
        maxLength: maxLength,
        decoration: InputDecoration(
          label: Text(localizationsMap[fieldLabel]!),
        ),
        validator: (value) {
          return validateDoubleValue(context, value!);
        },
        onSaved: (textFormFieldValue) {
          if (textFormFieldValue != null && textFormFieldValue.isNotEmpty) {
            onSavedCallback(fieldLabel, textFormFieldValue);
          }
        });
  }
}