import 'package:uuid/uuid.dart';

import 'package:macros_app/constants/strings.dart';
import 'package:macros_app/constants/map_entries.dart';

const _uuid = Uuid();

class Food {
  final String id;
  String foodName;
  double? calories;
  double? protein;
  double? carbs;
  double? fats;
  String? serving;
  double? servingQuantity;

  Food({
    String? id,
    required this.foodName,
    double? calories,
    double? protein,
    double? carbs,
    double? fats,
    String? serving,
    double? servingQuantity,
  })  : id = id ?? _uuid.v4(),
        calories = (calories ?? 0.0).toDouble(),
        protein = (protein ?? 0.0).toDouble(),
        carbs = (carbs ?? 0.0).toDouble(),
        fats = (fats ?? 0.0).toDouble(),
        serving = serving ?? kDefaultServingName,
        servingQuantity = (servingQuantity ?? 100.0).toDouble();

  Map<String, dynamic> toMap() {
    return {
      kIdKey: id,
      kFoodNameKey: foodName,
      kCaloriesKey: calories,
      kProteinKey: protein,
      kCarbsKey: carbs,
      kFatsKey: fats,
      kServingNameKey: serving,
      kServingQuantityKey: servingQuantity,
    };
  }

  static Food fromMap(Map<String, dynamic> mapValues) {
    return Food(
      foodName: mapValues[kIdKey] as String,
      calories: (mapValues[kCaloriesKey] as num?)?.toDouble() ?? 0.0,
      protein: (mapValues[kProteinKey] as num?)?.toDouble() ?? 0.0,
      carbs: (mapValues[kCarbsKey] as num?)?.toDouble() ?? 0.0,
      fats: (mapValues[kFatsKey] as num?)?.toDouble() ?? 0.0,
      serving: mapValues[kServingNameKey] as String,
      servingQuantity:
          (mapValues[kServingQuantityKey] as num?)?.toDouble() ?? 0.0,
    );
  }

  void updateFoodFromMap(Map<String, dynamic> newValues) {
    foodName = newValues[kFoodNameKey] as String? ?? foodName;
    calories = (newValues[kCaloriesKey] as num?)?.toDouble() ?? calories;
    protein = (newValues[kProteinKey] as num?)?.toDouble() ?? protein;
    carbs = (newValues[kCarbsKey] as num?)?.toDouble() ?? carbs;
    fats = (newValues[kFatsKey] as num?)?.toDouble() ?? fats;
    serving = newValues[kServingNameKey] as String? ?? serving;
    servingQuantity =
        (newValues[kServingQuantityKey] as num?)?.toDouble() ?? servingQuantity;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is Food) {
      return other.id == id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;
}
