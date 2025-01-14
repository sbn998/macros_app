import 'package:flutter/material.dart';

import 'package:macros_app/constants/map_entries.dart';
import 'package:macros_app/constants/max_string_length.dart';
import 'package:macros_app/widgets/text_fields/double_text_form_field.dart';
import 'package:macros_app/widgets/text_fields/name_text_form_fields.dart';

class AddGoalFormContent extends StatelessWidget {
  final Map<String, dynamic> callbackMap;
  final Function(Map<dynamic, dynamic>, String, String) onSavedDoubleCallback;
  final Function(Map<dynamic, dynamic>, String, String) onSavedNameCallback;

  const AddGoalFormContent({
    super.key,
    required this.callbackMap,
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
            callbackMap: callbackMap,
            minLength: kMinGoalNameLength,
            maxLength: kMaxGoalNameLength,
            fieldLabel: kGoalNameKey,
            onSavedCallback: onSavedNameCallback,
          ),
          DoubleTextFormField(
            callbackMap: callbackMap,
            maxLength: kMaxCaloriesLength,
            fieldLabel: kCaloriesKey,
            onSavedCallback: onSavedDoubleCallback,
          ),
          DoubleTextFormField(
            callbackMap: callbackMap,
            maxLength: kMaxMacroLength,
            fieldLabel: kFatsKey,
            onSavedCallback: onSavedDoubleCallback,
          ),
          DoubleTextFormField(
            callbackMap: callbackMap,
            maxLength: kMaxMacroLength,
            fieldLabel: kCarbsKey,
            onSavedCallback: onSavedDoubleCallback,
          ),
          DoubleTextFormField(
            callbackMap: callbackMap,
            maxLength: kMaxMacroLength,
            fieldLabel: kProteinKey,
            onSavedCallback: onSavedDoubleCallback,
          ),
        ],
      ),
    );
  }
}
