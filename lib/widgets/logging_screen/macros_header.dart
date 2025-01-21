import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:macros_app/providers/calculated_macros_provider.dart';
import 'package:macros_app/providers/daily_macro_goals_provider.dart';
import 'package:macros_app/providers/date_provider.dart';
import 'package:macros_app/widgets/logging_screen/macros_eaten_overview.dart';
import 'package:macros_app/widgets/logging_screen/no_macro_goal_widget.dart';

class MacrosHeader extends ConsumerStatefulWidget {
  const MacrosHeader({super.key});

  @override
  ConsumerState<MacrosHeader> createState() {
    return _MacrosHeaderState();
  }
}

class _MacrosHeaderState extends ConsumerState<MacrosHeader> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translations = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final DateTime dateToFetch = ref.watch(selectedDateProvider);
    final dailyMacros =
        ref.watch(fetchedDailyMacrosProvider(dateToFetch.weekday));
    final Map<String, double> calculatedMacros =
        ref.watch(calculatedMacrosProvider);

    final Color selectedPageIndicatorColor = theme.colorScheme.primary;
    final Color unselectedPageIndicatorColor =
        theme.colorScheme.secondaryContainer;

    return dailyMacros.when(
      data: (dailyMacros) {
        if (dailyMacros.isNotEmpty) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 195.0,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    MacrosEatenOverview(
                        isLeft: true,
                        dailyMacros: dailyMacros,
                        loggedMacros: calculatedMacros),
                    MacrosEatenOverview(
                        isLeft: false,
                        dailyMacros: dailyMacros,
                        loggedMacros: calculatedMacros),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    height: 5.0,
                    width: 5.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? selectedPageIndicatorColor
                          : unselectedPageIndicatorColor,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 15.0),
            ],
          );
        } else {
          return EmptyDailyMacroGoal(
            date: ref.read(selectedDateProvider.notifier).state,
          );
        }
      },
      loading: () {
        return const CircularProgressIndicator();
      },
      error: (error, stack) {
        return Text('${translations.error}: $error');
      },
    );
  }
}
