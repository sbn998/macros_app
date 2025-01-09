import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:macros_app/constants/max_string_length.dart';

dynamic validateNameString(BuildContext context, String? nameToValidate) {
  if (nameToValidate == null || nameToValidate.isEmpty) {
    return AppLocalizations.of(context)!.nullFoodName;
  }

  if (nameToValidate.length <= kMinFoodNameLength) {
    return AppLocalizations.of(context)!.shortFoodName;
  }
  if (nameToValidate.length > kMaxFoodNameLength) {
    return AppLocalizations.of(context)!.longFoodName;
  }

  return null;
}

dynamic validateDoubleValue(BuildContext context, String? valueToValidate) {
  if (valueToValidate != null && valueToValidate.isNotEmpty) {
    try {
      double.parse(valueToValidate);
    } catch (e) {
      return AppLocalizations.of(context)!.invalidDouble;
    }
  }
  return null;
}
