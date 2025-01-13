import 'package:macros_app/models/logged_food_model.dart';

void updateLoggedFoodlist(
  List<LoggedFood> selectedFoodList,
  LoggedFood foodToAdd,
) {
  bool isInList = selectedFoodList.remove(foodToAdd);

  if (!isInList) {
    selectedFoodList.add(foodToAdd);
  }
}
