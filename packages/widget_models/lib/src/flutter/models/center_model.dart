import 'package:flutter/material.dart';
import 'package:widget_models/src/utils/code_utils.dart';
import 'package:widget_models/src/property.dart';

import '../model.dart';
import '../types.dart';

/// Provides a model for recreating the [Center] widget
class CenterModel extends ModelWidget {
  CenterModel(String key) {
    this.key = key;
    this.widgetType = FlutterWidgetType.Center;
    this.nodeType = NodeType.SingleChild;
    this.hasProperties = true;
    this.hasChildren = true;
    this.paramNameAndTypes = {
      "widthFactor": PropertyType.double,
      "heightFactor": PropertyType.double,
    };
    this.params = {
      "widthFactor": "100.0",
      "heightFactor": "100.0",
    };
  }

  @override
  Widget toWidget(wrap) {
    return wrap(
        Center(
          child: children.length > 0 ? children.first.toWidget(wrap) : null,
          widthFactor: double.tryParse(params["widthFactor"].toString()),
          heightFactor: double.tryParse(params["heightFactor"].toString()),
        ),
        key);
  }

  @override
  Map getParamValuesMap() {
    return {
      "widthFactor": params["widthFactor"],
      "heightFactor": params["heightFactor"],
    };
  }

  @override
  String toCode() {
    return "Center(\n"
        "${paramToCode(paramName: "widthFactor", currentValue: double.tryParse(params["widthFactor"].toString()), type: PropertyType.double)}"
        "${paramToCode(paramName: "heightFactor", currentValue: double.tryParse(params["heightFactor"].toString()), type: PropertyType.double)}"
        "    child: ${children.length > 0 ? children.first.toCode() : null},"
        "\n  )";
  }
}
