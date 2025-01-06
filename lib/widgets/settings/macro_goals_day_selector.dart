import 'package:flutter/material.dart';

const List<String> weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

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
    for (var day in weekdays) {
      _isDaySelected[day] =
          widget.initialDaySelection[weekdays.indexOf(day) + 1] ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var day in weekdays)
          TextButton(
              onPressed: () {
                setState(() {
                  _isDaySelected[day] = !_isDaySelected[day]!;
                  widget.selectDay(
                      weekdays.indexOf(day) + 1, _isDaySelected[day]!);
                });
              },
              child: Row(
                children: [
                  Text(_whatDayIsIt(weekdays.indexOf(day))),
                  const SizedBox(
                    width: 1,
                  ),
                  Icon(_isDaySelected[day]!
                      ? Icons.check_box
                      : Icons.check_box_outline_blank)
                ],
              ))
      ],
    );
  }
}

String _whatDayIsIt(int i) {
  switch (i) {
    case 0:
      return 'M';
    case 1:
      return 'Tu';
    case 2:
      return 'W';
    case 3:
      return 'Th';
    case 4:
      return 'F';
    case 5:
      return 'S';
    case 6:
      return 'U';
    default:
      return '';
  }
}
