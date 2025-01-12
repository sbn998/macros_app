import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:macros_app/providers/date_provider.dart';
import 'package:macros_app/widgets/buttons/close_button_widget.dart';

class CalendarButtonsRow extends ConsumerWidget {
  const CalendarButtonsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations translation = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            ref.read(selectedDateProvider.notifier).state = DateTime.now();
            ref.read(displayedMonthProvider.notifier).state = DateTime.now();
            Navigator.pop(context);
          },
          child: Text(translation.dateToday),
        ),
        const SizedBox(width: 10.0),
        const CloseButtonWidget(),
      ],
    );
  }
}
