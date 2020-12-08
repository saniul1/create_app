import 'package:flutter/material.dart';
import 'package:widget_models/src/utils/code_utils.dart';
import 'package:widget_models/src/property.dart';

import '../model.dart';
import '../types.dart';

/// Provides a model for recreating the [Text] widget
class TextModel extends ModelWidget {
  TextModel(String key) {
    this.key = key;
    this.widgetType = FlutterWidgetType.Text;
    this.nodeType = NodeType.End;
    this.hasProperties = true;
    this.hasChildren = false;
    this.paramNameAndTypes = {
      "text": PropertyType.string,
      "fontSize": PropertyType.double,
      "color": PropertyType.color,
      "fontStyle": PropertyType.fontStyle
    };
    this.params = {
      "text": "",
      "fontSize": "14.0",
      "color": Colors.black,
      "fontStyle": FontStyle.normal
    };
  }

  @override
  Widget toWidget(wrap) {
    return wrap(
        Text(
          params["text"] ?? "",
          style: TextStyle(
              fontSize: double.tryParse(params["fontSize"]) ?? 14.0,
              color: params["color"] ?? Colors.black,
              fontStyle: params["fontStyle"] ?? FontStyle.normal),
        ),
        key);
  }

  @override
  Map getParamValuesMap() {
    return {
      "text": params["text"],
      "fontSize": params["fontSize"],
      "color": params["color"],
      "fontStyle": params["fontStyle"]
    };
  }

  @override
  String toCode() {
    return "Text(\n"
        "${paramToCode(isNamed: false, type: PropertyType.string, currentValue: params["text"], defaultValue: "")}"
        "  style: TextStyle(\n"
        "${paramToCode(paramName: "fontSize", type: PropertyType.double, currentValue: double.tryParse(params["fontSize"]), defaultValue: 14.0.toString())}"
        "${paramToCode(paramName: "color", type: PropertyType.color, currentValue: params["color"])}"
        "${paramToCode(paramName: "fontStyle", type: PropertyType.fontStyle, currentValue: params["fontStyle"], defaultValue: "FontStyle.normal")}"
        "  ),"
        "\n)";
  }
}
