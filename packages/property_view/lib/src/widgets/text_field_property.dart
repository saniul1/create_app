import 'package:flutter/material.dart';

class TextFieldProperty extends StatelessWidget {
  TextFieldProperty({
    Key? key,
    this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);
  final String? label;
  final String value;
  final Function(String) onChanged;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
          labelText: label,
        ),
        controller: TextEditingController(text: value),
        onSubmitted: (value) {
          onChanged(value);
        },
        onChanged: (value) {
          // onChanged(value);
        },
      ),
    );
  }
}
