import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:macros_app/providers/date_provider.dart';
import 'package:macros_app/providers/logged_meals_provider.dart';
import 'package:macros_app/functions/macros_calcs.dart';

final calculatedMacrosProvider = Provider<Map<String, double>>((ref) {
  final DateTime dateToFetch = ref.watch(selectedDateProvider);
  final loggedMeals = ref.watch(loggedMealsProvider(dateToFetch));

  return loggedMacrosMap({
    'calories': 0.0,
    'protein': 0.0,
    'carbs': 0.0,
    'fats': 0.0,
  }, loggedMeals);
});
