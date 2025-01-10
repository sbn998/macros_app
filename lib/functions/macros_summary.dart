import 'package:macros_app/constants/decimals.dart';
import 'package:macros_app/constants/map_entries.dart';
import 'package:macros_app/constants/strings.dart';
import 'package:macros_app/functions/double_length_format.dart';
import 'package:macros_app/models/logged_food_model.dart';

String getMacrosSummary(Map<String, double> totalMacros) {
  final String formattedCalories =
      doubleFormat(totalMacros[kCaloriesKey]!, kDecimalPlaces);
  final String formattedProtein =
      doubleFormat(totalMacros[kProteinKey]!, kDecimalPlaces);
  final String formattedCarbs =
      doubleFormat(totalMacros[kCarbsKey]!, kDecimalPlaces);
  final String formattedFats =
      doubleFormat(totalMacros[kFatsKey]!, kDecimalPlaces);

  return '$formattedCalories $kCaloriesShort   $formattedProtein $kProteinShort   $formattedCarbs $kCarbsShort   $formattedFats $kFatsShort';
}

String getMacrosOnly(LoggedFood food) {
  final double proteinQuantity =
      food.protein! * food.loggedQuantity / food.servingQuantity!;
  final double carbsQuantity =
      food.carbs! * food.loggedQuantity / food.servingQuantity!;
  final double fatsQuantity =
      food.fats! * food.loggedQuantity / food.servingQuantity!;

  final String formattedProtein = doubleFormat(proteinQuantity, kDecimalPlaces);
  final String formattedCarbs = doubleFormat(carbsQuantity, kDecimalPlaces);
  final String formattedFats = doubleFormat(fatsQuantity, kDecimalPlaces);

  return '$formattedProtein P  $formattedCarbs C  $formattedFats F';
}
