import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:macros_app/dialogs/food_screen/add_food_dialog.dart';
import 'package:macros_app/models/food_model.dart';
import 'package:macros_app/providers/saved_food_provider.dart';
import 'package:macros_app/widgets/lists/listview_with_indexes_content.dart';

class ListviewWithIndexes extends ConsumerStatefulWidget {
  const ListviewWithIndexes({
    super.key,
  });

  @override
  ConsumerState<ListviewWithIndexes> createState() =>
      _ListviewWithIndexesState();
}

class _ListviewWithIndexesState extends ConsumerState<ListviewWithIndexes> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Food> foodList = ref.watch(savedFoodProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ListView(
            children: [
              Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: foodList.length,
                  itemBuilder: (context, index) {
                    String currentLetter =
                        foodList[index].foodName[0].toUpperCase();
                    String? previousLetter;
                    if (index > 0) {
                      previousLetter =
                          foodList[index - 1].foodName[0].toUpperCase();
                    }

                    bool isNewSection = previousLetter != currentLetter;

                    return ListviewWithIndexesContent(
                      isNewSection: isNewSection,
                      currentLetter: currentLetter,
                      food: foodList[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            showAddFoodDialog(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context)!.buttonsAddFoodExclamation),
              const Icon(Icons.add),
            ],
          ),
        ),
      ],
    );
  }
}
