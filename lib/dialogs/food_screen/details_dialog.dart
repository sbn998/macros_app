import 'package:flutter/material.dart';

import 'package:macros_app/models/food_model.dart';
import 'package:macros_app/widgets/food_screen/food_details/saved_food_dialog_content.dart';

//TODO: Add some graphics to show the macros visually.

void showFoodDetailsDialog(BuildContext context, Food tappedFood) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SavedFoodDialogContent(tappedFood: tappedFood),
      );
    },
  );
}
