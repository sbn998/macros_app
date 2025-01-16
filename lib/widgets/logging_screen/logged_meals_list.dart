import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:macros_app/dialogs/logging_food/add_meal_dialog.dart';
import 'package:macros_app/models/logged_food_model.dart';
import 'package:macros_app/models/logged_meal_model.dart';
import 'package:macros_app/providers/calculated_macros_provider.dart';
import 'package:macros_app/providers/daily_macro_goals_provider.dart';
import 'package:macros_app/providers/date_provider.dart';
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

  void _updateMealInDatabase(LoggedMeal meal, LoggedMeal secondMeal) {
    final selectedDate = ref.read(selectedDateProvider.notifier).state;

    ref
        .read(loggedMealsProvider(selectedDate).notifier)
        .draggedFoodUpdate(selectedDate, meal, secondMeal);
  }

  DragTarget<LoggedFood> _dragTarget(List<LoggedMeal> loggedMeals, int index) {
    return DragTarget<LoggedFood>(
      onAcceptWithDetails: (draggedFood) {
        late int originMealIndex;
        for (var meal in loggedMeals) {
          if (meal.loggedFood.remove(draggedFood.data)) {
            originMealIndex = loggedMeals.indexOf(meal);
          }
        }
        setState(() {
          loggedMeals[index].loggedFood.add(draggedFood.data);
        });
        _updateMealInDatabase(loggedMeals[index], loggedMeals[originMealIndex]);
      },
      builder: (context, candidateData, rejectedData) {
        return LoggedMealWidget(
          loggedMeal: loggedMeals[index],
        );
      },
    );
  }

  Widget _logMealButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        showAddMealDialog(context, null, null);
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

  Widget _macrosHeader(
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
            _macrosHeader(dailyMacros, calculatedMacros),
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
                        return _dragTarget(loggedMeals, index);
                      },
                    ),
                  ),
                ],
              ),
            ),
            _logMealButton(context),
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
