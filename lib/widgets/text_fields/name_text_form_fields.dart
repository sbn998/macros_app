import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:macros_app/constants/map_entries.dart';
import 'package:macros_app/functions/validators/validators.dart';

class NameTextFormField extends StatelessWidget {
  final int maxLength;
  final int minLength;
  final String fieldLabel;
  final Function(String, String) onSavedCallback;

  const NameTextFormField({
    super.key,
    required this.maxLength,
    required this.minLength,
    required this.fieldLabel,
    required this.onSavedCallback,
  });

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    final Map<String, String> localizationsMap = {
      kFoodNameKey: translations.foodName,
      kServingNameKey: translations.servingName,
    };

    return TextFormField(
      maxLength: maxLength,
      decoration: InputDecoration(
        label: Text(localizationsMap[fieldLabel]!),
      ),
      validator: (value) {
        return validateName(
          context,
          value!,
          maxLength,
          minLength,
        );
      },
      onSaved: (textFormFieldFoodName) {
        onSavedCallback(fieldLabel, textFormFieldFoodName!);
      },
    );
  }
}
