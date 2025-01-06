import 'dart:async';

import 'package:flutter/material.dart';
import 'package:macros_app/databases/food_db.dart';
import 'package:macros_app/dialogs/food_screen/add_food_dialog.dart';
import 'package:macros_app/dialogs/food_screen/details_dialog.dart';

import 'package:macros_app/models/food_model.dart';

// TODO: Style how the food is shown. Maybe completely ditch the card and use a standard row with some styling.
// Implement a ListView to show the cards inside of it.
// Implement an inkwell on the row to open a modal showing the details of the food. The user may edit values in that modal.
// Implement a way to remove food from the list (has to be reflected on the database).
// Implement filters.

class FoodScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FoodScreenState();
  }

  const FoodScreen({super.key});
}

class _FoodScreenState extends State<FoodScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Food> _foodList = [];

  Future<void> _loadSavedFood() async {
    final fetchedSavedFood = await getSavedFood();

    setState(() {
      _foodList = fetchedSavedFood;
    });
  }

  List<Food> _sortFoodList(List<Food> listToSort) {
    listToSort.sort((a, b) => a.foodName.compareTo(b.foodName));
    return listToSort;
  }

  void _addFood(Food newFood) async {
    await insertSavedFood(newFood);
    setState(() {
      _foodList.add(newFood);
      _sortFoodList(_foodList);
    });
  }

  void _removeFood(Food removedFood) async {
    await deleteSavedFood(removedFood.id);
    setState(() {
      _foodList.remove(removedFood);
      _sortFoodList(_foodList);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSavedFood();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_foodList.isNotEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.81,
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: _foodList.length,
                itemBuilder: (context, index) {
                  String currentLetter =
                      _foodList[index].foodName[0].toUpperCase();
                  String? previousLetter;
                  if (index > 0) {
                    previousLetter =
                        _foodList[index - 1].foodName[0].toUpperCase();
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
                                      context, _foodList[index]);
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 7,
                                    ),
                                    child: Text(
                                      _foodList[index].foodName,
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
                                _removeFood(_foodList[index]);
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
          ),
          TextButton(
            onPressed: () {
              showAddFoodDialog(context, _addFood);
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Add food!'),
                Icon(Icons.add),
              ],
            ),
          ),
        ],
      );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'This is the Food screen',
          ),
          TextButton(
            onPressed: () {
              showAddFoodDialog(context, _addFood);
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Start adding food!'),
                Icon(Icons.add),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
