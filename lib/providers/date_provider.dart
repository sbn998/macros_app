import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<DateTime> selectedDateProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);

final StateProvider<DateTime> displayedMonthProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);
