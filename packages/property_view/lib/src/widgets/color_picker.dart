import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flex_color_picker_copy/flex_color_picker_copy.dart';

class ColorPickerBox extends StatelessWidget {
  ColorPickerBox({required this.color, required this.onChanged});
  final Color color;
  final void Function(int color) onChanged;
  @override
  Widget build(BuildContext context) {
    return ColorPicker(
      key: UniqueKey(),
      color: Color(color.value),
      onColorChanged: (Color color) => onChanged(color.value),
      pickersEnabled: {
        ColorPickerType.both: false,
        ColorPickerType.wheel: true
      },
      pickerTypeLabels: {},
    );
  }
}
