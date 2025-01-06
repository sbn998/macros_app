import 'package:flutter/material.dart';
import 'package:macros_app/models/user_meal_model.dart';

// TODO: Add a Snackbar to undo the action of deleting a user meal.

class UserMealsListView extends StatefulWidget {
  final Function(List<UserMeal>) onChangedMeals;
  final List<UserMeal> userMeals;

  @override
  State<StatefulWidget> createState() {
    return _UserMealsListViewState();
  }

  const UserMealsListView({
    super.key,
    required this.onChangedMeals,
    required this.userMeals,
  });
}

class _UserMealsListViewState extends State<UserMealsListView> {
  late List<UserMeal> _userMeals;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _userMeals = List.from(widget.userMeals);
    _controllers = List.generate(_userMeals.length, (index) {
      return TextEditingController(text: _userMeals[index].mealName);
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addNewUserMeal() {
    setState(() {
      _userMeals.add(
        UserMeal(mealName: ''),
      );
      _controllers.add(
        TextEditingController(text: ''),
      );
    });
  }

  void _removeUserMeal(int index) {
    setState(() {
      _controllers.removeAt(index);
      _userMeals.removeAt(index);
    });
    widget.onChangedMeals(_userMeals);
  }

  Widget _buildUserMealList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _userMeals.length,
      itemBuilder: (context, index) {
        return _buildUserMealRow(index);
      },
    );
  }

  Widget _buildUserMealRow(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Flexible(
            child: _buildUserMealTextField(index),
          ),
          IconButton(
            onPressed: () {
              _removeUserMeal(index);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  Widget _buildUserMealTextField(int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Enter a meal name',
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          controller: _controllers[index],
          onChanged: (value) {
            _userMeals[index].mealName = value;
            widget.onChangedMeals(_userMeals);
          },
        ),
      ),
    );
  }

  Widget _buildNewUserMealRow() {
    return TextButton(
      onPressed: null,
      child: GestureDetector(
        onTap: _addNewUserMeal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Add a meal',
              style: TextStyle(
                  fontSize: 15.0, color: Theme.of(context).colorScheme.primary),
            ),
            Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildUserMealList(),
        const SizedBox(
          height: 14.0,
        ),
        _buildNewUserMealRow(),
      ],
    );
  }
}
