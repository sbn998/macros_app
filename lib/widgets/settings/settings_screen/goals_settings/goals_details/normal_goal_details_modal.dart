import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:macros_app/models/macro_goal_model.dart';
import 'package:macros_app/constants/map_entries.dart';
import 'package:macros_app/widgets/settings/macro_goals_day_selector.dart';
import 'package:macros_app/widgets/text/details_field.dart';
import 'package:macros_app/widgets/text/dialog_title.dart';

class SavedGoalDetailsModal extends StatelessWidget {
  final MacroGoal tappedGoal;
  final Map<int, bool> selectedDays;
  final Function() onPressEdit;

  const SavedGoalDetailsModal({
    super.key,
    required this.tappedGoal,
    required this.selectedDays,
    required this.onPressEdit,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translations = AppLocalizations.of(context)!;
    final Map<String, String> localizationMap = {
      kCaloriesKey: translations.calories,
      kFatsKey: translations.fats,
      kCarbsKey: translations.carbs,
      kProteinKey: translations.protein,
    };

    final Map<String, dynamic> goalMap = {
      kCaloriesKey: tappedGoal.calories,
      kFatsKey: tappedGoal.fats,
      kCarbsKey: tappedGoal.carbs,
      kProteinKey: tappedGoal.protein,
    };

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DetailsDialogTitle(
              onPressEdit: onPressEdit,
              title: tappedGoal.goalName,
            ),
            const SizedBox(height: 20.0),
            for (var key in localizationMap.keys)
              DetailsField(
                fieldName: localizationMap[key]!,
                fieldValue: goalMap[key].toString(),
              ),
            const SizedBox(
              height: 20.0,
            ),
            AbsorbPointer(
              absorbing: true,
              child: MacroGoalsDaySelector(
                initialDaySelection: selectedDays,
                selectDay: (integer, boolean) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
