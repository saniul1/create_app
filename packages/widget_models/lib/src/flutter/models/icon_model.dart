import 'package:flutter/material.dart';
import 'package:widget_models/src/utils/code_utils.dart';
import 'package:widget_models/src/property.dart';

import '../model.dart';
import '../types.dart';

/// Provides a model for recreating the [Icon] widget
class IconModel extends ModelWidget {
  IconModel(String key, String? group, String? name) {
    this.key = key;
    this.label = name;
    this.globalKey = GlobalKey();
    this.parentGroup = group;
    this.type = FlutterWidgetType.Icon;
    this.parentType = ParentType.End;
    this.widgetType = Icon(null);
    this.childGroups = [];
    this.paramNameAndTypes = {
      "icon": [PropertyType.icon],
      "size": [PropertyType.double],
      "color": [PropertyType.color],
    };
    this.defaultParamsValues = {
      "icon": null,
      "size": 20.0,
      "color": Colors.black,
    };
    this.params = {};
  }

  @override
  Widget toWidget(wrap, isSelectMode, resolveParams) {
    return wrap(
        Icon(
          params["icon"] ?? null,
          key: globalKey,
          size: params["size"] != null ? params["size"] : null,
          color: params["color"],
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
