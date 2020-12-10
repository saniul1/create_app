import 'package:flutter/material.dart';
import 'package:widget_models/src/utils/code_utils.dart';
import 'package:widget_models/src/property.dart';

import '../model.dart';
import '../types.dart';

/// Provides a model for recreating the [Column] widget
class ColumnModel extends ModelWidget {
  ColumnModel(String key, String group) {
    this.key = key;
    this.group = group;
    this.hasProperties = true;
    this.hasChildren = true;
    this.widgetType = FlutterWidgetType.Column;
    this.parentType = ParentType.MultipleChildren;
    this.paramNameAndTypes = {
      "mainAxisAlignment": [PropertyType.mainAxisAlignment],
      "crossAxisAlignment": [PropertyType.crossAxisAlignment]
    };
    this.params = {
      "mainAxisAlignment": MainAxisAlignment.center,
      "crossAxisAlignment": CrossAxisAlignment.center,
    };
  }

  @override
  Widget toWidget(wrap, isSelectMode, resolveParams) {
    return Column(
      mainAxisAlignment: params["mainAxisAlignment"] == null
          ? MainAxisAlignment.start
          : params["mainAxisAlignment"],
      crossAxisAlignment: params["crossAxisAlignment"] == null
          ? CrossAxisAlignment.start
          : params["crossAxisAlignment"],
      children: children.isNotEmpty
          ? children
              .map((e) => e.group == 'children'
                  ? e.toWidget(wrap, isSelectMode, resolveParams)
                  : null)
              .toList()
          : [],
    );
  }

  @override
  Map getParamValuesMap() {
    return {
      "mainAxisAlignment": params["mainAxisAlignment"],
      "crossAxisAlignment": params["crossAxisAlignment"],
    };
  }

  @override
  String toCode() {
    return "Column(\n"
        "${paramToCode(paramName: "mainAxisAlignment", type: PropertyType.mainAxisAlignment, currentValue: params["mainAxisAlignment"])}"
        "${paramToCode(paramName: "crossAxisAlignment", type: PropertyType.mainAxisAlignment, currentValue: params["crossAxisAlignment"])}"
        '''    children: ${children.isNotEmpty ? children.map((widget) {
            return widget.toCode();
          }).toList() : []},'''
        "\n  )";
  }
}
