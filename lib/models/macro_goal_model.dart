import 'package:macros_app/constants/map_entries.dart';
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
      kIdKey: id,
      kGoalNameKey: goalName,
      kCaloriesKey: calories,
      kProteinKey: protein,
      kCarbsKey: carbs,
      kFatsKey: fats,
    };
  }

  static MacroGoal fromMap(Map<String, dynamic> map) {
    return MacroGoal(
      id: map[kIdKey] as String,
      goalName: map[kGoalNameKey] as String,
      calories: (map[kCaloriesKey] ?? 0.0) as double,
      protein: (map[kProteinKey] ?? 0.0) as double,
      carbs: (map[kCarbsKey] ?? 0.0) as double,
      fats: (map[kFatsKey] ?? 0.0) as double,
    );
  }

  void updateMacroGoalFromMap(Map<String, dynamic> newValues) {
    goalName = newValues[kGoalNameKey] as String;
    calories = (newValues[kCaloriesKey] ?? 0.0) as double;
    protein = (newValues[kProteinKey] ?? 0.0) as double;
    carbs = (newValues[kCarbsKey] ?? 0.0) as double;
    fats = (newValues[kFatsKey] ?? 0.0) as double;
  }
}
