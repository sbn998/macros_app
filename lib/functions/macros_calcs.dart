import 'package:macros_app/models/logged_meal_model.dart';

Map<String, double> loggedMacrosMap(
  Map<String, double> initialValues,
  List<LoggedMeal> loggedMeal,
) {
  final Map<String, double> updatedMacrosMap = {
    'calories': initialValues['calories'] ?? 0.0,
    'protein': initialValues['protein'] ?? 0.0,
    'carbs': initialValues['carbs'] ?? 0.0,
    'fats': initialValues['fats'] ?? 0.0,
  };

  for (var meal in loggedMeal) {
    _getMealMacros(meal, updatedMacrosMap);
  }

  return updatedMacrosMap;
}

void _getMealMacros(LoggedMeal meal, Map<String, double> macrosMap) {
  for (var food in meal.loggedFood) {
    macrosMap['calories'] = macrosMap['calories']! +
        _calculateMacro(
          food.calories!,
          food.servingQuantity!,
          food.loggedQuantity,
        );
    macrosMap['protein'] = macrosMap['protein']! +
        _calculateMacro(
          food.protein!,
          food.servingQuantity!,
          food.loggedQuantity,
        );
    macrosMap['carbs'] = macrosMap['carbs']! +
        _calculateMacro(
          food.carbs!,
          food.servingQuantity!,
          food.loggedQuantity,
        );
    macrosMap['fats'] = macrosMap['fats']! +
        _calculateMacro(
          food.fats!,
          food.servingQuantity!,
          food.loggedQuantity,
        );
  }
}

double _calculateMacro(
  double macroInServing,
  double servingQuantity,
  double loggedQuantity,
) {
  if (macroInServing <= 0.0 || loggedQuantity <= 0.0) {
    return 0.0;
  }

  return (macroInServing / servingQuantity) * loggedQuantity;
}
