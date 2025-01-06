import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macros_app/providers/calendar_provider.dart';

import 'package:macros_app/providers/date_provider.dart';
import 'package:table_calendar/table_calendar.dart';

void showCalendar(BuildContext context) {
  late WidgetRef globalRef;

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: SizedBox(
          width: double.infinity,
          height: 450.0,
          child: Column(
            children: [
              Consumer(builder: (context, ref, _) {
                globalRef = ref;
                final DateTime selectedDate = ref.watch(selectedDateProvider);
                final DateTime displayedMonth =
                    ref.watch(displayedMonthProvider);
                final markedDatesAsync =
                    ref.watch(fetchedMonthLoggedMeals(displayedMonth));

                if (markedDatesAsync is AsyncData) {
                  return TableCalendar(
                    focusedDay: displayedMonth,
                    firstDay: DateTime(2000),
                    lastDay: DateTime(2100),
                    currentDay: selectedDate,
                    calendarFormat: CalendarFormat.month,
                    headerStyle: const HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                    ),
                    calendarStyle: const CalendarStyle(
                      weekendTextStyle: TextStyle(),
                      outsideDaysVisible: false,
                    ),
                    calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, date, events) {
                      final markedDates = markedDatesAsync.value;

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
                    }),
                    onDaySelected: (tappedDay, focusedDay) {
                      if (!isSameDay(tappedDay, selectedDate)) {
                        ref.read(selectedDateProvider.notifier).state =
                            tappedDay;
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
                  return const Center(child: CircularProgressIndicator());
                }
              }),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      globalRef.read(selectedDateProvider.notifier).state =
                          DateTime.now();
                      globalRef.read(displayedMonthProvider.notifier).state =
                          DateTime.now();
                      Navigator.pop(context);
                    },
                    child: const Text('Today'),
                  ),
                  const SizedBox(width: 10.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}
