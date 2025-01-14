import 'package:flutter/material.dart';

import 'package:macros_app/constants/enums.dart';
import 'package:macros_app/models/food_model.dart';
import 'package:macros_app/widgets/food_screen/food_details/editing_food_modal.dart';
import 'package:macros_app/widgets/food_screen/food_details/normal_details_modal.dart';

class SavedFoodDialogContent extends StatefulWidget {
  final Food tappedFood;

  const SavedFoodDialogContent({
    super.key,
    required this.tappedFood,
  });

  @override
  State<SavedFoodDialogContent> createState() {
    return _SavedFoodDialogContentState();
  }
}

class _SavedFoodDialogContentState extends State<SavedFoodDialogContent> {
  Mode _currentMode = Mode.normal;

  void _changeMode() {
    setState(() {
      if (_currentMode == Mode.normal) {
        _currentMode = Mode.editing;
      } else {
        _currentMode = Mode.normal;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: _currentMode == Mode.normal
          ? SavedFoodDetailsModal(
              tappedFood: widget.tappedFood, onPressEdit: _changeMode)
          : EditingSavedFoodModal(tappedFood: widget.tappedFood),
    );
  }
}
