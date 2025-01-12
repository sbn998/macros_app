import 'package:flutter/material.dart';

import 'package:macros_app/constants/map_entries.dart';
import 'package:macros_app/constants/max_string_length.dart';
import 'package:macros_app/widgets/text_fields/double_text_form_field.dart';
import 'package:macros_app/widgets/text_fields/name_text_form_fields.dart';

class AddFoodFormContent extends StatelessWidget {
  final Function(String, String) onSavedDoubleCallback;
  final Function(String, String) onSavedNameCallback;

  const AddFoodFormContent({
    super.key,
    required this.onSavedDoubleCallback,
    required this.onSavedNameCallback,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NameTextFormField(
            minLength: kMinFoodNameLength,
            maxLength: kMaxFoodNameLength,
            fieldLabel: kFoodNameKey,
            onSavedCallback: onSavedNameCallback,
          ),
          DoubleTextFormField(
            maxLength: kMaxCaloriesLength,
            fieldLabel: kCaloriesKey,
            onSavedCallback: onSavedDoubleCallback,
          ),
          DoubleTextFormField(
            maxLength: kMaxMacroLength,
            fieldLabel: kFatsKey,
            onSavedCallback: onSavedDoubleCallback,
          ),
          DoubleTextFormField(
            maxLength: kMaxMacroLength,
            fieldLabel: kCarbsKey,
            onSavedCallback: onSavedDoubleCallback,
          ),
          DoubleTextFormField(
            maxLength: kMaxMacroLength,
            fieldLabel: kProteinKey,
            onSavedCallback: onSavedDoubleCallback,
          ),
          DoubleTextFormField(
            maxLength: kMaxServingQuantityLength,
            fieldLabel: kServingQuantityKey,
            onSavedCallback: onSavedDoubleCallback,
          ),
          NameTextFormField(
            minLength: kMinServingNameLength,
            maxLength: kMaxServingNameLength,
            fieldLabel: kServingNameKey,
            onSavedCallback: onSavedNameCallback,
          ),
        ],
      ),
    );
  }
}
