import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:macros_app/providers/saved_food_provider.dart';
import 'package:macros_app/functions/update_map_values.dart';
import 'package:macros_app/models/food_model.dart';
import 'package:macros_app/constants/map_entries.dart';
import 'package:macros_app/widgets/buttons/close_button_widget.dart';
import 'package:macros_app/widgets/buttons/confirm_button_widget.dart';
import 'package:macros_app/widgets/food_screen/add_food/food_content.dart';

class AddFoodModal extends StatelessWidget {
  const AddFoodModal({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translations = AppLocalizations.of(context)!;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final Map<String, dynamic> foodValues = {
      kFoodNameKey: '',
      kCaloriesKey: 0.0,
      kProteinKey: 0.0,
      kCarbsKey: 0.0,
      kFatsKey: 0.0,
      kServingNameKey: '',
      kServingQuantityKey: 100.0,
    };

    void saveFood(WidgetRef ref) async {
      if (!context.mounted) {
        return;
      }

      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();

        Food newFood = Food(
          foodName: foodValues[kFoodNameKey],
          calories: foodValues[kCaloriesKey],
          protein: foodValues[kProteinKey],
          carbs: foodValues[kCarbsKey],
          fats: foodValues[kFatsKey],
          serving: foodValues[kServingNameKey],
          servingQuantity: foodValues[kServingQuantityKey],
        );

        await ref.read(savedFoodProvider.notifier).addSavedFood(newFood);
        Navigator.of(context).pop();
      }
    }

    Widget buttonsRow() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const CloseButtonWidget(),
          Consumer(
            builder: (context, ref, _) {
              return ConfirmButtonWidget(
                callback: () {
                  saveFood(ref);
                },
              );
            },
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            translations.addFood,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Form(
              key: formKey,
              child: AddFoodFormContent(
                callbackMap: foodValues,
                onSavedNameCallback: updateStringValue,
                onSavedDoubleCallback: updateDoubleValue,
              ),
            ),
          ),
          buttonsRow(),
        ],
      ),
    );
  }
}
