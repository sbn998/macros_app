import 'package:macros_app/databases/daily_macro_goals_db.dart';

Future<void> modifyDailyMacroGoalsDb(
  Map<int, bool> originalMap,
  Map<int, bool> modifiedMap,
  String goalId,
) async {
  modifiedMap.forEach((key, newValue) async {
    if (originalMap[key] != newValue) {
      if (newValue == true && originalMap[key] == false) {
        await insertDayMacroGoal(key, goalId);
      } else if (newValue == false && originalMap[key] == true) {
        await deleteDayMacroGoal(key);
      }
    }
  });
}
