import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macros_app/dialogs/food_screen/add_food_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:macros_app/models/food_model.dart';
import 'package:macros_app/providers/saved_food_provider.dart';
import 'package:macros_app/widgets/lists/listview_with_indexes.dart';

// TODO: Implement filters.

class FoodScreen extends ConsumerWidget {
  const FoodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodList = ref.watch(savedFoodProvider);

    if (foodList.isNotEmpty) {
      return const ListviewWithIndexes();
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.foodScreen,
          ),
          TextButton(
            onPressed: () {
              showAddFoodDialog(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.buttonsStartAddingFood),
                const Icon(Icons.add),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
