import 'package:macros_app/constants/map_entries.dart';
import 'package:macros_app/models/food_model.dart';

class LoggedFood extends Food {
  double loggedQuantity;

  LoggedFood({
    super.id,
    required super.foodName,
    super.calories,
    super.protein,
    super.carbs,
    super.fats,
    super.serving,
    super.servingQuantity,
    required this.loggedQuantity,
  });

  factory LoggedFood.fromFood(Food food, {required double loggedQuantity}) {
    return LoggedFood(
      id: food.id,
      foodName: food.foodName,
      calories: food.calories,
      protein: food.protein,
      carbs: food.carbs,
      fats: food.fats,
      serving: food.serving,
      servingQuantity: food.servingQuantity,
      loggedQuantity: loggedQuantity,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap[kLoggedQuantityKey] = loggedQuantity;
    return baseMap;
  }

  static LoggedFood fromMap(Map<String, dynamic> mapValues) {
    return LoggedFood(
      foodName: mapValues[kFoodNameKey] as String,
      calories: (mapValues[kCaloriesKey] as num?)?.toDouble() ?? 0.0,
      protein: (mapValues[kProteinKey] as num?)?.toDouble() ?? 0.0,
      carbs: (mapValues[kCarbsKey] as num?)?.toDouble() ?? 0.0,
      fats: (mapValues[kFatsKey] as num?)?.toDouble() ?? 0.0,
      serving: mapValues[kServingNameKey] as String,
      servingQuantity:
          (mapValues[kServingQuantityKey] as num?)?.toDouble() ?? 0.0,
      loggedQuantity:
          (mapValues[kLoggedQuantityKey] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  void updateFoodFromMap(Map<String, dynamic> newValues) {
    super.updateFoodFromMap(newValues);
    loggedQuantity =
        (newValues[kLoggedQuantityKey] as num?)?.toDouble() ?? loggedQuantity;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! LoggedFood) {
      return false;
    }
    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
