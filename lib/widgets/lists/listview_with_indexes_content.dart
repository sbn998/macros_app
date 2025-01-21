import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macros_app/dialogs/food_screen/details_dialog.dart';
import 'package:macros_app/models/food_model.dart';
import 'package:macros_app/providers/saved_food_provider.dart';

class ListviewWithIndexesContent extends StatelessWidget {
  final bool isNewSection;
  final String currentLetter;
  final Food food;

  const ListviewWithIndexesContent({
    super.key,
    required this.isNewSection,
    required this.currentLetter,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                    showFoodDetailsDialog(context, food);
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 7,
                      ),
                      child: Text(
                        food.foodName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              Consumer(
                builder: (context, ref, _) {
                  return IconButton(
                    onPressed: () async {
                      await ref
                          .read(savedFoodProvider.notifier)
                          .removeSavedFood(food.id);
                    },
                    icon: const Icon(
                      Icons.delete,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
