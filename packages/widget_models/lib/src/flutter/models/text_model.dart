import 'package:flutter/material.dart';
import 'package:widget_models/src/utils/code_utils.dart';
import 'package:widget_models/src/property.dart';

import '../model.dart';
import '../types.dart';

/// Provides a model for recreating the [Text] widget
class TextModel extends ModelWidget {
  TextModel(String key, String group) {
    this.key = key;
    this.globalKey = GlobalKey();
    this.parentGroup = group;
    this.type = FlutterWidgetType.Text;
    this.parentType = ParentType.End;
    this.widgetType = Text('');
    this.childGroups = [];
    this.paramNameAndTypes = {
      "text": [PropertyType.string],
      "fontSize": [PropertyType.double],
      "color": [PropertyType.color],
      "fontStyle": [PropertyType.fontStyle]
    };
    this.defaultParamsValues = {
      "text": "",
      "fontSize": "14.0",
      "color": Colors.black,
      "fontStyle": FontStyle.normal
    };
    this.params = {
      "text": this.defaultParamsValues["text"],
    };
  }

  // for inheriting key needs to start with '$'
  // to pass more than one key use \(escape) ex: '$count\$count'
  // to use normal character alongside data use \(escape) ex: '$count\!!'
  //to sue both ex: '$count\!!\$count'
  String _resolveText(String text) {
    if (text.contains(r'$')) {
      final chr = text.characters;
      var spaces = '';
      for (var c in chr) {
        if (c == ' ')
          spaces = '$spaces$c';
        else
          break;
      }
      final list = text.split(" ");
      text = '';
      list.forEach((txt) {
        if (txt.contains(r'$')) {
          final tx = txt.split('\\');
          var t = '';
          tx.forEach((e) {
            t = '$t${e.startsWith(r'$') ? inheritData[e.substring(1)] : e}';
          });
          text = '$text $t';
        } else {
          text = text == '' ? '$spaces$txt' : '$text $txt';
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
          key: globalKey,
          style: TextStyle(
              fontSize: params["fontSize"] != null
                  ? double.tryParse(params["fontSize"])
                  : null,
              color: params["color"] ?? Colors.black,
              fontStyle: params["fontStyle"] ?? FontStyle.normal),
        ),
        key);
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
