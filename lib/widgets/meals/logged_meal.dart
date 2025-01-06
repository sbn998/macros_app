import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macros_app/dialogs/logging_food/add_food_to_meal_dialog.dart';

import 'package:macros_app/models/logged_food_model.dart';
import 'package:macros_app/models/logged_meal_model.dart';
import 'package:macros_app/providers/date_provider.dart';
import 'package:macros_app/providers/logged_meal_list_provider.dart';
import 'package:macros_app/providers/logged_meals_provider.dart';
import 'package:macros_app/functions/macros_strings.dart';

class LoggedMealWidget extends ConsumerStatefulWidget {
  final LoggedMeal loggedMeal;

  const LoggedMealWidget({
    super.key,
    required this.loggedMeal,
  });

  @override
  ConsumerState<LoggedMealWidget> createState() => _LoggedMealWidgetState();
}

class _LoggedMealWidgetState extends ConsumerState<LoggedMealWidget> {
  final Map<String, TextEditingController> _quantityControllers = {};
  final Map<String, FocusNode> _focusNodes = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _quantityControllers.forEach((key, value) => value.dispose());
    _quantityControllers.clear();
    _focusNodes.forEach((key, value) => value.dispose());
    _focusNodes.clear();
    super.dispose();
  }

  void _initializeControllers() {
    final loggedMeal = ref.read(loggedMealProviderFamily(widget.loggedMeal));

    for (var food in loggedMeal.loggedFood) {
      _quantityControllers[food.id] = TextEditingController(
        text: food.loggedQuantity.toString(),
      );
      _focusNodes[food.id] = FocusNode()
        ..addListener(() {
          if (!_focusNodes[food.id]!.hasFocus) {
            setState(() {
              food.loggedQuantity =
                  double.tryParse(_quantityControllers[food.id]!.text) ?? 0.0;
            });
            final selectedDate = ref.read(selectedDateProvider.notifier).state;
            ref
                .read(loggedMealsProvider(selectedDate).notifier)
                .updateLoggedMeal(selectedDate, loggedMeal);
          }
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loggedMeal = ref.watch(loggedMealProviderFamily(widget.loggedMeal));
    final macros = ref.watch(loggedMealMacrosProvider(loggedMeal));

    if (loggedMeal.loggedUserMeal.mealName.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        child: Card(
          child: _buildCardContent(
            loggedMeal.loggedUserMeal.mealName,
            loggedMeal.loggedFood,
            macros,
          ),
        ),
      );
    } else {
      return const Center();
    }
  }

  Widget _buildCardContent(
    String mealTitle,
    List<LoggedFood> loggedFoodList,
    Map<String, double> macros,
  ) {
    return Column(
      children: [
        _buildTitleRow(mealTitle),
        const Divider(
          height: 1,
          indent: 80,
          endIndent: 80,
        ),
        const Padding(padding: EdgeInsets.only(bottom: 12)),
        for (var food in loggedFoodList)
          _buildMealBodyRow(widget.loggedMeal, food),
        const Divider(
          height: 1,
          indent: 80,
          endIndent: 80,
        ),
        _buildMealMacrosRow(macros),
      ],
    );
  }

  Widget _buildTitleRow(String mealName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Needed to center the text. Has to match the size of the IconButton.
        const SizedBox(width: 48),
        Expanded(
          child: Text(
            mealName,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          onPressed: () {
            final LoggedMeal meal =
                ref.read(loggedMealProviderFamily(widget.loggedMeal));
            showAddFoodToMealDialog(context, ref, meal);
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildMealBodyRow(LoggedMeal meal, LoggedFood food) {
    TextEditingController? controller;
    FocusNode? focusNode;

    if (!_quantityControllers.containsKey(food.id)) {
      _quantityControllers[food.id] = TextEditingController(
        text: food.loggedQuantity.toString(),
      );
    }
    if (!_focusNodes.containsKey(food.id)) {
      _focusNodes[food.id] = FocusNode()
        ..addListener(() {
          if (!_focusNodes[food.id]!.hasFocus) {
            setState(() {
              food.loggedQuantity =
                  double.tryParse(_quantityControllers[food.id]!.text) ?? 0.0;
            });
            final selectedDate = ref.read(selectedDateProvider.notifier).state;
            ref
                .read(loggedMealsProvider(selectedDate).notifier)
                .updateLoggedMeal(selectedDate, widget.loggedMeal);
          }
        });
    }
    controller = _quantityControllers[food.id]!;
    focusNode = _focusNodes[food.id]!;

    return LongPressDraggable<LoggedFood>(
      data: food,
      feedback: Material(
        color: Colors.transparent,
        child: Card(
          elevation: 4,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    food.foodName,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    '${food.protein! * food.loggedQuantity / food.servingQuantity!}P  ${food.carbs! * food.loggedQuantity / food.servingQuantity!}C  ${food.fats! * food.loggedQuantity / food.servingQuantity!}F',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.0,
        child: Container(),
      ),
      onDragCompleted: () {
        final loggedMeal =
            ref.read(loggedMealProviderFamily(widget.loggedMeal));
        _quantityControllers.remove(food.foodName)?.dispose();
        _focusNodes.remove(food.foodName)?.dispose();
        loggedMeal.loggedFood.remove(food);
      },
      child: InkWell(
        child: Dismissible(
          key: ValueKey(food),
          direction: DismissDirection.horizontal,
          onDismissed: (direction) {
            final loggedMeal =
                ref.read(loggedMealProviderFamily(widget.loggedMeal));
            final selectedDate = ref.read(selectedDateProvider.notifier).state;

            ref
                .read(loggedMealsProvider(selectedDate).notifier)
                .updateLoggedMeal(selectedDate, widget.loggedMeal);
            _quantityControllers.remove(food.foodName)?.dispose();
            _focusNodes.remove(food.foodName)?.dispose();
            loggedMeal.loggedFood.remove(food);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.foodName,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '${food.protein! * food.loggedQuantity / food.servingQuantity!}P  ${food.carbs! * food.loggedQuantity / food.servingQuantity!}C  ${food.fats! * food.loggedQuantity / food.servingQuantity!}F',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Colors.white54,
                          ),
                    ),
                    const SizedBox(
                      height: 22.0,
                    ),
                  ],
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    FocusScope.of(context).requestFocus(focusNode);
                  },
                  child: SizedBox(
                    height: 50.0,
                    width: 90.0,
                    child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          hintText: '${food.loggedQuantity}',
                          suffixText: '${food.serving}',
                          suffixStyle:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontSize: 13,
                                  ),
                          alignLabelWithHint: true,
                        ),
                        onEditingComplete: () {
                          setState(() {
                            food.loggedQuantity =
                                double.tryParse(controller!.text) ?? 0.0;
                          });
                          final selectedDate =
                              ref.read(selectedDateProvider.notifier).state;
                          ref
                              .read(loggedMealsProvider(selectedDate).notifier)
                              .updateLoggedMeal(
                                  selectedDate, widget.loggedMeal);
                          focusNode!.unfocus();
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealMacrosRow(Map<String, double> totalMacros) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Total:       ',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            getMacrosStringFromMap(totalMacros),
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}
