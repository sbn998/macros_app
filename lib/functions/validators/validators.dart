import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';

dynamic validateName(
  BuildContext context,
  String? nameToValidate,
  int maxLength,
  int minLength,
) {
  final AppLocalizations translations = AppLocalizations.of(context)!;

  if (nameToValidate == null || nameToValidate.isEmpty) {
    return translations.nullFoodName;
  }

  if (nameToValidate.length <= minLength) {
    return translations.shortFoodName;
  }
  if (nameToValidate.length > maxLength) {
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
