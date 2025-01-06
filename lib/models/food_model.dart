import 'package:uuid/uuid.dart';

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
        serving = serving ?? 'g',
        servingQuantity = (servingQuantity ?? 100.0).toDouble();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'food_name': foodName,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'serving': serving,
      'serving_quantity': servingQuantity,
    };
  }

  static Food fromMap(Map<String, dynamic> mapValues) {
    return Food(
      foodName: mapValues['food_name'] as String,
      calories: (mapValues['calories'] as num?)?.toDouble() ?? 0.0,
      protein: (mapValues['protein'] as num?)?.toDouble() ?? 0.0,
      carbs: (mapValues['carbs'] as num?)?.toDouble() ?? 0.0,
      fats: (mapValues['fats'] as num?)?.toDouble() ?? 0.0,
      serving: mapValues['serving'] as String,
      servingQuantity:
          (mapValues['serving_quantity'] as num?)?.toDouble() ?? 0.0,
    );
  }

  void updateFoodFromMap(Map<String, dynamic> newValues) {
    foodName = newValues['food_name'] as String? ?? foodName;
    calories = (newValues['calories'] as num?)?.toDouble() ?? calories;
    protein = (newValues['protein'] as num?)?.toDouble() ?? protein;
    carbs = (newValues['carbs'] as num?)?.toDouble() ?? carbs;
    fats = (newValues['fats'] as num?)?.toDouble() ?? fats;
    serving = newValues['serving'] as String? ?? serving;
    servingQuantity =
        (newValues['serving_quantity'] as num?)?.toDouble() ?? servingQuantity;
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
