import 'package:macros_app/models/logged_food_model.dart';
import 'package:macros_app/models/user_meal_model.dart';
import 'package:uuid/uuid.dart';

const Uuid uuid = Uuid();

class LoggedMeal {
  String id;
  List<LoggedFood> loggedFood;
  UserMeal loggedUserMeal;

  LoggedMeal({
    String? id,
    required this.loggedUserMeal,
    List<LoggedFood>? loggedFood,
  })  : loggedFood = loggedFood ?? [],
        id = id ?? uuid.v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'logged_food': loggedFood.map((food) => food.toMap()).toList(),
      'logged_user_meal': loggedUserMeal.toMap(),
    };
  }

  static LoggedMeal fromMap(Map<String, dynamic> map) {
    return LoggedMeal(
      id: map['id'] as String,
      loggedFood: (map['logged_food'] as List)
          .map((food) => LoggedFood.fromMap(food as Map<String, dynamic>))
          .toList(),
      loggedUserMeal: UserMeal.fromMap(map['logged_user_meal']),
    );
  }
}
