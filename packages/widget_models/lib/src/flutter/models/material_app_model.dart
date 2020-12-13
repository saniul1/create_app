import 'package:flutter/material.dart';
import 'package:widget_models/src/utils/code_utils.dart';
import 'package:widget_models/src/property.dart';

import '../model.dart';
import '../types.dart';

/// Provides a model for recreating the [Container] widget
class MaterialAppModel extends ModelWidget {
  MaterialAppModel(String key, String group) {
    this.key = key;
    this.group = group;
    this.widgetType = FlutterWidgetType.MaterialApp;
    this.parentType = ParentType.SingleChild;
    this.paramNameAndTypes = {
      "debugShowCheckedModeBanner": [PropertyType.boolean],
    };
    this.params = {
      "debugShowCheckedModeBanner": false,
    };
  }

  @override
  Widget toWidget(wrap, isSelectMode, resolveParams) {
    final nullValue = Container(child: Center(child: Text('null')));
    return wrap(
        MaterialApp(
          debugShowCheckedModeBanner: params["debugShowCheckedModeBanner"],
          home: children.length > 0
              ? children
                  .map((e) => e.group == 'home'
                      ? e.toWidget(wrap, isSelectMode, resolveParams)
                      : nullValue)
                  .toList()
                  .first
              : nullValue,
        ),
        key);
  }

  @override
  String toCode() {
    return "MaterialApp(\n"
        "${paramToCode(paramName: "debugShowCheckedModeBanner", currentValue: params["debugShowCheckedModeBanner"], type: PropertyType.boolean)}"
        "\n    home: ${children.length > 0 ? children.map((e) => e.group == 'home' ? e.toCode() : null).toList().first : 'null'},"
        "\n  )";
  }
}
