import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:macros_app/functions/modify_daily_macro_goals_db.dart';
import 'package:macros_app/models/macro_goal_model.dart';
import 'package:macros_app/constants/map_entries.dart';
import 'package:macros_app/providers/daily_macro_goals_provider.dart';
import 'package:macros_app/providers/macro_goals_provider.dart';
import 'package:macros_app/widgets/buttons/close_button_widget.dart';
import 'package:macros_app/widgets/buttons/confirm_button_widget.dart';
import 'package:macros_app/widgets/settings/macro_goals_day_selector.dart';
import 'package:macros_app/widgets/text_fields/double_text_field.dart';
import 'package:macros_app/widgets/text_fields/name_text_field.dart';

class EditingGoalModal extends ConsumerStatefulWidget {
  final MacroGoal tappedGoal;
  final Map<int, bool> selectedDays;

  const EditingGoalModal({
    super.key,
    required this.selectedDays,
    required this.tappedGoal,
  });

  @override
  ConsumerState<EditingGoalModal> createState() {
    return _EditingGoalModal();
  }
}

class _EditingGoalModal extends ConsumerState<EditingGoalModal> {
  late Map<String, dynamic> _editableValues;
  late Map<String, TextEditingController> _controllers;
  late Map<int, bool> _selectedDays;

  void _populateControllers() {
    _controllers = {};
    for (var key in _editableValues.keys) {
      _controllers[key] =
          TextEditingController(text: _editableValues[key]?.toString() ?? '');
    }
  }

  Future<void> _updateMacroGoal() async {
    widget.tappedGoal.updateMacroGoalFromMap(_editableValues);
    ref.read(macroGoalsProvider.notifier).updateMacroGoal(widget.tappedGoal);

    await modifyDailyMacroGoalsDb(
      widget.selectedDays,
      _selectedDays,
      widget.tappedGoal.id,
    );
    _invalidateProvider();
  }

  void _invalidateProvider() {
    for (var entry in _selectedDays.entries) {
      ref.invalidate(fetchedDailyMacrosProvider(entry.key));
    }
  }

  void _selectDay(int dayIndex, bool isSelected) {
    setState(() {
      _selectedDays[dayIndex] = isSelected;
    });
  }

  @override
  void initState() {
    super.initState();
    _editableValues = widget.tappedGoal.toMap();
    _populateControllers();
    _selectedDays = Map.from(widget.selectedDays);
  }

  @override
  void dispose() {
    _controllers.forEach((key, value) => value.dispose());
    _controllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translations = AppLocalizations.of(context)!;
    final Map<String, String> localizationMap = {
      kCaloriesKey: translations.calories,
      kFatsKey: translations.fats,
      kCarbsKey: translations.carbs,
      kProteinKey: translations.protein,
    };

    Widget buttonsRow() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const CloseButtonWidget(),
          Consumer(
            builder: (context, ref, _) {
              return ConfirmButtonWidget(
                callback: () {
                  _updateMacroGoal();
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          bottom: 18.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NameTextField(
              callbackMap: _editableValues,
              controller: _controllers[kGoalNameKey]!,
              mapKey: kGoalNameKey,
            ),
            const SizedBox(height: 20.0),
            for (var key in localizationMap.keys)
              DoubleTextField(
                callbackMap: _editableValues,
                controller: _controllers[key]!,
                mapKey: key,
              ),
            const SizedBox(height: 20.0),
            MacroGoalsDaySelector(
              initialDaySelection: _selectedDays,
              selectDay: _selectDay,
            ),
            const Spacer(),
            buttonsRow(),
          ],
        ),
      ),
    );
  }
}
