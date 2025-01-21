import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:macros_app/functions/strings.dart';
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
    return formatForLocale(context, selectedDate);
  }
}

String formatForLocale(BuildContext context, DateTime selectedDate) {
  String locale = Localizations.localeOf(context).toString();

  String dateFormatPattern;

  if (locale.startsWith('en') || locale.startsWith('zh')) {
    // Formats as 'January 1'
    dateFormatPattern = 'MMMM d';
  } else {
    // Formats as '1 January'
    dateFormatPattern = 'd MMMM';
  }

  final DateFormat dateFormat = DateFormat(dateFormatPattern, locale);

  String formattedDate = dateFormat.format(selectedDate);

  List<String> parts = formattedDate.split(' ');
  if (parts.isNotEmpty) {
    parts[1] = parts[1].capitalize(); // Capitalize the month (second part)
  }
  return parts.join(' ');
}

String formatCalendarTitle(BuildContext context, DateTime displayedMonth) {
  String locale = Localizations.localeOf(context).toString();

  final DateFormat dateFormat = DateFormat('MMMM yyyy', locale);

  String formattedDate = dateFormat.format(displayedMonth);

  List<String> parts = formattedDate.split(' ');
  if (parts.isNotEmpty) {
    parts[0] = parts[0].capitalize(); // Capitalize the month (second part)
  }
  return parts.join(' ');
}

String formatCalendarDays(BuildContext context, DateTime day) {
  final String locale = Localizations.localeOf(context).toString();
  final DateFormat dateFormat = DateFormat('EEE', locale);
  return dateFormat.format(day).capitalize();
}
