import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:macros_app/functions/validators/validators.dart';

import 'package:macros_app/models/food_model.dart';
import 'package:macros_app/widgets/buttons/close_button_widget.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
String _foodName = '';
double _calories = 0.0;
double _protein = 0.0;
double _carbs = 0.0;
double _fats = 0.0;
String _serving = '';
double _servingQuantity = 100.0;
late Function(Food)
    _callbackFunction; // Function to add food to the list and the db.

void showAddFoodDialog(BuildContext context, Function(Food) callbackFunction) {
  _callbackFunction = callbackFunction;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _buildStatefulBuilder(context),
      );
    },
  );
}

StatefulBuilder _buildStatefulBuilder(BuildContext context) {
  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.addFood,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildForm(_formKey),
            ),
            _buildStatefulBuilderRow(context),
          ],
        ),
      );
    },
  );
}

Widget _buildStatefulBuilderRow(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      const CloseButtonWidget(),
      TextButton(
        onPressed: () {
          _saveFood(context);
        },
        child: Text(AppLocalizations.of(context)!.buttonsConfirm),
      ),
    ],
  );
}

Widget _buildForm(GlobalKey<FormState> formKey) {
  return Form(
    key: formKey,
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFoodNameFormTextField(),
          _buildCaloriesFormTextField(),
          _buildDynamicFormTextField(
            AppLocalizations.of(_context)!.protein,
            _protein,
            (newValue) => _protein = newValue,
          ),
          _buildDynamicFormTextField(
            AppLocalizations.of(_context)!.carbs,
            _carbs,
            (newValue) => _carbs = newValue,
          ),
          _buildDynamicFormTextField(
            AppLocalizations.of(_context)!.fats,
            _fats,
            (newValue) => _fats = newValue,
          ),
          _buildServingNameFormTextField(),
          _buildDynamicFormTextField(
            AppLocalizations.of(_context)!.servingQuantity,
            _servingQuantity,
            (newValue) => _servingQuantity = newValue,
          ),
        ],
      ),
    ),
  );
}

Widget _buildFoodNameFormTextField() {
  return TextFormField(
    maxLength: 20,
    decoration: InputDecoration(
      label: Text(AppLocalizations.of(_context)!.foodName),
    ),
    validator: (value) {
      return validateNameString(_context, value!);
    },
    onSaved: (textFormFieldFoodName) {
      _foodName = textFormFieldFoodName!;
    },
  );
}

//TODO: Maybe remove this method and use the dynamic one instead.
Widget _buildCaloriesFormTextField() {
  return TextFormField(
    maxLength: 20,
    decoration: InputDecoration(
      label: Text(AppLocalizations.of(_context)!.calories),
    ),
    validator: (value) {
      return validateDoubleValue(_context, value!);
    },
    onSaved: (textFormFieldCalories) {
      // TODO: Fix this and add a way for the calories to be autocalculated based on macros if the user doesn't
      // input a value.
      if (textFormFieldCalories != null && textFormFieldCalories.isNotEmpty) {
        _calories = double.parse(textFormFieldCalories);
      }
    },
  );
}

Widget _buildDynamicFormTextField(
  String macro,
  double macroPrivateVariable,
  ValueSetter<double> onSavedCallback,
) {
  return TextFormField(
      maxLength: 20,
      decoration: InputDecoration(
        label: Text(macro),
      ),
      validator: (value) {
        return validateDoubleValue(_context, value!);
      },
      onSaved: (textFormFieldValue) {
        if (textFormFieldValue != null && textFormFieldValue.isNotEmpty) {
          onSavedCallback(double.parse(textFormFieldValue));
        }
      });
}

//TODO: if dynamic works, remove commented methods from file.

// Widget _buildCarbsFormTextField() {
//   return TextFormField(
//     maxLength: 20,
//     decoration: const InputDecoration(
//       label: Text('Carbohydrates'),
//     ),
//     validator: (value) {
//       return _validateMacrosForm(value!);
//     },
//     onSaved: (textFormFieldCarbs) {
//       if (textFormFieldCarbs != null && textFormFieldCarbs.isNotEmpty) {
//         _carbs = double.parse(textFormFieldCarbs);
//       }
//     },
//   );
// }
//
// Widget _buildFatsFormTextField() {
//   return TextFormField(
//     maxLength: 20,
//     decoration: const InputDecoration(
//       label: Text('Fats'),
//     ),
//     validator: (value) {
//       return _validateMacrosForm(value!);
//     },
//     onSaved: (textFormFieldFats) {
//       if (textFormFieldFats != null && textFormFieldFats.isNotEmpty) {
//         _fats = double.parse(textFormFieldFats);
//       }
//     },
//   );
// }

Widget _buildServingNameFormTextField() {
  return TextFormField(
    maxLength: 20,
    decoration: InputDecoration(
      label: Text(AppLocalizations.of(_context)!.servingName),
    ),
    validator: (value) {
      return value == null || value.isEmpty
          ? AppLocalizations.of(_context)!.nullServingName
          : null;
    },
    onSaved: (textFormFieldServingName) {
      _serving = textFormFieldServingName!;
    },
  );
}

// Widget _buildServingQuantityFormTextField() {
//   return TextFormField(
//     maxLength: 20,
//     decoration: const InputDecoration(
//       label: Text('Serving quantity'),
//     ),
//     validator: (value) {
//       return _validateMacrosForm(value!);
//     },
//     onSaved: (textFormFieldServingQuantity) {
//       if (textFormFieldServingQuantity != null &&
//           textFormFieldServingQuantity.isNotEmpty) {
//         _servingQuantity = double.parse(textFormFieldServingQuantity);
//       }
//     },
//   );
// }
void _saveFood(BuildContext context) {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    Food newFood = Food(
      foodName: _foodName,
      calories: _calories,
      protein: _protein,
      carbs: _carbs,
      fats: _fats,
      serving: _serving,
      servingQuantity: _servingQuantity,
    );
    _callbackFunction(newFood);
    Navigator.of(context).pop();
  }
}
