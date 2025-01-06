import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macros_app/databases/daily_macro_goals_db.dart';
import 'package:macros_app/databases/macro_goals_db.dart';
import 'package:macros_app/dialogs/settings/settings_macro_goal_details.dart';
import 'package:macros_app/models/macro_goal_model.dart';
import 'package:macros_app/providers/daily_macro_goals_provider.dart';

class MacroGoalsListView extends StatefulWidget {
  final List<MacroGoal> dbMacroGoals;
  final WidgetRef ref;

  @override
  State<MacroGoalsListView> createState() {
    return _MacroGoalsListViewState();
  }

  const MacroGoalsListView({
    super.key,
    required this.dbMacroGoals,
    required this.ref,
  });
}

class _MacroGoalsListViewState extends State<MacroGoalsListView> {
  late List<MacroGoal> _dbMacroGoals;

  @override
  void initState() {
    super.initState();
    _dbMacroGoals = widget.dbMacroGoals;
  }

  Widget _buildMacroGoalsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _dbMacroGoals.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            showMacroGoalDetails(context, _dbMacroGoals[index]);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .73,
                    height: 45,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _dbMacroGoals[index].goalName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    final List<int> intGoalDays =
                        await getDaysForGoal(_dbMacroGoals[index].id);
                    await deleteMacroGoal(_dbMacroGoals[index].id);
                    for (var int in intGoalDays) {
                      widget.ref.invalidate(fetchedDailyMacrosProvider(int));
                    }
                    setState(() {
                      _dbMacroGoals.removeAt(index);
                    });
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMacroGoalsList(),
      ],
    );
  }
}
