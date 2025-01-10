import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:macros_app/dialogs/food_screen/add_food_dialog.dart';
import 'package:macros_app/dialogs/logging_food/add_meal_dialog.dart';
import 'package:macros_app/models/food_model.dart';
import 'package:macros_app/models/logged_food_model.dart';

import 'package:macros_app/models/logged_meal_model.dart';
import 'package:macros_app/providers/calculated_macros_provider.dart';
import 'package:macros_app/providers/daily_macro_goals_provider.dart';
import 'package:macros_app/providers/date_provider.dart';
import 'package:macros_app/providers/logged_meal_list_provider.dart';
import 'package:macros_app/providers/logged_meals_provider.dart';
import 'package:macros_app/widgets/logging_screen/macros_eaten_overview.dart';
import 'package:macros_app/widgets/logging_screen/no_macro_goal_widget.dart';
import 'package:macros_app/widgets/meals/logged_meal.dart';

class LoggedMealsList extends ConsumerStatefulWidget {
  const LoggedMealsList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _LoggedMealsListState();
  }
}

class _LoggedMealsListState extends ConsumerState<LoggedMealsList> {
  final ScrollController _scrollController = ScrollController();
  late AppLocalizations _translations;

  void _updateMealInDatabase(LoggedMeal meal, LoggedMeal secondMeal) async {
    final selectedDate = ref.read(selectedDateProvider.notifier).state;
    await ref
        .read(loggedMealsProvider(selectedDate).notifier)
        .updateLoggedMeal(selectedDate, meal);
    await ref
        .read(loggedMealsProvider(selectedDate).notifier)
        .updateLoggedMeal(selectedDate, secondMeal);
  }

  Widget _buildLogMealButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        showAddMealDialog(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_translations.buttonsLogMeal),
          const Icon(Icons.add),
        ],
      ),
    );
  }

  Widget _buildMacrosHeader(
    Map<String, dynamic> dailyMacros,
    Map<String, double> loggedMacros,
  ) {
    if (dailyMacros.isNotEmpty) {
      return MacrosEatenOverview(
        dailyMacros: dailyMacros,
        loggedMacros: loggedMacros,
      );
    } else {
      return const EmptyDailyMacroGoal();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _translations = AppLocalizations.of(context)!;

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
            _buildMacrosHeader(dailyMacros, calculatedMacros),
            Expanded(
              child: ListView(
                children: [
                  Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: loggedMeals.length,
                      itemBuilder: (context, index) {
                        return DragTarget<LoggedFood>(
                          onAcceptWithDetails: (draggedFood) {
                            late int originMealIndex;
                            for (var meal in loggedMeals) {
                              if (meal.loggedFood.remove(draggedFood.data)) {
                                originMealIndex = loggedMeals.indexOf(meal);
                              }
                            }
                            loggedMeals[index].loggedFood.add(draggedFood.data);
                            ref
                                .read(
                                    loggedMealProviderFamily(loggedMeals[index])
                                        .notifier)
                                .addFood(draggedFood.data);
                            ref
                                .read(loggedMealProviderFamily(
                                        loggedMeals[originMealIndex])
                                    .notifier)
                                .removeFood(draggedFood.data);
                            _updateMealInDatabase(loggedMeals[index],
                                loggedMeals[originMealIndex]);
                          },
                          builder: (context, candidateData, rejectedData) {
                            return LoggedMealWidget(
                              key: Key(ref
                                  .read(selectedDateProvider.notifier)
                                  .state
                                  .toString()),
                              loggedMeal: loggedMeals[index],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            _buildLogMealButton(context),
          ],
        );
      },
      loading: () {
        return const CircularProgressIndicator();
      },
      error: (error, stack) {
        return Text('${_translations.error}: $error');
      },
    );
  }
}
