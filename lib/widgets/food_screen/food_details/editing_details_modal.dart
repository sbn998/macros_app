import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:macros_app/constants/map_entries.dart';
import 'package:macros_app/models/food_model.dart';
import 'package:macros_app/providers/saved_food_provider.dart';
import 'package:macros_app/widgets/buttons/close_button_widget.dart';
import 'package:macros_app/widgets/buttons/confirm_button_widget.dart';
import 'package:macros_app/widgets/text_fields/double_text_field.dart';
import 'package:macros_app/widgets/text_fields/name_text_field.dart';

class EditingSavedFoodModal extends StatefulWidget {
  final Food tappedFood;

  const EditingSavedFoodModal({
    super.key,
    required this.tappedFood,
  });

  @override
  State<EditingSavedFoodModal> createState() {
    return _EditingDetailsModalState();
  }
}

class _EditingDetailsModalState extends State<EditingSavedFoodModal> {
  late Map<String, dynamic> _editableValues;
  late Map<String, TextEditingController> _controllers;

  void _populateControllers() {
    _controllers = {};
    for (var key in _editableValues.keys) {
      _controllers[key] =
          TextEditingController(text: _editableValues[key]?.toString() ?? '');
    }
  }

  @override
  void initState() {
    super.initState();
    _editableValues = widget.tappedFood.toMap();
    _populateControllers();
  }

  @override
  void dispose() {
    _controllers.forEach((key, value) => value.dispose());
    _controllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translations = AppLocalizations.of(context)!;
    final Map<String, String> localizationMap = {
      kCaloriesKey: translations.calories,
      kFatsKey: translations.fats,
      kCarbsKey: translations.carbs,
      kProteinKey: translations.protein,
      kServingQuantityKey: translations.servingQuantity,
      kServingNameKey: translations.servingName,
    };

    Widget buttonsRow() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const CloseButtonWidget(),
          Consumer(
            builder: (context, ref, _) {
              return ConfirmButtonWidget(
                callback: () async {
                  if (!context.mounted) {
                    return;
                  }

                  widget.tappedFood.updateFoodFromMap(_editableValues);
                  await ref
                      .read(savedFoodProvider.notifier)
                      .updateSavedFood(widget.tappedFood);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          bottom: 18.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NameTextField(
              callbackMap: _editableValues,
              controller: _controllers[kFoodNameKey]!,
              mapKey: kFoodNameKey,
            ),
            const SizedBox(height: 20.0),
            for (var key in localizationMap.keys)
              DoubleTextField(
                callbackMap: _editableValues,
                controller: _controllers[key]!,
                mapKey: key,
              ),
            const Spacer(),
            buttonsRow(),
          ],
        ),
      ),
    );
  }
}
