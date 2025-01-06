import 'package:flutter/material.dart';

import 'package:macros_app/widgets/macros/macros_progress_widget.dart';

// TODO: Implement dynamic value functionality.
//       Show values inside the oval, as well as macro name under it.
class MacrosOverviewWidget extends StatelessWidget {
  final double currentValue;
  final double totalValue;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CircularProgressWidget(
      color: color,
      currentValue: currentValue,
      totalValue: totalValue,
    );
  }

  const MacrosOverviewWidget({
    super.key,
    required this.color,
    required this.currentValue,
    required this.totalValue,
  });
}
