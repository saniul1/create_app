import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberFieldProperty extends StatelessWidget {
  NumberFieldProperty({
    Key? key,
    this.label,
    this.isDouble = true,
    required this.value,
    required this.onChanged,
  }) : super(key: key);
  final String? label;
  final num value;
  final Function(num) onChanged;
  final bool isDouble;
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: label,
        labelText: label,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      controller: TextEditingController(text: value.toString()),
      onSubmitted: (value) {
        if (isDouble)
          onChanged(double.tryParse(value) ?? 0);
        else
          onChanged(int.tryParse(value) ?? 0);
      },
      onChanged: (value) {
        // onChanged(value);
      },
    );
  }
}
