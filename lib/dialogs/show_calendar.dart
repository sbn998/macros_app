import 'package:flutter/material.dart';

import 'package:macros_app/widgets/buttons/calendar_buttons_row.dart';
import 'package:macros_app/widgets/calendar/table_calendar.dart';

void showCalendar(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return const Dialog(
        child: SizedBox(
          width: double.infinity,
          height: 450.0,
          child: Column(
            children: [
              CustomTableCalendar(),
              Spacer(),
              CalendarButtonsRow(),
            ],
          ),
        ),
      );
    },
  );
}
