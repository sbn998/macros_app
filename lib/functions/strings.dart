import 'package:macros_app/constants/decimals.dart';
import 'package:macros_app/functions/double_length_format.dart';

String macrosHeaderText(Map<String, dynamic> loggedMacros,
    Map<String, dynamic> dailyMacros, String mapKey) {
  return '${doubleFormat(loggedMacros[mapKey]!, kDecimalPlaces)} / ${doubleFormat(dailyMacros[mapKey]!, kDecimalPlaces)}';
}
