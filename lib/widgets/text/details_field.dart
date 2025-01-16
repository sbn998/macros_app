import 'package:flutter/material.dart';

class DetailsField extends StatelessWidget {
  final String fieldName;
  final String fieldValue;

  const DetailsField({
    super.key,
    required this.fieldName,
    required this.fieldValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textName(),
          textValue(),
        ],
      ),
    );
  }

  Text textName() {
    return Text(
      '$fieldName:',
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text textValue() {
    return Text(
      fieldValue,
      style: const TextStyle(
        fontSize: 18,
      ),
    );
  }
}
