import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:macros_app/databases/daily_macro_goals_db.dart';

final fetchedDailyMacrosProvider =
    FutureProvider.family<Map<String, dynamic>, int>((ref, weekday) async {
  return await getDayMacroGoals(weekday);
});
