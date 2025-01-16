import 'package:flutter/material.dart';

import 'package:macros_app/functions/macros_summary.dart';
import 'package:macros_app/models/logged_food_model.dart';
import 'package:macros_app/widgets/meals/logged_quantity_text_field.dart';

class DismissibleLoggedFood extends StatelessWidget {
  final LoggedFood loggedFood;
  final Function(LoggedFood) onDismmissedCallback;
  final Function(LoggedFood) onUpdateTextFieldCallback;

  const DismissibleLoggedFood({
    super.key,
    required this.loggedFood,
    required this.onDismmissedCallback,
    required this.onUpdateTextFieldCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(loggedFood),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        onDismmissedCallback(loggedFood);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loggedFood.foodName,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  getMacrosOnly(loggedFood),
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(145)),
                ),
              ],
            ),
            LoggedQuantityTextField(
              loggedFood: loggedFood,
              onUpdateTextFieldCallback: onUpdateTextFieldCallback,
            ),
          ],
        ),
      ),
    );
  }
}
