import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CloseButtonWidget extends StatelessWidget {
  final String? buttonText;

  const CloseButtonWidget({super.key, this.buttonText});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: buttonText == null
          ? Text(AppLocalizations.of(context)!.buttonsClose)
          : Text(AppLocalizations.of(context)!.buttonsCancel),
    );
  }
}
