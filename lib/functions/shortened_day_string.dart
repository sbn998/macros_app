import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String shortestDayStringFromInt(BuildContext context, int i) {
  switch (i) {
    case 0:
      return AppLocalizations.of(context)!.daysShortestMonday;
    case 1:
      return AppLocalizations.of(context)!.daysShortestTuesday;
    case 2:
      return AppLocalizations.of(context)!.daysShortestWednesday;
    case 3:
      return AppLocalizations.of(context)!.daysShortestThursday;
    case 4:
      return AppLocalizations.of(context)!.daysShortestFriday;
    case 5:
      return AppLocalizations.of(context)!.daysShortestSaturday;
    case 6:
      return AppLocalizations.of(context)!.daysShortestSunday;
    default:
      return '';
  }
}
