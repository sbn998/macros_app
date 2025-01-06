import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:macros_app/models/logged_food_model.dart';
import 'package:macros_app/models/logged_meal_model.dart';

class LoggedMealNotifier extends StateNotifier<LoggedMeal> {
  LoggedMealNotifier({required LoggedMeal loggedMeal}) : super(loggedMeal);

  void addFood(LoggedFood food) {
    state = LoggedMeal(
      id: state.id,
      loggedFood: [...state.loggedFood, food], // Create a new list
      loggedUserMeal: state.loggedUserMeal,
    );
  }

  void removeFood(LoggedFood food) {
    state = LoggedMeal(
      id: state.id,
      loggedFood: state.loggedFood.where((item) => item != food).toList(),
      loggedUserMeal: state.loggedUserMeal,
    );
  }

  Map<String, double> calculateMacros() {
    double kcal = 0.0;
    double protein = 0.0;
    double carbs = 0.0;
    double fats = 0.0;

    for (var food in state.loggedFood) {
      kcal += food.loggedQuantity * 4; // Assuming 4 kcal per gram of food
      protein += food.loggedQuantity * 0.25; // Example value
      carbs += food.loggedQuantity * 0.5; // Example value
      fats += food.loggedQuantity * 0.2; // Example value
    }

    return {
      'kcal': kcal,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
    };
  }
}

final loggedMealProviderFamily =
    StateNotifierProvider.family<LoggedMealNotifier, LoggedMeal, LoggedMeal>(
  (ref, loggedMeal) {
    return LoggedMealNotifier(loggedMeal: loggedMeal);
  },
);

class LoggedMealMacrosNotifier extends StateNotifier<Map<String, double>> {
  LoggedMealMacrosNotifier(LoggedMeal loggedMeal)
      : super(_calculateMacros(loggedMeal));

  static Map<String, double> _calculateMacros(LoggedMeal loggedMeal) {
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFats = 0;

    for (var food in loggedMeal.loggedFood) {
      totalCalories +=
          food.calories! * food.loggedQuantity / food.servingQuantity!;
      totalProtein +=
          food.protein! * food.loggedQuantity / food.servingQuantity!;
      totalCarbs += food.carbs! * food.loggedQuantity / food.servingQuantity!;
      totalFats += food.fats! * food.loggedQuantity / food.servingQuantity!;
    }

    return {
      'kcal': totalCalories,
      'protein': totalProtein,
      'carbs': totalCarbs,
      'fats': totalFats,
    };
  }

  void updateMacros(LoggedMeal loggedMeal) {
    state = _calculateMacros(loggedMeal);
  }
}

final loggedMealMacrosProvider = StateNotifierProvider.family<
    LoggedMealMacrosNotifier, Map<String, double>, LoggedMeal>(
  (ref, loggedMeal) {
    return LoggedMealMacrosNotifier(loggedMeal);
  },
);
