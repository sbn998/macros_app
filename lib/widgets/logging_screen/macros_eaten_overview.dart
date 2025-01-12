import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:macros_app/constants/decimals.dart';

import 'package:macros_app/constants/map_entries.dart';
import 'package:macros_app/functions/double_length_format.dart';
import 'package:macros_app/widgets/macros/macros_overview_widget.dart';

class MacrosEatenOverview extends StatelessWidget {
  final Map<String, dynamic> dailyMacros;
  final Map<String, double> loggedMacros;

  const MacrosEatenOverview({
    super.key,
    required this.dailyMacros,
    required this.loggedMacros,
  });

  @override
  Widget build(BuildContext context) {
    Widget macrosColumn(String firstKey, String secondKey) {
      final Map<String, String> localizationMap = {
        kCaloriesKey: AppLocalizations.of(context)!.calories,
        kProteinKey: AppLocalizations.of(context)!.protein,
        kCarbsKey: AppLocalizations.of(context)!.carbs,
        kFatsKey: AppLocalizations.of(context)!.fats,
      };

      final Map<String, Color> colorsMap = {
        kCaloriesKey: Colors.blue,
        kProteinKey: Colors.green,
        kCarbsKey: Colors.red,
        kFatsKey: Colors.amber,
      };

      return Column(
        children: [
          Text(localizationMap[firstKey]!),
          const SizedBox(
            height: 8,
          ),
          MacrosOverviewWidget(
            color: colorsMap[firstKey]!,
            currentValue: loggedMacros[firstKey] as double,
            totalValue: dailyMacros[firstKey]!,
          ),
          const SizedBox(height: 10),
          Text(
            '${doubleFormat(loggedMacros[firstKey]!, kDecimalPlaces)} / ${doubleFormat(dailyMacros[firstKey]!, kDecimalPlaces)}',
          ),
          const SizedBox(
            height: 30,
          ),
          Text(localizationMap[secondKey]!),
          const SizedBox(
            height: 8,
          ),
          MacrosOverviewWidget(
            color: colorsMap[secondKey]!,
            currentValue: loggedMacros[secondKey] as double,
            totalValue: dailyMacros[secondKey]!,
          ),
          const SizedBox(height: 10),
          Text(
            '${doubleFormat(loggedMacros[secondKey]!, kDecimalPlaces)} / ${doubleFormat(dailyMacros[secondKey]!, kDecimalPlaces)}',
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 28,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          macrosColumn(kCaloriesKey, kProteinKey),
          macrosColumn(kCarbsKey, kFatsKey),
        ],
      ),
    );
  }
}