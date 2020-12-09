import 'dart:convert';

import 'package:widget_models/widget_models.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import '../utilities.dart';

class PropertyBox<T> {
  /// The unique string that identifies this object.
  final String key;

  /// The string value that is displayed on the [TreeNode].
  final String label;

  List<PropertyType> type;

  final T value;

  PropertyBox({
    @required this.key,
    @required this.label,
    @required this.value,
    @required this.type,
  })  : assert(key != null),
        assert(label != null),
        assert(value != null),
        assert(type != null);

  /// Creates a copy of this object but with the given fields
  /// replaced with the new values.
  PropertyBox copyWith({
    String key,
    String name,
    T value,
    PropertyType type,
    List actions,
  }) =>
      PropertyBox(
        key: key ?? this.key,
        label: label ?? this.label,
        value: value ?? this.value,
        type: type ?? this.type,
      );

  factory PropertyBox.fromMap(Map<String, dynamic> map) {
    String _key = map['key'];
    String _label = map['label'];
    List<PropertyType> _type = map['type'];
    T _value = map['value'];
    return PropertyBox(
      key: _key,
      label: _label,
      value: _value,
      type: _type,
    );
  }

  /// Map representation of this object
  Map<String, dynamic> get asMap {
    // print(JsonEncoder().convert(value));
    Map<String, dynamic> _map = {
      key: {
        "label": label,
        "value": value.toString(),
        "type": EnumToString.convertToString(type),
      }
    };
    return _map;
  }

  @override
  String toString() {
    return JsonEncoder().convert(asMap);
  }
}
