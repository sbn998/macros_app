import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:macros_app/dialogs/logging_food/add_meal_dialog.dart';
import 'package:macros_app/dialogs/settings/settings_macro_goals_dialog.dart';
import 'package:macros_app/models/logged_food_model.dart';
import 'package:macros_app/models/logged_meal_model.dart';
import 'package:macros_app/providers/calculated_macros_provider.dart';
import 'package:macros_app/providers/daily_macro_goals_provider.dart';
import 'package:macros_app/providers/date_provider.dart';
import 'package:macros_app/providers/logged_meal_list_provider.dart';
import 'package:macros_app/providers/logged_meals_provider.dart';
import 'package:macros_app/widgets/macros/macros_overview_widget.dart';
import 'package:macros_app/widgets/meals/logged_meal.dart';

late BuildContext _context;
late WidgetRef _ref;

class LoggingScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoggingScreen> createState() {
    return _LoggingScreenState();
  }

  const LoggingScreen({
    super.key,
  });
}

class _LoggingScreenState extends ConsumerState<LoggingScreen> {
  void _updateMealInDatabase(LoggedMeal meal, LoggedMeal secondMeal) async {
    final selectedDate = ref.read(selectedDateProvider.notifier).state;
    await ref
        .read(loggedMealsProvider(selectedDate).notifier)
        .updateLoggedMeal(selectedDate, meal);
    await ref
        .read(loggedMealsProvider(selectedDate).notifier)
        .updateLoggedMeal(selectedDate, secondMeal);
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    _ref = ref;

    final DateTime dateToFetch = ref.watch(selectedDateProvider);
    final List<LoggedMeal> loggedMeals =
        ref.watch(loggedMealsProvider(dateToFetch));
    final dailyMacros =
        ref.watch(fetchedDailyMacrosProvider(dateToFetch.weekday));
    final Map<String, double> calculatedMacros =
        ref.watch(calculatedMacrosProvider);

    return dailyMacros.when(
      data: (dailyMacros) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMacrosHeader(
              dailyMacros,
              calculatedMacros,
            ),
            SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.63,
                child: _buildList(ref, loggedMeals, _updateMealInDatabase)),
            _buildLogMealButton(ref, context),
          ],
        );
      },
      loading: () {
        return const CircularProgressIndicator();
      },
      error: (error, stack) {
        return Text('Error: $error');
      },
    );
  }
}

Widget _buildMacrosHeader(
  Map<String, dynamic> dailyMacros,
  Map<String, double> loggedMacros,
) {
  if (dailyMacros.isNotEmpty) {
    return _buildMacrosOverview(
      dailyMacros['calories'] as double,
      dailyMacros['protein'] as double,
      dailyMacros['carbs'] as double,
      dailyMacros['fats'] as double,
      loggedMacros['calories'] as double,
      loggedMacros['protein'] as double,
      loggedMacros['carbs'] as double,
      loggedMacros['fats'] as double,
    );
  } else {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(_context).size.height * 0.18,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No goals',
            style: TextStyle(fontSize: 15.0),
          ),
          const SizedBox(
            height: 18,
          ),
          GestureDetector(
            onTap: () {
              showMacroGoalsDialog(_context, _ref);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Start by adding one',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Theme.of(_context).colorScheme.primary),
                ),
                Icon(
                  Icons.add,
                  color: Theme.of(_context).colorScheme.primary,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget _buildMacrosOverview(
  double goalCalories,
  double goalProtein,
  double goalCarbs,
  double goalFats,
  double eatenCalories,
  double eatenProtein,
  double eatenCarbs,
  double eatenFats,
) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 28,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            const Text('Calories'),
            const SizedBox(height: 8),
            MacrosOverviewWidget(
              color: Colors.green,
              currentValue: eatenCalories,
              totalValue: goalCalories,
            ),
            const SizedBox(height: 10),
            Text(
              '$eatenCalories / $goalCalories',
            ),
            const SizedBox(
              height: 30,
            ),
            const Text('Protein'),
            const SizedBox(
              height: 8,
            ),
            MacrosOverviewWidget(
              color: Colors.blue,
              currentValue: eatenProtein,
              totalValue: goalProtein,
            ),
            const SizedBox(height: 10),
            Text(
              '$eatenProtein / $goalProtein',
            ),
          ],
        ),
        // const SizedBox(
        //   width: 50,
        // ),
        Column(
          children: [
            const Text('Carbs'),
            const SizedBox(
              height: 8,
            ),
            MacrosOverviewWidget(
              color: Colors.red,
              currentValue: eatenCarbs,
              totalValue: goalCarbs,
            ),
            const SizedBox(height: 10),
            Text(
              '$eatenCarbs / $goalCarbs',
            ),
            const SizedBox(
              height: 30,
            ),
            const Text('Fats'),
            const SizedBox(
              height: 8,
            ),
            MacrosOverviewWidget(
              color: Colors.amber,
              currentValue: eatenFats,
              totalValue: goalFats,
            ),
            const SizedBox(height: 10),
            Text(
              '$eatenFats / $goalFats',
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildList(
  WidgetRef ref,
  List<LoggedMeal> loggedMealsList,
  Function(LoggedMeal meal, LoggedMeal secondMeal) updateDatabase,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: loggedMealsList.length,
      itemBuilder: (context, index) {
        return DragTarget<LoggedFood>(
          onAcceptWithDetails: (draggedFood) {
            late int originMealIndex;
            for (var meal in loggedMealsList) {
              if (meal.loggedFood.remove(draggedFood.data)) {
                originMealIndex = loggedMealsList.indexOf(meal);
              }
            }
            loggedMealsList[index].loggedFood.add(draggedFood.data);
            ref
                .read(loggedMealProviderFamily(loggedMealsList[index]).notifier)
                .addFood(draggedFood.data);
            ref
                .read(loggedMealProviderFamily(loggedMealsList[originMealIndex])
                    .notifier)
                .removeFood(draggedFood.data);
            updateDatabase(
                loggedMealsList[index], loggedMealsList[originMealIndex]);
          },
          builder: (context, candidateData, rejectedData) {
            return LoggedMealWidget(
              key:
                  Key(ref.read(selectedDateProvider.notifier).state.toString()),
              loggedMeal: loggedMealsList[index],
            );
          },
        );
      },
    ),
  );
}

Widget _buildLogMealButton(WidgetRef ref, BuildContext context) {
  return TextButton(
    onPressed: () {
      showAddMealDialog(
        context,
        ref,
      );
    },
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Log your meals!'),
        Icon(Icons.add),
      ],
    ),
  );
}
