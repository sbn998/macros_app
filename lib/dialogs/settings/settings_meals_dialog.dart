import 'package:flutter/material.dart';

import 'package:macros_app/databases/user_meals_db.dart';
import 'package:macros_app/models/user_meal_model.dart';
import 'package:macros_app/widgets/settings/user_meals_list.dart';

Future<void> handleConfirmation(
  List<UserMeal> dbUserMeals,
  List<UserMeal> callbackList,
) async {
  if (callbackList.isEmpty) {
    await deleteAllUserMeals();
    return;
  }

  List<UserMeal> updatedUserMeals = callbackList
      .where((updatedUserMeal) => dbUserMeals.any((dbUserMeal) =>
          dbUserMeal.id == updatedUserMeal.id &&
          dbUserMeal.mealName != updatedUserMeal.mealName))
      .toList();
  List<UserMeal> addedUserMeals = callbackList
      .where((updatedUserMeal) =>
          !dbUserMeals.any((dbUserMeal) => dbUserMeal.id == updatedUserMeal.id))
      .toList();
  List<UserMeal> removedUserMeals = dbUserMeals
      .where((dbUserMeal) => !callbackList
          .any((updatedUserMeal) => updatedUserMeal.id == dbUserMeal.id))
      .toList();

  for (var userMeal in updatedUserMeals) {
    await updateUserMeal(userMeal);
  }

  for (var userMeal in addedUserMeals) {
    await insertUserMeal(userMeal);
  }

  for (var userMeal in removedUserMeals) {
    await deleteUserMeal(userMeal.id);
  }
}

Future<void> showUserMealsDialog(BuildContext context) async {
  List<UserMeal> dbUserMeals = await getUserMeals();
  List<UserMeal> callbackList =
      dbUserMeals.map((meal) => UserMeal.clone(meal)).toList();

  if (!context.mounted) return;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text(
            'Add or Edit your meals',
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: UserMealsListView(
              onChangedMeals: (changedData) {
                setState(() {
                  callbackList = changedData;
                });
              },
              userMeals: callbackList,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await handleConfirmation(dbUserMeals, callbackList);
                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      });
    },
  );
}
