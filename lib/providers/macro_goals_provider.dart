import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:macros_app/databases/macro_goals_db.dart' as db;
import 'package:macros_app/models/macro_goal_model.dart';

class MacroGoalsNotifier extends StateNotifier<List<MacroGoal>> {
  MacroGoalsNotifier() : super([]) {
    _loadMacroGoals();
  }

  Future<void> _loadMacroGoals() async {
    final data = await db.getMacroGoals();
    state = data;
  }

  Future<void> addMacroGoal(MacroGoal newGoal) async {
    await db.insertMacroGoal(newGoal);
    _loadMacroGoals();
  }

  Future<void> updateMacroGoal(MacroGoal udpdatedGoal) async {
    await db.updateMacroGoal(udpdatedGoal);
    _loadMacroGoals();
  }

  Future<void> removeMacroGoal(MacroGoal deletedGoal) async {
    await db.deleteMacroGoal(deletedGoal.id);
    _loadMacroGoals();
  }
}

final macroGoalsProvider =
    StateNotifierProvider<MacroGoalsNotifier, List<MacroGoal>>((ref) {
  return MacroGoalsNotifier();
});
