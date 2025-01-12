import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:macros_app/databases/food_db.dart';
import 'package:macros_app/providers/date_provider.dart';
import 'package:macros_app/providers/logged_meals_provider.dart';
import 'package:macros_app/databases/user_meals_db.dart';
import 'package:macros_app/models/food_model.dart';
import 'package:macros_app/models/logged_food_model.dart';
import 'package:macros_app/models/logged_meal_model.dart';
import 'package:macros_app/models/user_meal_model.dart';
import 'package:macros_app/widgets/food_screen/add_food/food_selection.dart';
import 'package:macros_app/widgets/buttons/close_button_widget.dart';

bool _isMealSelected = false;
List<UserMeal> _userMeals = [];
List<Food> _savedFoods = [];
late UserMeal _selectedUserMeal;
List<LoggedFood> _selectedFood = [];
late StateSetter _setState;
final ScrollController _scrollController = ScrollController();

void _addOrRemoveSelectedFood(LoggedFood foodToAdd) {
  if (!_selectedFood.remove(foodToAdd)) {
    _selectedFood.add(foodToAdd);
  }
}

void showAddMealDialog(BuildContext context) async {
  await _loadData();

  if (!context.mounted) {
    return;
  }

  bool? result = await showDialog(
    context: context,
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

  if (result == null) {
    _isMealSelected = false;
  }
}

Future<void> _loadData() async {
  _userMeals = await getUserMeals();
  _savedFoods = await getSavedFood();
}

Future<void> _insertLoggedMeal(LoggedMeal loggedMeal, WidgetRef ref) async {
  final DateTime date = ref.read(selectedDateProvider.notifier).state;
  await ref
      .read(loggedMealsProvider(date).notifier)
      .addLoggedMeal(date, loggedMeal);
}

StatefulBuilder _buildStatefulBuilder(BuildContext context) {
  return StatefulBuilder(
    builder: (context, setState) {
      _setState = setState;

      return AlertDialog(
        title: _isMealSelected
            ? Text(AppLocalizations.of(context)!.selectFood,
                textAlign: TextAlign.center)
            : Text(AppLocalizations.of(context)!.selectMeal,
                textAlign: TextAlign.center),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: SizedBox(
              width: double.maxFinite,
              child: _isMealSelected
                  ? _buildAlertDialogSelectFoodContent(context)
                  : _buildAlertDialogSelectMealContent(context),
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.only(
          bottom: 10.0,
          right: 38.0,
        ),
        actions: [
          const CloseButtonWidget(),
          if (_isMealSelected)
            Consumer(
              builder: (context, ref, _) {
                return ElevatedButton(
                  onPressed: () async {
                    await _insertLoggedMeal(
                      LoggedMeal(
                        loggedUserMeal: _selectedUserMeal,
                        loggedFood: _selectedFood,
                      ),
                      ref,
                    ).then((_) {
                      _selectedFood.clear();
                      _selectedUserMeal = UserMeal.empty();
                      _isMealSelected = false;
                    });

                    if (!context.mounted) {
                      return;
                    }

                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.buttonsConfirm),
                );
              },
            )
        ],
      );
    },
  );
}

Widget _buildAlertDialogSelectMealContent(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      for (var userMeal in _userMeals) _buildMealInkwell(context, userMeal),
    ],
  );
}

Widget _buildMealInkwell(BuildContext context, UserMeal userMeal) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 9.0),
    child: InkWell(
      onTap: (() {
        _selectedUserMeal = userMeal;
        _setState(() => _isMealSelected = true);
      }),
      child: Card(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .50,
          height: 35,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              userMeal.mealName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ),
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
                            left: 18,
                            bottom: 6,
                            top: 6,
                          ),
                          child: Text(
                            currentLetter,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
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
