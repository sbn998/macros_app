import 'package:macros_app/constants/map_entries.dart';

void updateDoubleValue(
  Map<dynamic, dynamic> mapToUpdate,
  String mapKey,
  String newValue,
) {
  final double parsedValue = double.parse(newValue);

  switch (mapKey) {
    case kCaloriesKey:
      mapToUpdate[kCaloriesKey] = parsedValue;
      break;
    case kProteinKey:
      mapToUpdate[kProteinKey] = parsedValue;
      break;
    case kCarbsKey:
      mapToUpdate[kCarbsKey] = parsedValue;
      break;
    case kFatsKey:
      mapToUpdate[kFatsKey] = parsedValue;
      break;
    case kServingQuantityKey:
      mapToUpdate[kServingQuantityKey] = parsedValue;
      break;
    default:
  }
}

void updateStringValue(
  Map<dynamic, dynamic> mapToUpdate,
  String mapKey,
  String newValue,
) {
  switch (mapKey) {
    case kFoodNameKey:
      mapToUpdate[kFoodNameKey] = newValue;
      break;
    case kServingNameKey:
      mapToUpdate[kServingNameKey] = newValue;
      break;
    case kGoalNameKey:
      mapToUpdate[kGoalNameKey] = newValue;
      break;
    default:
  }
}
