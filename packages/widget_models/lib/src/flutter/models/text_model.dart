import 'package:flutter/material.dart';
import 'package:widget_models/src/utils/code_utils.dart';
import 'package:widget_models/src/property.dart';

import '../model.dart';
import '../types.dart';

/// Provides a model for recreating the [Text] widget
class TextModel extends ModelWidget {
  TextModel(String key, String group) {
    this.key = key;
    this.group = group;
    this.widgetType = FlutterWidgetType.Text;
    this.parentType = ParentType.End;
    this.paramNameAndTypes = {
      "text": [PropertyType.string],
      "fontSize": [PropertyType.double],
      "color": [PropertyType.color],
      "fontStyle": [PropertyType.fontStyle]
    };
    this.params = {
      "text": "",
      "fontSize": "14.0",
      "color": Colors.black,
      "fontStyle": FontStyle.normal
    };
  }

  String _resolveText(String text) {
    if (text.contains(r'$')) {
      final list = text.split(" ");
      text = "";
      list.forEach((txt) {
        if (txt.startsWith(r'$')) {
          text = '$text ${inheritData[txt.substring(1)]}';
        } else {
          text = '$text $txt';
        }
      });
    }
    return text;
  }

  @override
  Widget toWidget(wrap, isSelectMode, resolveParams) {
    return wrap(
        Text(
          params["text"] != null ? _resolveText(params["text"]) : "",
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
