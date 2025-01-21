import 'package:flutter/material.dart';

import 'package:macros_app/constants/weekdays.dart';
import 'package:macros_app/functions/shortened_day_string.dart';

class MacroGoalsDaySelector extends StatefulWidget {
  final Map<int, bool> initialDaySelection;
  final Function(int, bool) selectDay;

  @override
  State<StatefulWidget> createState() {
    return _MacroGoalsDaySelectorState();
  }

  const MacroGoalsDaySelector({
    super.key,
    required this.initialDaySelection,
    required this.selectDay,
  });
}

class _MacroGoalsDaySelectorState extends State<MacroGoalsDaySelector> {
  final Map<String, bool> _isDaySelected = {};

  @override
  void initState() {
    super.initState();
    for (var day in kWeekdays) {
      _isDaySelected[day] =
          widget.initialDaySelection[kWeekdays.indexOf(day) + 1] ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.spaceBetween,
      spacing: 12.0,
      runSpacing: 0.5,
      children: [
        for (var day in kWeekdays)
          TextButton(
              onPressed: () {
                setState(() {
                  _isDaySelected[day] = !_isDaySelected[day]!;
                  widget.selectDay(
                      kWeekdays.indexOf(day) + 1, _isDaySelected[day]!);
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(shortestDay(context, kWeekdays.indexOf(day))),
                  Icon(_isDaySelected[day]!
                      ? Icons.check_box
                      : Icons.check_box_outline_blank)
                ],
              ))
      ],
    );
  }
}
