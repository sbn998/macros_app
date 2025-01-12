import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:macros_app/constants/max_string_length.dart';

dynamic validateName(BuildContext context, String? nameToValidate) {
  final AppLocalizations translations = AppLocalizations.of(context)!;

  if (nameToValidate == null || nameToValidate.isEmpty) {
    return translations.nullFoodName;
  }

  if (nameToValidate.length <= kMinFoodNameLength) {
    return translations.shortFoodName;
  }
  if (nameToValidate.length > kMaxFoodNameLength) {
    return translations.longFoodName;
  }

  return null;
}

dynamic validateDoubleValue(BuildContext context, String? valueToValidate) {
  final AppLocalizations translations = AppLocalizations.of(context)!;

  if (valueToValidate != null && valueToValidate.isNotEmpty) {
    try {
      double.parse(valueToValidate);
    } catch (e) {
      return translations.invalidDouble;
    }
  }
  return null;
}
