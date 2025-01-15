import 'package:flutter/material.dart';

import 'package:macros_app/constants/durations.dart';

DateTime detectSwipeDirection(DateTime date, DragEndDetails dragDetails) {
  if (dragDetails.primaryVelocity! > 0) {
    // Velocity > 0 = dragging right.
    return date.subtract(kOneDayDuration);
  } else {
    // Velocity < 0 = dragging left.
    return date.add(kOneDayDuration);
  }
}
