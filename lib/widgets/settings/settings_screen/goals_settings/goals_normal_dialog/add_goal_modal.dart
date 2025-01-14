import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:macros_app/constants/map_entries.dart';
import 'package:macros_app/databases/daily_macro_goals_db.dart';
import 'package:macros_app/functions/initialize_goal_days_map.dart';
import 'package:macros_app/models/macro_goal_model.dart';
import 'package:macros_app/providers/daily_macro_goals_provider.dart';
import 'package:macros_app/providers/macro_goals_provider.dart';
import 'package:macros_app/widgets/buttons/close_button_widget.dart';
import 'package:macros_app/widgets/buttons/confirm_button_widget.dart';
import 'package:macros_app/widgets/settings/macro_goals_day_selector.dart';
import 'package:macros_app/widgets/settings/settings_screen/goals_settings/goals_normal_dialog/goal_form_content.dart';
import 'package:macros_app/functions/update_map_values.dart';

class AddGoalModal extends ConsumerStatefulWidget {
  final Function() onAddedGoal;

  const AddGoalModal({
    super.key,
    required this.onAddedGoal,
  });

  @override
  ConsumerState<AddGoalModal> createState() => _AddGoalModalState();
}

class _AddGoalModalState extends ConsumerState<AddGoalModal> {
  late final Map<int, bool> _selectedDays;
  late final GlobalKey<FormState> _formKey;
  late final Map<String, dynamic> _goalValues;

  void _initializeGoalValues() {
    _goalValues = {
      kGoalNameKey: '',
      kCaloriesKey: 0.0,
      kProteinKey: 0.0,
      kCarbsKey: 0.0,
      kFatsKey: 0.0,
    };
  }

  void _selectDay(int dayIndex, bool isSelected) {
    setState(() {
      _selectedDays[dayIndex] = isSelected;
    });
  }

  void _saveMacroGoal() async {
    if (!context.mounted) {
      return;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      MacroGoal newMacroGoal = MacroGoal(
        goalName: _goalValues[kGoalNameKey],
        calories: _goalValues[kCaloriesKey],
        protein: _goalValues[kProteinKey],
        carbs: _goalValues[kCarbsKey],
        fats: _goalValues[kFatsKey],
      );

      ref.read(macroGoalsProvider.notifier).addMacroGoal(newMacroGoal);

      for (var entry in _selectedDays.entries) {
        if (entry.value) {
          await insertDayMacroGoal(entry.key, newMacroGoal.id);
          ref.invalidate(fetchedDailyMacrosProvider(entry.key));
        }
      }

      widget.onAddedGoal();
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedDays = initializeGoalDaysMap();
    _formKey = GlobalKey<FormState>();
    _initializeGoalValues();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translations = AppLocalizations.of(context)!;

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: contentColumn(translations),
          ),
        ));
  }

  Column contentColumn(AppLocalizations translations) {
    return Column(
      children: [
        AddGoalFormContent(
          callbackMap: _goalValues,
          onSavedNameCallback: updateStringValue,
          onSavedDoubleCallback: updateDoubleValue,
        ),
        const SizedBox(height: 15.0),
        MacroGoalsDaySelector(
          initialDaySelection: _selectedDays,
          selectDay: _selectDay,
        ),
        const SizedBox(
          height: 30,
        ),
        buttonsRow(translations)
      ],
    );
  }

  Row buttonsRow(AppLocalizations translations) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CloseButtonWidget(
          buttonText: translations.buttonsCancel,
        ),
        ConfirmButtonWidget(callback: _saveMacroGoal),
      ],
    );
  }
}
