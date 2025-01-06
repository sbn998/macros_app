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
    baseMap['logged_quantity'] = loggedQuantity;
    return baseMap;
  }

  static LoggedFood fromMap(Map<String, dynamic> mapValues) {
    return LoggedFood(
      foodName: mapValues['food_name'] as String,
      calories: (mapValues['calories'] as num?)?.toDouble() ?? 0.0,
      protein: (mapValues['protein'] as num?)?.toDouble() ?? 0.0,
      carbs: (mapValues['carbs'] as num?)?.toDouble() ?? 0.0,
      fats: (mapValues['fats'] as num?)?.toDouble() ?? 0.0,
      serving: mapValues['serving'] as String,
      servingQuantity:
          (mapValues['serving_quantity'] as num?)?.toDouble() ?? 0.0,
      loggedQuantity: (mapValues['logged_quantity'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  void updateFoodFromMap(Map<String, dynamic> newValues) {
    super.updateFoodFromMap(newValues);
    loggedQuantity =
        (newValues['logged_quantity'] as num?)?.toDouble() ?? loggedQuantity;
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
