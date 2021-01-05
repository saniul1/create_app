import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IntFieldProperty extends StatelessWidget {
  IntFieldProperty({
    Key? key,
    this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);
  final String? label;
  final int value;
  final Function(int) onChanged;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
          labelText: label,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: TextEditingController(text: value.toString()),
        onSubmitted: (value) {
          onChanged(int.tryParse(value) ?? 0);
        },
        onChanged: (value) {
          // onChanged(value);
        },
      ),
    );
  }
}
