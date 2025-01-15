import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:macros_app/constants/durations.dart';

String formatDate(DateTime selectedDate, BuildContext context) {
  final today = DateTime.now();
  final AppLocalizations translations = AppLocalizations.of(context)!;

  if (isSameDay(today, selectedDate)) {
    return translations.dateToday;
  } else if (isSameDay(today.subtract(kOneDayDuration), selectedDate)) {
    return translations.dateYesterday;
  } else if (isSameDay(today.add(kOneDayDuration), selectedDate)) {
    return translations.dateTomorrow;
  } else {
    // Formats as 'January 1'.
    return DateFormat('MMMM d').format(selectedDate);
  }
}
