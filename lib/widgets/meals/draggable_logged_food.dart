import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:macros_app/functions/macros_summary.dart';
import 'package:macros_app/models/logged_food_model.dart';
import 'package:macros_app/models/logged_meal_model.dart';
import 'package:macros_app/providers/date_provider.dart';
import 'package:macros_app/providers/logged_meal_list_provider.dart';
import 'package:macros_app/providers/logged_meals_provider.dart';
import 'package:macros_app/widgets/meals/dismissible_logged_food.dart';

class DraggableLoggedFood extends ConsumerWidget {
  final LoggedMeal loggedMeal;
  final LoggedFood loggedFood;

  const DraggableLoggedFood({
    super.key,
    required this.loggedFood,
    required this.loggedMeal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void removeMeal(LoggedFood food) {
      ref.read(loggedMealProviderFamily(loggedMeal).notifier).removeFood(food);
    }

    void updateMeal(LoggedFood food) {
      final selectedDate = ref.read(selectedDateProvider.notifier).state;
      ref
          .read(loggedMealsProvider(selectedDate).notifier)
          .updateLoggedMeal(selectedDate, loggedMeal);
    }

    void dismissMeal(LoggedFood food) {
      loggedMeal.loggedFood.remove(food);
      updateMeal(food);
    }

    return LongPressDraggable<LoggedFood>(
      data: loggedFood,
      feedback: Material(
        color: Colors.transparent,
        child: loggedFoodDraggedCard(context),
      ),
      childWhenDragging: Opacity(
        opacity: 0.0,
        child: Container(),
      ),
      onDragCompleted: () {
        removeMeal(loggedFood);
      },
      child: DismissibleLoggedFood(
        loggedFood: loggedFood,
        onDismmissedCallback: (loggedFood) {
          dismissMeal(loggedFood);
        },
        onUpdateTextFieldCallback: (loggedFood) {
          updateMeal(loggedFood);
        },
      ),
    );
  }

  Card loggedFoodDraggedCard(BuildContext context) {
    return Card(
      shadowColor: Theme.of(context).colorScheme.primaryFixedDim,
      elevation: 4,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        height: 45.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              loggedFood.foodName,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              getMacrosOnly(loggedFood),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
