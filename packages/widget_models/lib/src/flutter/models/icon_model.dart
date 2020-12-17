import 'package:flutter/material.dart';
import 'package:widget_models/src/utils/code_utils.dart';
import 'package:widget_models/src/property.dart';

import '../model.dart';
import '../types.dart';

/// Provides a model for recreating the [Icon] widget
class IconModel extends ModelWidget {
  IconModel(String key, String group) {
    this.key = key;
    this.parentGroup = group;
    this.type = FlutterWidgetType.Icon;
    this.parentType = ParentType.End;
    this.widgetType = Icon(null);
    this.childGroups = [];
    this.paramNameAndTypes = {
      "icon": [PropertyType.icon],
      "size": [PropertyType.double],
    };
    this.defaultParamsValues = {
      "size": "20.0",
    };
    this.params = {};
  }

  @override
  Widget toWidget(wrap, isSelectMode, resolveParams) {
    return wrap(
        Icon(
          params["icon"] ?? null,
          size: params["size"] != null ? double.tryParse(params["size"]) : null,
        ),
        key);
  }

  @override
  String toCode() {
    return "Icon(\n"
        "${paramToCode(paramName: "icon", isNamed: false, currentValue: params["icon"].toString(), defaultValue: "Icons.help_outline", type: PropertyType.icon)}"
        "${paramToCode(paramName: "size", type: PropertyType.double, currentValue: params["size"])}"
        "\n  )";
  }
}
