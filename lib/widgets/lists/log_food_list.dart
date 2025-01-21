import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macros_app/functions/update_logged_food_list.dart';

import 'package:macros_app/models/food_model.dart';
import 'package:macros_app/models/logged_food_model.dart';
import 'package:macros_app/providers/saved_food_provider.dart';
import 'package:macros_app/widgets/food_screen/add_food/food_selection.dart';

class LogFoodList extends ConsumerStatefulWidget {
  final List<LoggedFood> loggedFood;

  const LogFoodList({
    super.key,
    required this.loggedFood,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _LogFoodListState();
  }
}

class _LogFoodListState extends ConsumerState<LogFoodList> {
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

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isNewSection)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 4,
                              top: 4,
                            ),
                            child: Text(
                              currentLetter,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ),
                        FoodSelection(
                          rowFood: foodList[index],
                          addOrRemoveSelectedFood: (loggedFood) {
                            updateLoggedFoodlist(
                              widget.loggedFood,
                              loggedFood,
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
