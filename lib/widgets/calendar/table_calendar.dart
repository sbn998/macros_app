import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macros_app/functions/format_date.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:macros_app/constants/date_times.dart';
import 'package:macros_app/providers/calendar_provider.dart';
import 'package:macros_app/providers/date_provider.dart';

class CustomTableCalendar extends ConsumerWidget {
  const CustomTableCalendar({super.key});

  CalendarBuilders _calendarBuilder(List<DateTime>? data) {
    return CalendarBuilders(markerBuilder: (context, date, events) {
      final markedDates = data;

      if (markedDates != null &&
          markedDates.any((markedDate) =>
              markedDate.year == date.year &&
              markedDate.month == date.month &&
              markedDate.day == date.day)) {
        return Positioned(
          bottom: 4,
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
        );
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime selectedDate = ref.watch(selectedDateProvider);
    final DateTime displayedMonth = ref.watch(displayedMonthProvider);
    final markedDatesAsync = ref.watch(fetchedMonthLoggedMeals(displayedMonth));

    if (markedDatesAsync is AsyncData) {
      return TableCalendar(
        focusedDay: displayedMonth,
        firstDay: kFirstCalendarYear,
        lastDay: kLastCalendarYear,
        currentDay: selectedDate,
        calendarFormat: CalendarFormat.month,
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextFormatter: (date, _) {
            return formatCalendarTitle(context, date);
          },
        ),
        calendarStyle: const CalendarStyle(
          weekendTextStyle: TextStyle(),
          outsideDaysVisible: false,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(dowTextFormatter: (day, _) {
          return formatCalendarDays(context, day);
        }),
        calendarBuilders: _calendarBuilder(markedDatesAsync.value),
        onDaySelected: (tappedDay, focusedDay) {
          if (!isSameDay(tappedDay, selectedDate)) {
            ref.read(selectedDateProvider.notifier).state = tappedDay;
          }
          Navigator.pop(context);
        },
        onPageChanged: (month) {
          if (month != displayedMonth) {
            ref.read(displayedMonthProvider.notifier).state = month;
          }
        },
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
