import 'dart:convert';
import 'package:better_print/better_print.dart';
import 'package:widget_models/widget_models.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import '../utilities.dart';

class PropertyBox {
  /// The unique string that identifies this object.
  final String key;

  /// The string value that is displayed on the [TreeNode].
  final String label;

  PropertyType type;

  List<PropertyType> acceptedTypes;

  final dynamic value;

  final bool isInitialized;

  PropertyBox({
    required this.key,
    required this.label,
    required this.value,
    required this.type,
    required this.acceptedTypes,
    this.isInitialized = false,
  });

  /// Creates a copy of this object but with the given fields
  /// replaced with the new values.
  PropertyBox copyWith({
    String? key,
    String? label,
    dynamic? value,
    PropertyType? type,
    List<PropertyType>? acceptedTypes,
    List? actions,
    bool? isInitialized,
  }) {
    // Console.print(this.acceptedTypes).show();
    if (value != null && this.value is Color && value is int)
      value = Color(value);
    return PropertyBox(
      key: key ?? this.key,
      label: label ?? this.label,
      value: value ?? this.value,
      type: type ?? this.type,
      acceptedTypes: acceptedTypes ?? this.acceptedTypes,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  factory PropertyBox.fromMap(Map<String, dynamic> map) {
    String _key = map['key'];
    String _label = map['label'];
    PropertyType _type = map['type'];
    List<PropertyType> _acceptedTypes = map['acceptedTypes'];
    dynamic _value = map['value'];
    return PropertyBox(
      key: _key,
      label: _label,
      value: _value,
      type: _type,
      acceptedTypes: _acceptedTypes,
    );
  }

  /// Map representation of this object
  Map<String, dynamic> get asMap {
    // print(JsonEncoder().convert(value));
    final val = value is Color ? value.value : value;
    Map<String, dynamic> _map = {
      key: {
        "label": label,
        "value": val,
        "type": EnumToString.convertToString(type), //? todo
      }
    };
    return _map;
  }

  @override
  String toString() {
    return JsonEncoder().convert(asMap);
  }
}
