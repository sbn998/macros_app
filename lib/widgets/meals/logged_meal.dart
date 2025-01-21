import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:macros_app/dialogs/logging_food/add_meal_dialog.dart';
import 'package:macros_app/models/logged_food_model.dart';
import 'package:macros_app/models/logged_meal_model.dart';
import 'package:macros_app/providers/date_provider.dart';
import 'package:macros_app/providers/logged_meal_list_provider.dart';
import 'package:macros_app/functions/macros_summary.dart';
import 'package:macros_app/providers/logged_meals_provider.dart';
import 'package:macros_app/widgets/meals/draggable_logged_food.dart';

class LoggedMealWidget extends StatelessWidget {
  final LoggedMeal loggedMeal;

  const LoggedMealWidget({
    super.key,
    required this.loggedMeal,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildTitleRow(String mealName) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Needed to center the text. Has to match the size of the IconButton(s).
          const SizedBox(width: 96),
          Expanded(
            child: Text(
              mealName,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Consumer(
            builder: (context, ref, _) {
              return IconButton(
                onPressed: () {
                  final DateTime selectedDate =
                      ref.read(selectedDateProvider.notifier).state;
                  ref
                      .read(loggedMealsProvider(selectedDate).notifier)
                      .removeLoggedMeal(selectedDate, loggedMeal.id);
                },
                icon: const Icon(Icons.delete),
              );
            },
          ),
          IconButton(
            onPressed: () {
              showAddMealDialog(context, null, loggedMeal);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      );
    }

    Widget buildMealMacrosRow() {
      return Consumer(builder: (context, ref, _) {
        final macros = ref.watch(loggedMealMacrosProvider(loggedMeal));
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.totalSummary,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                getMacrosSummary(macros),
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        );
      });
    }

    Widget buildCardContent(
      String mealTitle,
      List<LoggedFood> loggedFoodList,
    ) {
      return Column(
        children: [
          buildTitleRow(mealTitle),
          Divider(
            height: 1,
            indent: 80,
            endIndent: 80,
            color: Theme.of(context).colorScheme.primaryFixedDim,
          ),
          const SizedBox(
            height: 6,
          ),
          for (var food in loggedFoodList)
            DraggableLoggedFood(
              loggedFood: food,
              loggedMeal: loggedMeal,
            ),
          const SizedBox(height: 6),
          Divider(
            height: 1,
            indent: 80,
            endIndent: 80,
            color: Theme.of(context).colorScheme.primaryFixedDim,
          ),
          buildMealMacrosRow(),
        ],
      );
    }

    if (loggedMeal.loggedUserMeal.mealName.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        child: Card(
          child: buildCardContent(
            loggedMeal.loggedUserMeal.mealName,
            loggedMeal.loggedFood,
          ),
        ),
      );
    } else {
      return const Center();
    }
  }
}
