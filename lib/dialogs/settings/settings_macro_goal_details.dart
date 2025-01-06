import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:macros_app/databases/daily_macro_goals_db.dart';
import 'package:macros_app/databases/macro_goals_db.dart';
import 'package:macros_app/models/macro_goal_model.dart';
import 'package:macros_app/providers/daily_macro_goals_provider.dart';
import 'package:macros_app/widgets/settings/macro_goals_day_selector.dart';

//TODO: add way to select days for each goal.

bool _isEditing = false;
Map<String, dynamic> _editableValues = {};
Map<String, TextEditingController> _controllers = {};
late List<int> _fetchedMacroGoalDays;
late Map<int, bool> _isDaySelected;
late StateSetter _setState;
late MacroGoal _tappedMacroGoal;
late WidgetRef _ref;

enum MacroGoalFields {
  calories,
  protein,
  carbs,
  fats,
}

void showMacroGoalDetails(
    BuildContext context, MacroGoal tappedMacroGoal) async {
  _tappedMacroGoal = tappedMacroGoal;
  _isDaySelected = {
    for (var i = 1; i < 8; i++) i: false,
  };
  await _getDaysForMacroGoal(_tappedMacroGoal);
  _editableValues = tappedMacroGoal.toMap();

  if (!context.mounted) {
    return;
  }

  _disposeControllers();

  _controllers['goal_name'] =
      TextEditingController(text: _tappedMacroGoal.goalName);

  for (var field in MacroGoalFields.values) {
    String fieldName = field.name;
    if (!_controllers.containsKey(fieldName)) {
      _controllers[fieldName] = TextEditingController(
        text: _editableValues[fieldName]?.toString() ?? '',
      );
    }
  }

  bool? result = await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      return Consumer(
        builder: (context, ref, _) {
          _ref = ref;

          return Padding(
            padding: EdgeInsets.only(
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: _buildStatefulBuilder(context),
          );
        },
      );
    },
  );

  _disposeControllers();

  if (result == null) {
    _isEditing = false;
  }
}

Future<void> _getDaysForMacroGoal(MacroGoal goal) async {
  _fetchedMacroGoalDays = await getDaysForGoal(goal.id);
  for (var value in _fetchedMacroGoalDays) {
    if (_isDaySelected.containsKey(value)) {
      _isDaySelected[value] = true;
    }
  }
}

void _selectDay(int dayIndex, bool isSelected) {
  _setState(() {
    _isDaySelected[dayIndex] = isSelected;
  });
}

void _updateMacroGoal() async {
  await updateMacroGoal(_tappedMacroGoal);

  for (var entry in _isDaySelected.entries) {
    if (entry.value) {
      await insertDayMacroGoal(entry.key, _tappedMacroGoal.id);
      _ref.invalidate(fetchedDailyMacrosProvider(entry.key));
    }
  }
}

void _disposeControllers() {
  _controllers.forEach((key, controller) => controller.dispose());
  _controllers.clear();
}

String _capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

StatefulBuilder _buildStatefulBuilder(BuildContext context) {
  return StatefulBuilder(
    builder: (context, setState) {
      _setState = setState;
      return Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        child: _buildStatefulBuilderDetailsOverview(context),
      );
    },
  );
}

Widget _buildStatefulBuilderDetailsOverview(
  BuildContext context,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      _buildStatefulBuilderDetailsOverviewHeader(context),
      for (var field in MacroGoalFields.values)
        _buildStatefulBuilderDetailsMacrosRow(field.name),
      const SizedBox(
        height: 20,
      ),
      GestureDetector(
        onTap: _isEditing ? null : () {},
        behavior:
            _isEditing ? HitTestBehavior.translucent : HitTestBehavior.opaque,
        child: AbsorbPointer(
          absorbing: !_isEditing,
          child: MacroGoalsDaySelector(
            initialDaySelection: _isDaySelected,
            selectDay: _selectDay,
          ),
        ),
      ),
      const SizedBox(
        height: 35,
      ),
      _buildStatefulBuilderDetailsOverviewBottomButtons(context),
    ],
  );
}

Widget _buildStatefulBuilderDetailsOverviewHeader(
  BuildContext context,
) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _isEditing
            ? [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: _controllers['goal_name'],
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                    keyboardType: TextInputType.text,
                    onChanged: (newValue) {
                      if (newValue.isNotEmpty) {
                        _editableValues['goal_name'] = newValue;
                      }
                    },
                  ),
                ),
              ]
            : [
                Text(
                  _tappedMacroGoal.goalName,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(
                  width: 30,
                ),
                IconButton(
                  onPressed: () {
                    _setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                  icon: const Icon(Icons.edit),
                ),
              ]),
  );
}

Widget _buildStatefulBuilderDetailsMacrosRow(String firstMacro) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _buildStatefulBuilderDetailsMacrosRowContent(firstMacro),
    ),
  );
}

List<Widget> _buildStatefulBuilderDetailsMacrosRowContent(
  String macroFieldName,
) {
  String properName =
      macroFieldName == 'carbs' ? 'carbohydrates' : macroFieldName;
  return [
    Text(
      '${_capitalizeFirstLetter(properName)}:',
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
      ),
    ),
    _buildStatefulBuilderDetailsMacrosRowEditingMode(
        _isEditing, macroFieldName),
  ];
}

Widget _buildStatefulBuilderDetailsMacrosRowEditingMode(
  bool isEditing,
  String macroFieldName,
) {
  return _isEditing
      ? SizedBox(
          width: 90,
          child: TextField(
            keyboardType: TextInputType.number,
            controller: _controllers[macroFieldName]!,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            onChanged: (newValue) {
              if (newValue.isNotEmpty) {
                _editableValues[macroFieldName] = double.parse(newValue);
              }
            },
          ),
        )
      : Text(
          '${_tappedMacroGoal.toMap()[macroFieldName]}',
          style: const TextStyle(
            fontSize: 18,
          ),
        );
}

Widget _buildStatefulBuilderDetailsOverviewBottomButtons(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: _isEditing
        ? [
            TextButton(
                onPressed: () {
                  _setState(() => _isEditing = false);
                },
                child: const Text('Cancel')),
            const SizedBox(
              width: 12,
            ),
            ElevatedButton(
                onPressed: () {
                  _setState(() {
                    _isEditing = false;
                    _tappedMacroGoal.updateMacroGoalFromMap(_editableValues);
                    _updateMacroGoal();
                  });
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onSecondary),
                child: const Text('Confirm changes'))
          ]
        : [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'))
          ],
  );
}
