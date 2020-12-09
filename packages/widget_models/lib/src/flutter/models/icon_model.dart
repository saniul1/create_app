import 'package:flutter/material.dart';
import 'package:widget_models/src/utils/code_utils.dart';
import 'package:widget_models/src/property.dart';

import '../model.dart';
import '../types.dart';

/// Provides a model for recreating the [Icon] widget
class IconModel extends ModelWidget {
  IconModel(String key, String group) {
    this.key = key;
    this.group = group;
    this.widgetType = FlutterWidgetType.Icon;
    this.parentType = ParentType.End;
    this.hasProperties = true;
    this.hasChildren = false;
    this.paramNameAndTypes = {
      "icon": [PropertyType.icon],
      "size": [PropertyType.double],
    };
    this.params = {
      "size": "20.0",
    };
  }

  @override
  Widget toWidget(wrap, isSelectMode) {
    return wrap(
        Icon(
          params["icon"] ?? null,
          size: double.tryParse(params["size"]) ?? 20.0,
        ),
        key);
  }

  @override
  Map getParamValuesMap() {
    return {
      "icon": params["icon"],
      "size": params["size"],
    };
  }

  @override
  String toCode() {
    return "Icon(\n"
        "${paramToCode(paramName: "icon", isNamed: false, currentValue: params["icon"].toString(), defaultValue: "Icons.help_outline", type: PropertyType.icon)}"
        "${paramToCode(paramName: "size", type: PropertyType.double, currentValue: params["size"])}"
        "\n  )";
  }
}
