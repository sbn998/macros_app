import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macros_app/dialogs/show_calendar.dart';

import 'package:macros_app/functions/format_date.dart';
import 'package:macros_app/providers/date_provider.dart';

class HomeScreenAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final int screenIndex;

  const HomeScreenAppBar({
    super.key,
    required this.screenIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations translations = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final DateTime selectedDate = ref.watch(selectedDateProvider);
    final Map<int, String> screenTitlesMap = {
      0: translations.screensYourFood,
      1: formatDate(selectedDate, context),
      2: translations.screensSettings,
    };

    return AppBar(
      title: Text(
        screenTitlesMap[screenIndex]!,
        style: theme.textTheme.titleLarge,
      ),
      centerTitle: true,
      actions: [
        if (screenIndex == 1)
          IconButton(
            onPressed: () {
              showCalendar(context);
            },
            icon: const Icon(Icons.calendar_month),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
