import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:macros_app/models/user_meal_model.dart';
import 'package:macros_app/providers/user_meals_provider.dart';

// TODO: Add a Snackbar to undo the action of deleting a user meal.

class UserMealsListView extends ConsumerStatefulWidget {
  const UserMealsListView({super.key});

  @override
  ConsumerState<UserMealsListView> createState() {
    return _UserMealsListViewState();
  }
}

class _UserMealsListViewState extends ConsumerState<UserMealsListView> {
  late List<TextEditingController> _controllers;
  final ScrollController _scrollController = ScrollController();

  void _initializeLists() {
    final userMealsList = ref.read(userMealsProvider);
    setState(() {
      _controllers = List.generate(userMealsList.length, (index) {
        return TextEditingController(text: userMealsList[index].mealName);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeLists();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userMealsList = ref.watch(userMealsProvider);
    final translations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (_controllers.length != userMealsList.length) {
      _controllers = List.generate(userMealsList.length, (index) {
        return TextEditingController(text: userMealsList[index].mealName);
      });
    }

    Widget userMealTextField(int index) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: translations.enterMealName,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: theme.primaryColor,
                ),
              ),
            ),
            controller: _controllers[index],
            onChanged: (value) {
              userMealsList[index].mealName = value;
              ref
                  .read(userMealsProvider.notifier)
                  .updateUserMeal(userMealsList[index]);
            },
          ),
        ),
      );
    }

    Widget addUserMealButton() {
      return TextButton(
        onPressed: null,
        child: InkWell(
          onTap: () {
            ref
                .read(userMealsProvider.notifier)
                .addUserMeal(UserMeal(mealName: ''));
            setState(() {
              _controllers.add(TextEditingController(text: ''));
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                translations.addMeal,
                style:
                    TextStyle(fontSize: 15.0, color: theme.colorScheme.primary),
              ),
              Icon(Icons.add, color: theme.colorScheme.primary),
            ],
          ),
        ),
      );
    }

    Widget mealsList() {
      return Expanded(
        child: ListView(
          children: [
            Scrollbar(
              thumbVisibility: true,
              controller: _scrollController,
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: userMealsList.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(child: userMealTextField(index)),
                      IconButton(
                        onPressed: () {
                          ref
                              .read(userMealsProvider.notifier)
                              .removeUserMeal(userMealsList[index]);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        mealsList(),
        const SizedBox(height: 14.0),
        addUserMealButton(),
      ],
    );
  }
}
