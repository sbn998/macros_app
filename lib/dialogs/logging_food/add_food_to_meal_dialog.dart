import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:macros_app/databases/food_db.dart';
import 'package:macros_app/models/food_model.dart';
import 'package:macros_app/models/logged_food_model.dart';
import 'package:macros_app/models/logged_meal_model.dart';
import 'package:macros_app/providers/date_provider.dart';
import 'package:macros_app/providers/logged_meals_provider.dart';
import 'package:macros_app/widgets/add_food/food_selection.dart';

List<Food> _savedFoods = [];
late WidgetRef _ref;
final ScrollController _scrollController = ScrollController();
List<LoggedFood> _selectedFood = [];
late LoggedMeal _mealToAddFood;

void _addOrRemoveSelectedFood(LoggedFood foodToAdd) {
  if (!_selectedFood.remove(foodToAdd)) {
    _selectedFood.add(foodToAdd);
  }
}

void showAddFoodToMealDialog(
    BuildContext context, WidgetRef ref, LoggedMeal meal) async {
  await _loadData();
  _ref = ref;
  _mealToAddFood = meal;

  if (!context.mounted) {
    return;
  }

  showDialog(
    context: context,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _buildAlertDialog(context),
      );
    },
  );
}

Future<void> _loadData() async {
  _savedFoods = await getSavedFood();
}

Future<void> _updateLoggedMeal(LoggedMeal loggedMeal) async {
  final DateTime selectedDate = _ref.read(selectedDateProvider.notifier).state;
  await _ref
      .read(loggedMealsProvider(selectedDate).notifier)
      .updateLoggedMeal(selectedDate, loggedMeal);
}

AlertDialog _buildAlertDialog(BuildContext context) {
  return AlertDialog(
    title: const Text('Select your food'),
    content: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: SizedBox(
          width: double.maxFinite,
          child: _buildAlertDialogSelectFoodContent(context),
        ),
      ),
    ),
    actionsPadding: const EdgeInsets.only(
      bottom: 10.0,
      right: 38.0,
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Close'),
      ),
      ElevatedButton(
        onPressed: () async {
          for (var food in _selectedFood) {
            _mealToAddFood.loggedFood.add(food);
          }

          _updateLoggedMeal(_mealToAddFood);

          if (!context.mounted) {
            return;
          }

          Navigator.of(context).pop();
        },
        child: const Text('Confirm'),
      )
    ],
  );
}

Widget _buildAlertDialogSelectFoodContent(BuildContext context) {
  return SizedBox(
    height: 400.0,
    child: Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: _savedFoods.length,
                itemBuilder: (context, index) {
                  String currentLetter =
                      _savedFoods[index].foodName[0].toUpperCase();
                  String? previousLetter;
                  if (index > 0) {
                    previousLetter =
                        _savedFoods[index - 1].foodName[0].toUpperCase();
                  }

                  bool isNewSection = previousLetter != currentLetter;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isNewSection)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 4,
                            top: 4,
                          ),
                          child: Text(
                            currentLetter,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      FoodSelection(
                        rowFood: _savedFoods[index],
                        addOrRemoveSelectedFood: _addOrRemoveSelectedFood,
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    ),
  );
}
