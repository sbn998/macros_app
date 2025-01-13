import 'package:macros_app/constants/map_entries.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class UserMeal {
  final String id;
  String mealName;

  UserMeal.empty({
    this.id = '',
    this.mealName = '',
  });

  UserMeal({
    String? id,
    required this.mealName,
  }) : id = id ?? _uuid.v4();

  Map<String, dynamic> toMap() {
    return {
      kIdKey: id,
      kMealNameKey: mealName,
    };
  }

  static UserMeal fromMap(Map<String, dynamic> mapValues) {
    return UserMeal(
      id: mapValues[kIdKey] as String,
      mealName: mapValues[kMealNameKey] as String,
    );
  }

  UserMeal.clone(UserMeal meal)
      : id = meal.id,
        mealName = meal.mealName;
}
