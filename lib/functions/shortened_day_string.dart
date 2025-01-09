import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String shortestDay(BuildContext context, int index) {
  final AppLocalizations translation = AppLocalizations.of(context)!;

  switch (index) {
    case 0:
      return translation.daysShortestMonday;
    case 1:
      return translation.daysShortestTuesday;
    case 2:
      return translation.daysShortestWednesday;
    case 3:
      return translation.daysShortestThursday;
    case 4:
      return translation.daysShortestFriday;
    case 5:
      return translation.daysShortestSaturday;
    case 6:
      return translation.daysShortestSunday;
    default:
      return '';
  }
}
