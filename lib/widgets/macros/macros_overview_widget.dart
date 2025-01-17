import 'package:flutter/material.dart';

import 'package:macros_app/widgets/macros/macros_progress_widget.dart';

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
