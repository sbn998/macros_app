import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:macros_app/dialogs/food_screen/add_food_dialog.dart';
import 'package:macros_app/dialogs/food_screen/details_dialog.dart';
import 'package:macros_app/models/food_model.dart';
import 'package:macros_app/providers/saved_food_provider.dart';

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

  void _removeFood(Food removedFood) async {
    await ref.read(savedFoodProvider.notifier).removeSavedFood(removedFood.id);
  }

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

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isNewSection)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 18,
                              bottom: 6,
                              top: 6,
                            ),
                            child: Text(
                              currentLetter,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    showFoodDetailsDialog(
                                        context, foodList[index]);
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 7,
                                      ),
                                      child: Text(
                                        foodList[index].foodName,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _removeFood(foodList[index]);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
