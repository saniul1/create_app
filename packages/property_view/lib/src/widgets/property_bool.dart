import 'package:flutter/material.dart';

class PropertyBoolWidget extends StatelessWidget {
  const PropertyBoolWidget({
    Key key,
    @required this.valueKey,
    @required this.label,
    @required this.value,
    @required this.onChanged,
  }) : super(key: key);
  final String valueKey;
  final String label;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (_) {
            onChanged(!value);
          },
        ),
        Text(label ?? valueKey)
      ],
    );
  }
}
