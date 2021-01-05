import 'package:flutter/material.dart';

/// This is the private State class that goes with MyStatefulWidget.
class SelectOptionsProperty extends StatelessWidget {
  SelectOptionsProperty({
    required this.values,
    required this.value,
    required this.onChanged,
  });
  final List<String> values;
  final String value;
  final Function(String) onChanged;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        if (newValue != null) onChanged(newValue);
      },
      items: values.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
