import 'package:flutter/material.dart';

import 'package:macros_app/widgets/food_screen/add_food/add_food_modal.dart';

void showAddFoodDialog(BuildContext context) {
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
        child: const AddFoodModal(),
      );
    },
  );
}
