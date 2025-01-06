import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:macros_app/databases/logged_meals_db.dart';

final fetchedMonthLoggedMeals =
    FutureProvider.family<List<DateTime>, DateTime>((ref, month) async {
  return await getLoggedMealsForMonth(month);
});
