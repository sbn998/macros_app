String getMacrosStringFromMap(Map<String, double> totalMacros) {
  return '${totalMacros['kcal']} kCal   ${totalMacros['protein']} P   ${totalMacros['carbs']} C   ${totalMacros['fats']} F';
}
