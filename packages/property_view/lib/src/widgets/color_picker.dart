import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flex_color_picker_copy/flex_color_picker_copy.dart';

class ColorPickerBox extends StatelessWidget {
  ColorPickerBox({this.key, required this.color, required this.onChanged});
  final Key? key;
  final Color color;
  final void Function(int color) onChanged;
  @override
  Widget build(BuildContext context) {
    return ColorPicker(
      key: key,
      color: Color(color.value),
      onColorChanged: (Color color) => onChanged(color.value),
      pickersEnabled: {
        ColorPickerType.both: false,
        ColorPickerType.wheel: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
      },
      pickerTypeLabels: {
        ColorPickerType.bw: 'Black White',
        ColorPickerType.custom: 'My Colors'
      },
      customColorSwatchesAndNames: {
        ColorTools.createPrimarySwatch(Color(0xFF6200EE)): 'Guide Purple',
        ColorTools.createAccentSwatch(Color(0xFF03DAC6)): 'Guide Teal',
      },
      padding: const EdgeInsets.all(0),
      columnSpacing: 16,
      spacing: 6,
      runSpacing: 6,
      width: 36,
      height: 36,
      borderRadius: 10,
      wheelDiameter: 200,
      wheelWidth: 16,
      hasBorder: true,
      // includeIndex850: true,
      // showColorCode: true,
      // showColorName: true,
      // showColorValue: true,
      // showMaterialName: true,
    );
  }
}
