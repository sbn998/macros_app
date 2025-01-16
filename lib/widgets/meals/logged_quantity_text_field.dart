import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:macros_app/models/logged_food_model.dart';

class LoggedQuantityTextField extends ConsumerStatefulWidget {
  final LoggedFood loggedFood;
  final Function(LoggedFood) onUpdateTextFieldCallback;

  const LoggedQuantityTextField({
    super.key,
    required this.loggedFood,
    required this.onUpdateTextFieldCallback,
  });

  @override
  ConsumerState<LoggedQuantityTextField> createState() {
    return _LoggedQuantityTextFieldState();
  }
}

class _LoggedQuantityTextFieldState
    extends ConsumerState<LoggedQuantityTextField> {
  late TextEditingController _quantityController;

  void _initializeController() {
    _quantityController = TextEditingController(
        text: widget.loggedFood.loggedQuantity.toString());
  }

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      width: 90.0,
      child: TextField(
        controller: _quantityController,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          hintText: '${widget.loggedFood.loggedQuantity}',
          suffixText: '${widget.loggedFood.serving}',
          suffixStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontSize: 13,
              ),
          alignLabelWithHint: true,
        ),
        onEditingComplete: () {
          setState(() {
            widget.loggedFood.loggedQuantity =
                double.tryParse(_quantityController.text) ?? 0.0;
          });
          widget.onUpdateTextFieldCallback(widget.loggedFood);
        },
        //TODO: Fix this and make it update the value whenever the user taps outside the textfield.

        // onTapOutside: (event) {
        //   setState(() {
        //     widget.loggedFood.loggedQuantity =
        //         double.tryParse(_quantityController.text) ?? 0.0;
        //   });
        //   widget.onUpdateTextFieldCallback(widget.loggedFood);
        // },
      ),
    );
  }
}
