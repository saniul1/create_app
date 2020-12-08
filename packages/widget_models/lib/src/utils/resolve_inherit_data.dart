import 'package:flutter/material.dart' show Colors;
// ignore: import_of_legacy_library_into_null_safe
import 'package:widget_models/widget_models.dart';

getValue(PropertyType type, Map<String, dynamic> inherit, String value) {
  if (type == PropertyType.color) {
    if (inherit['parent'] == 'material') {
      if (inherit['from'] == 'Colors') {
        switch (value) {
          case 'Colors.red':
            return Colors.red;
          default:
            return null;
        }
      }
    }
  }
}
