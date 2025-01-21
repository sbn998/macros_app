Map<int, bool> initializeGoalDaysMap() {
  final Map<int, bool> initializedMap = {};
  for (var i = 1; i < 8; i++) {
    initializedMap[i] = false;
  }
  return initializedMap;
}
