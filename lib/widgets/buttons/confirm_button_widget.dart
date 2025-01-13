import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmButtonWidget extends StatelessWidget {
  final Function() callback;

  const ConfirmButtonWidget({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translations = AppLocalizations.of(context)!;

    return ElevatedButton(
      onPressed: () {
        callback();
      },
      child: Text(translations.buttonsConfirm),
    );
  }
}
