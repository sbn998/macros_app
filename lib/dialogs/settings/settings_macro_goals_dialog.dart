import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:macros_app/databases/daily_macro_goals_db.dart';
import 'package:macros_app/databases/macro_goals_db.dart';
import 'package:macros_app/functions/validators/validators.dart';
import 'package:macros_app/models/macro_goal_model.dart';
import 'package:macros_app/providers/daily_macro_goals_provider.dart';
import 'package:macros_app/widgets/buttons/close_button_widget.dart';
import 'package:macros_app/widgets/settings/macro_goals_day_selector.dart';
import 'package:macros_app/widgets/settings/macro_goals_list.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
String _mode = 'normal';
String _macroGoalName = '';
double _calories = 0.0;
double _protein = 0.0;
double _carbs = 0.0;
double _fats = 0.0;
late List<MacroGoal> _dbMacroGoals;
late Map<int, bool> _isDaySelected;
late StateSetter _setState;
late WidgetRef _ref;
late BuildContext _context;

Future<void> showMacroGoalsDialog(BuildContext context, WidgetRef ref) async {
  await _loadMacroGoals();
  _isDaySelected = {
    for (int i = 1; i < 8; i++) i: false,
  };
  _ref = ref;

  if (!context.mounted) {
    return;
  }

  bool? result = await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _buildStatefulBuilder(context),
      );
    },
  );

  if (result == null) {
    _mode = 'normal';
  }
}

Future<void> _loadMacroGoals() async {
  _dbMacroGoals = await getMacroGoals();
}

void _selectDay(int dayIndex, bool isSelected) {
  _setState(() {
    _isDaySelected[dayIndex] = isSelected;
  });
}

StatefulBuilder _buildStatefulBuilder(BuildContext context) {
  return StatefulBuilder(builder: (context, setState) {
    _setState = setState;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: _buildLayoutBuilder(context),
    );
  });
}

LayoutBuilder _buildLayoutBuilder(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      _context = context;

      Widget child = const Center(
        child: CircularProgressIndicator(),
      );

      switch (_mode) {
        case 'normal':
          child = _buildSavedMacroGoalsColumn(context);
          break;
        case 'adding':
          child = _buildAddMacroGoalForm(context);
          break;
        case 'editing':
          break;
        default:
      }
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 200,
          maxHeight: constraints.maxHeight,
        ),
        child: child,
      );
    },
  );
}

Widget _buildSavedMacroGoalsColumn(BuildContext context) {
  return Column(
    verticalDirection: VerticalDirection.up,
    mainAxisSize: MainAxisSize.min,
    children: [
      const SizedBox(
        height: 10,
      ),
      _buildButtonsRow(context),
      _addGoalsButton(context),
      MacroGoalsListView(dbMacroGoals: _dbMacroGoals, ref: _ref),
      const SizedBox(
        height: 25,
      ),
      Text(
        AppLocalizations.of(context)!.yourMacroGoals,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

Widget _buildAddMacroGoalForm(BuildContext context) {
  return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMacroGoalNameFormTextField(),
              _buildMacrosFormTextField(AppLocalizations.of(context)!.calories,
                  _calories, (newValue) => _calories = newValue),
              _buildMacrosFormTextField(AppLocalizations.of(context)!.protein,
                  _protein, (newValue) => _protein = newValue),
              _buildMacrosFormTextField(AppLocalizations.of(context)!.carbs,
                  _carbs, (newValue) => _carbs = newValue),
              _buildMacrosFormTextField(AppLocalizations.of(context)!.fats,
                  _fats, (newValue) => _fats = newValue),
              const SizedBox(
                height: 15,
              ),
              MacroGoalsDaySelector(
                initialDaySelection: _isDaySelected,
                selectDay: _selectDay,
              ),
              const SizedBox(
                height: 30,
              ),
              _buildButtonsRow(context),
            ],
          ),
        ),
      ));
}

Widget _buildMacroGoalNameFormTextField() {
  return TextFormField(
    maxLength: 20,
    decoration: InputDecoration(
      label: Text(AppLocalizations.of(_context)!.macroGoalName),
    ),
    validator: (value) {
      return validateNameString(_context, value!);
    },
    onSaved: (textFormFieldFoodName) {
      _macroGoalName = textFormFieldFoodName!;
    },
  );
}

Widget _buildMacrosFormTextField(
  String macroName,
  double initialValue,
  ValueSetter<double> onSavedCallback,
) {
  return TextFormField(
    maxLength: 5,
    decoration: InputDecoration(
      label: Text(macroName),
    ),
    validator: (value) => validateDoubleValue(_context, value!),
    onSaved: (textFormFieldValue) {
      if (textFormFieldValue != null && textFormFieldValue.isNotEmpty) {
        onSavedCallback(double.parse(textFormFieldValue));
      }
    },
  );
}

Widget _addGoalsButton(BuildContext context) {
  return TextButton(
      onPressed: null,
      child: GestureDetector(
        onTap: () {
          _setState(() {
            _mode = 'adding';
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(_context)!.addNewGoal,
              style: TextStyle(
                  fontSize: 15.0, color: Theme.of(context).colorScheme.primary),
            ),
            Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ));
}

Widget _buildButtonsRow(BuildContext context) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CloseButtonWidget(
            buttonText: _mode == 'normal'
                ? AppLocalizations.of(_context)!.buttonsClose
                : AppLocalizations.of(_context)!.buttonsCancel,
          ),
          if (_mode != 'normal')
            TextButton(
              onPressed: () {
                _saveMacroGoal();
              },
              child: Text(AppLocalizations.of(_context)!.buttonsConfirm),
            ),
        ],
      ),
    ],
  );
}

void _saveMacroGoal() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    MacroGoal newMacroGoal = MacroGoal(
      goalName: _macroGoalName,
      calories: _calories,
      protein: _protein,
      carbs: _carbs,
      fats: _fats,
    );
    await insertMacroGoal(newMacroGoal);

    for (var entry in _isDaySelected.entries) {
      if (entry.value) {
        await insertDayMacroGoal(entry.key, newMacroGoal.id);
        _ref.invalidate(fetchedDailyMacrosProvider(entry.key));
      }
    }

    _setState(
      () {
        _dbMacroGoals.add(newMacroGoal);
        _mode = 'normal';
      },
    );
  }
}
