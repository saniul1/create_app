import 'package:flutter/material.dart';

/// This is the private State class that goes with MyStatefulWidget.
class SelectOptionsProperty extends StatelessWidget {
  SelectOptionsProperty({
    required this.values,
    this.valueIcons = const {},
    required this.value,
    required this.onChanged,
  });
  final List<String> values;
  final Map<String, IconData> valueIcons;
  final String value;
  final Function(String) onChanged;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isExpanded: true,
      value: value,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.blue,
      ),
      onChanged: (String? newValue) {
        if (newValue != null) onChanged(newValue);
      },
      items: values.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Row(
            children: [
              if (valueIcons.containsKey(value))
                Padding(
                  padding: const EdgeInsets.only(right: 6.0, top: 5),
                  child: Icon(
                    valueIcons[value],
                    size: 16,
                  ),
                ),
              Text(value),
            ],
          ),
        );
      }).toList(),
    );
  }
}
