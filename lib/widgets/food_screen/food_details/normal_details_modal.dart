import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:macros_app/constants/map_entries.dart';
import 'package:macros_app/models/food_model.dart';
import 'package:macros_app/widgets/text/details_field.dart';
import 'package:macros_app/widgets/text/dialog_title.dart';

class SavedFoodDetailsModal extends StatelessWidget {
  final Food tappedFood;
  final Function() onPressEdit;

  const SavedFoodDetailsModal({
    super.key,
    required this.tappedFood,
    required this.onPressEdit,
  });

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

    final Map<String, dynamic> foodMap = {
      kCaloriesKey: tappedFood.calories,
      kFatsKey: tappedFood.fats,
      kCarbsKey: tappedFood.carbs,
      kProteinKey: tappedFood.protein,
      kServingQuantityKey: tappedFood.servingQuantity,
      kServingNameKey: tappedFood.serving,
    };

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DetailsDialogTitle(
              onPressEdit: onPressEdit,
              title: tappedFood.foodName,
            ),
            const SizedBox(height: 20.0),
            for (var key in localizationMap.keys)
              DetailsField(
                fieldName: localizationMap[key]!,
                fieldValue: foodMap[key].toString(),
              )
          ],
        ),
      ),
    );
  }
}
