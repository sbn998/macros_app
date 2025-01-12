import 'package:flutter/material.dart';
import 'package:macros_app/models/food_model.dart';
import 'package:macros_app/models/logged_food_model.dart';

class FoodSelection extends StatefulWidget {
  final Food rowFood;
  final Function(LoggedFood) addOrRemoveSelectedFood;

  @override
  State<FoodSelection> createState() {
    return _FoodSelectionState();
  }

  const FoodSelection({
    super.key,
    required this.rowFood,
    required this.addOrRemoveSelectedFood,
  });
}

class _FoodSelectionState extends State<FoodSelection> {
  bool _isSelected = false;
  final TextEditingController _controller = TextEditingController();
  late LoggedFood _loggedFood;

  @override
  void initState() {
    _controller.text = widget.rowFood.servingQuantity.toString();
    _loggedFood = LoggedFood.fromFood(
      widget.rowFood,
      loggedQuantity: double.parse(_controller.text),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          setState(() {
            _isSelected = !_isSelected;
          });
          widget.addOrRemoveSelectedFood(_loggedFood);
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.rowFood.foodName,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 50.0,
                      child: TextField(
                        controller: _controller,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (value) {
                          widget.addOrRemoveSelectedFood(_loggedFood);
                          _loggedFood.loggedQuantity =
                              double.parse(_controller.text);
                          widget.addOrRemoveSelectedFood(_loggedFood);
                        },
                      ),
                    ),
                    Text(
                      '${widget.rowFood.serving}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 44,
                      child: _isSelected
                          ? const Align(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.check))
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
