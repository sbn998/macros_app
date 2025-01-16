import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:macros_app/models/logged_food_model.dart';
import 'package:macros_app/models/logged_meal_model.dart';
import 'package:macros_app/models/user_meal_model.dart';
import 'package:macros_app/providers/date_provider.dart';
import 'package:macros_app/providers/logged_meals_provider.dart';
import 'package:macros_app/widgets/buttons/close_button_widget.dart';
import 'package:macros_app/widgets/buttons/confirm_button_widget.dart';
import 'package:macros_app/widgets/lists/log_food_list.dart';
import 'package:macros_app/widgets/logging_screen/meal_selector.dart';

class LoggingDialog extends ConsumerStatefulWidget {
  final UserMeal? selectedUserMeal;
  final LoggedMeal? selectedLoggedMeal;

  const LoggingDialog({
    super.key,
    required this.selectedUserMeal,
    required this.selectedLoggedMeal,
  });

  @override
  ConsumerState<LoggingDialog> createState() {
    return _LoggingDialogState();
  }
}

class _LoggingDialogState extends ConsumerState<LoggingDialog> {
  late bool _isMealSelected;
  late final List<LoggedFood> _selectedFood;
  late UserMeal _selectedUserMeal;
  late LoggedMeal _selectedLoggedMeal;

  @override
  void initState() {
    super.initState();
    final bool isMealSelected =
        widget.selectedUserMeal != null || widget.selectedLoggedMeal != null;
    final bool isLoggedMealSelected = widget.selectedLoggedMeal != null;

    _isMealSelected = isMealSelected;
    _selectedFood = [];
    _selectedUserMeal = widget.selectedUserMeal ?? UserMeal.empty();
    if (isLoggedMealSelected) {
      _selectedLoggedMeal = widget.selectedLoggedMeal!;
    }
  }

  void _insertLoggedMeal() async {
    if (!context.mounted) {
      return;
    }

    final DateTime date = ref.read(selectedDateProvider.notifier).state;

    if (_selectedUserMeal.id != '' && widget.selectedLoggedMeal == null) {
      final LoggedMeal meal = LoggedMeal(
        loggedUserMeal: _selectedUserMeal,
        loggedFood: _selectedFood,
      );

      await ref
          .read(loggedMealsProvider(date).notifier)
          .addLoggedMeal(date, meal);
    }
    if (widget.selectedLoggedMeal != null) {
      _selectedLoggedMeal.loggedFood = [
        ..._selectedLoggedMeal.loggedFood,
        ..._selectedFood,
      ];
      await ref
          .read(loggedMealsProvider(date).notifier)
          .updateLoggedMeal(date, _selectedLoggedMeal);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translations = AppLocalizations.of(context)!;

    return AlertDialog(
      title: _isMealSelected
          ? Text(translations.selectFood, textAlign: TextAlign.center)
          : Text(translations.selectMeal, textAlign: TextAlign.center),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
          width: double.maxFinite,
          child: _isMealSelected
              ? LogFoodList(loggedFood: _selectedFood)
              : MealSelector(onTapMeal: (userMeal) {
                  setState(() {
                    _selectedUserMeal = userMeal;
                    _isMealSelected = !_isMealSelected;
                  });
                }),
        ),
      ),
      actionsPadding: const EdgeInsets.only(
        bottom: 15.0,
        right: 25.0,
      ),
      actions: [
        const CloseButtonWidget(),
        if (_isMealSelected)
          Consumer(
            builder: (context, ref, _) {
              return ConfirmButtonWidget(
                callback: () {
                  _insertLoggedMeal();
                },
              );
            },
          )
      ],
    );
  }
}
