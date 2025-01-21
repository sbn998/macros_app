import 'package:macros_app/constants/decimals.dart';
import 'package:macros_app/functions/double_length_format.dart';

String macrosHeaderText(
  Map<String, dynamic> loggedMacros,
  Map<String, dynamic> dailyMacros,
  String mapKey,
) {
  return '${doubleFormat(loggedMacros[mapKey]!, kDecimalPlaces)} / ${doubleFormat(dailyMacros[mapKey]!, kDecimalPlaces)}';
}

String macrosLeft(
  Map<String, dynamic> loggedMacros,
  Map<String, dynamic> dailyMacros,
  String mapKey,
) {
  final double macrosLeft = dailyMacros[mapKey] - loggedMacros[mapKey]!;
  return '${doubleFormat(macrosLeft, kDecimalPlaces)} / ${doubleFormat(dailyMacros[mapKey]!, kDecimalPlaces)}';
}

extension CapitalizeString on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
