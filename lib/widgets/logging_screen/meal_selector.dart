import 'package:flutter/material.dart';
import 'package:macros_app/databases/user_meals_db.dart';
import 'package:macros_app/models/user_meal_model.dart';

class MealSelector extends StatelessWidget {
  final Function(UserMeal) onTapMeal;

  const MealSelector({
    super.key,
    required this.onTapMeal,
  });

  Future<List<UserMeal>> _loadUserMeals() async {
    return await getUserMeals();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadUserMeals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var userMeal in snapshot.data!)
                  styledInkwell(context, userMeal),
              ],
            );
          }
        });
  }

  Padding styledInkwell(BuildContext context, UserMeal userMeal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9.0),
      child: InkWell(
        onTap: () => onTapMeal(userMeal),
        child: Card(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .50,
            height: 35,
            child: Align(
              alignment: Alignment.center,
              child: styledText(userMeal),
            ),
          ),
        ),
      ),
    );
  }

  Text styledText(UserMeal userMeal) {
    return Text(
      userMeal.mealName,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
