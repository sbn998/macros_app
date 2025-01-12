import 'package:flutter/material.dart';

class DetailsDialogTitle extends StatelessWidget {
  final String title;

  const DetailsDialogTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _textWidget(textTheme),
        const SizedBox(
          width: 30,
        ),
        IconButton(
          onPressed: () {
            // _setState(() {
            //   _isEditing = !_isEditing;
            // });
          },
          icon: const Icon(
            Icons.edit,
          ),
        ),
      ],
    );
  }

  Text _textWidget(TextTheme textTheme) {
    return Text(
      title,
      style: textTheme.titleLarge!.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
