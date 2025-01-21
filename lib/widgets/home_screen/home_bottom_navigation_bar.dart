import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreenBottomNavigationBar extends StatelessWidget {
  final Function(int) onTap;
  final int selectedScreenIndex;

  const HomeScreenBottomNavigationBar({
    super.key,
    required this.onTap,
    required this.selectedScreenIndex,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translations = AppLocalizations.of(context)!;

    return BottomNavigationBar(
      onTap: onTap,
      currentIndex: selectedScreenIndex,
      items: [
        BottomNavigationBarItem(
            icon: const Icon(Icons.food_bank),
            label: translations.labelsYourFood),
        BottomNavigationBarItem(
            icon: const Icon(Icons.note_add), label: translations.labelsMeals),
        BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: translations.labelsSettings),
      ],
    );
  }
}
