import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:macros_app/databases/daily_macro_goals_db.dart';
import 'package:macros_app/dialogs/settings/settings_macro_goal_details.dart';
import 'package:macros_app/models/macro_goal_model.dart';
import 'package:macros_app/providers/daily_macro_goals_provider.dart';
import 'package:macros_app/providers/macro_goals_provider.dart';

class MacroGoalsListView extends ConsumerStatefulWidget {
  final DateTime? date;

  @override
  ConsumerState<MacroGoalsListView> createState() {
    return _MacroGoalsListViewState();
  }

  const MacroGoalsListView({
    super.key,
    required this.date,
  });
}

class _MacroGoalsListViewState extends ConsumerState<MacroGoalsListView> {
  Future<void> _selectForDate(MacroGoal goal) async {
    if (widget.date != null) {
      if (!context.mounted) {
        return;
      }

      await insertDayMacroGoal(widget.date!.weekday, goal.id);
      ref.invalidate(fetchedDailyMacrosProvider(widget.date!.weekday));

      Navigator.of(context).pop();
    } else {
      showMacroGoalDetails(context, goal);
    }
  }

  Widget _buildMacroGoalsList(List<MacroGoal> macroGoals) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: macroGoals.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            _selectForDate(macroGoals[index]);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Card(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: SizedBox(
                      height: 45,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            macroGoals[index].goalName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final List<int> intGoalDays =
                        await getDaysForGoal(macroGoals[index].id);
                    ref
                        .read(macroGoalsProvider.notifier)
                        .removeMacroGoal(macroGoals[index]);
                    for (var int in intGoalDays) {
                      ref.invalidate(fetchedDailyMacrosProvider(int));
                    }
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<MacroGoal> macroGoals = ref.watch(macroGoalsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMacroGoalsList(macroGoals),
      ],
    );
  }
}
