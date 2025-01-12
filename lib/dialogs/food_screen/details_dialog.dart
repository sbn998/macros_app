import 'package:flutter/material.dart';

import 'package:macros_app/models/food_model.dart';
import 'package:macros_app/widgets/food_screen/food_details/editing_details_modal.dart';
import 'package:macros_app/widgets/food_screen/food_details/normal_details_modal.dart';

//TODO: Add some graphics to show the macros visually.

void showFoodDetailsDialog(BuildContext context, Food tappedFood) async {
  bool isEditing = false;

  bool? result = await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: isEditing
                ? EditingSavedFoodModal(tappedFood: tappedFood)
                : SavedFoodDetailsModal(
                    onPressEdit: () {
                      setState(() => isEditing = true);
                    },
                    tappedFood: tappedFood),
          );
        },
      );
    },
  );

  // Resets _isEditing if user closes the modal with a gesture.
  if (result == null) {
    isEditing = false;
  }
}
