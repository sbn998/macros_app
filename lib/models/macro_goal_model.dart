import 'package:uuid/uuid.dart';

const Uuid uuid = Uuid();

class MacroGoal {
  final String id;
  String goalName;
  double? calories;
  double? protein;
  double? carbs;
  double? fats;

  MacroGoal({
    String? id,
    required this.goalName,
    double? calories,
    double? protein,
    double? carbs,
    double? fats,
  })  : id = id ?? uuid.v4(),
        calories = (calories ?? 0.0).toDouble(),
        protein = (protein ?? 0.0).toDouble(),
        carbs = (carbs ?? 0.0).toDouble(),
        fats = (fats ?? 0.0).toDouble();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'goal_name': goalName,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
    };
  }

  static MacroGoal fromMap(Map<String, dynamic> map) {
    return MacroGoal(
      id: map['id'] as String,
      goalName: map['goal_name'] as String,
      calories: (map['calories'] ?? 0.0) as double,
      protein: (map['protein'] ?? 0.0) as double,
      carbs: (map['carbs'] ?? 0.0) as double,
      fats: (map['fats'] ?? 0.0) as double,
    );
  }

  void updateMacroGoalFromMap(Map<String, dynamic> newValues) {
    goalName = newValues['goal_name'] as String;
    calories = (newValues['calories'] ?? 0.0) as double;
    protein = (newValues['protein'] ?? 0.0) as double;
    carbs = (newValues['carbs'] ?? 0.0) as double;
    fats = (newValues['fats'] ?? 0.0) as double;
  }
}
