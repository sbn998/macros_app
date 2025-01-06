import 'package:flutter/material.dart';
import 'package:macros_app/databases/food_db.dart';

import 'package:macros_app/models/food_model.dart';
import 'package:path/path.dart';

//TODO: Add some graphics to show the macros visually.

bool _isEditing = false;
Map<String, dynamic> _editableValues = {};
Map<String, TextEditingController> _controllers = {};
late StateSetter _setState;
late Food _tappedFood;

enum FoodFields {
  calories,
  protein,
  carbs,
  fats,
  servingQuantity,
  serving,
}

void showFoodDetailsDialog(BuildContext context, Food tappedFood) async {
  _tappedFood = tappedFood;
  _editableValues = tappedFood.toMap();

  _disposeControllers();

  for (var field in FoodFields.values) {
    String fieldName = field.name;
    String mapKey =
        fieldName == 'servingQuantity' ? 'serving_quantity' : fieldName;
    if (!_controllers.containsKey(fieldName)) {
      _controllers[fieldName] = TextEditingController(
        text: _editableValues[mapKey]?.toString() ?? '',
      );
    }
  }

  bool? result = await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _buildStatefulBuilder(context),
      );
    },
  );

  _disposeControllers();

  // Resets _isEditing if user closes the modal with a gesture.
  if (result == null) {
    _isEditing = false;
  }
}

void _updateFood() async {
  await updatedSavedFood(_tappedFood);
}

void _disposeControllers() {
  _controllers.forEach((key, value) => value.dispose());
  _controllers.clear();
}

String _capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

StatefulBuilder _buildStatefulBuilder(BuildContext context) {
  return StatefulBuilder(
    builder: (context, setState) {
      _setState = setState;
      return Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        child: _buildStatefulBuilderDetailsOverview(context),
      );
    },
  );
}

Widget _buildStatefulBuilderDetailsOverview(
  BuildContext context,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      _buildStatefulBuilderDetailsOverviewHeader(context),
      const SizedBox(height: 20),
      for (var field in FoodFields.values)
        _buildStatefulBuilderDetailsMacrosRow(field.name),
      const SizedBox(
        height: 35,
      ),
      _buildStatefulBuilderDetailsOverviewBottomButtons(context),
    ],
  );
}

Widget _buildStatefulBuilderDetailsOverviewHeader(
  BuildContext context,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        _tappedFood.foodName,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
      ),
      const SizedBox(
        width: 30,
      ),
      IconButton(
        onPressed: () {
          _setState(() {
            _isEditing = !_isEditing;
          });
        },
        icon: const Icon(
          Icons.edit,
        ),
      ),
    ],
  );
}

Widget _buildStatefulBuilderDetailsMacrosRow(String firstMacro) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _buildStatefulBuilderDetailsMacrosRowContent(firstMacro),
    ),
  );
}

List<Widget> _buildStatefulBuilderDetailsMacrosRowContent(
    String foodFieldName) {
  String properName = '';

  if (foodFieldName == 'carbs') {
    properName = 'Carbohydrates';
  } else if (foodFieldName == 'servingQuantity') {
    properName = 'Serving Quantity';
  } else {
    properName = foodFieldName;
  }

  return [
    Text(
      '${_capitalizeFirstLetter(properName)}:',
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
      ),
    ),
    _buildStatefulBuilderDetailsMacrosRowEditingMode(_isEditing, foodFieldName),
  ];
}

Widget _buildStatefulBuilderDetailsMacrosRowEditingMode(
    bool isEditing, String foodFieldName) {
  String mapFieldName = '';

  if (foodFieldName == 'servingQuantity') {
    mapFieldName = 'serving_quantity';
  } else {
    mapFieldName = foodFieldName;
  }

  return _isEditing
      ? SizedBox(
          width: 90,
          child: TextField(
            keyboardType: foodFieldName == 'serving'
                ? TextInputType.visiblePassword
                : TextInputType.number,
            controller: _controllers[foodFieldName],
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            onChanged: (newValue) {
              if (newValue.isNotEmpty) {
                if (foodFieldName == 'servingQuantity') {
                  _editableValues['serving_quantity'] = double.parse(newValue);
                } else if (foodFieldName != 'serving') {
                  _editableValues[foodFieldName] = double.parse(newValue);
                } else {
                  _editableValues[foodFieldName] = newValue;
                }
              }
            },
          ),
        )
      : Text(
          '${_tappedFood.toMap()[mapFieldName]}',
          style: const TextStyle(
            fontSize: 18,
          ),
        );
}

Widget _buildStatefulBuilderDetailsOverviewBottomButtons(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: _isEditing
        ? [
            TextButton(
                onPressed: () {
                  _setState(() => _isEditing = false);
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel')),
            const SizedBox(
              width: 12,
            ),
            ElevatedButton(
                onPressed: () {
                  _setState(() {
                    _isEditing = false;
                    _tappedFood.updateFoodFromMap(_editableValues);
                    _updateFood();
                  });
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onSecondary),
                child: const Text('Confirm changes'))
          ]
        : [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'))
          ],
  );
}
