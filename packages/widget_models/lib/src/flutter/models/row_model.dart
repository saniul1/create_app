import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:widget_models/src/utils/code_utils.dart';
import 'package:widget_models/src/property.dart';

import '../model.dart';
import '../types.dart';

/// Provides a model for recreating the [Column] widget
class RowModel extends ModelWidget {
  RowModel(String key, String? group, String? name) {
    this.key = key;
    this.label = name;
    this.globalKey = GlobalKey();
    this.parentGroup = group;
    this.type = FlutterWidgetType.Row;
    this.parentType = ParentType.MultipleChildren;
    this.widgetType = Row();
    this.childGroups = [
      ChildGroup(
        childCount: -1,
        type: ChildType.widget,
        name: 'children',
      )
    ];
    this.paramNameAndTypes = {
      "mainAxisAlignment": [PropertyType.mainAxisAlignment],
      "crossAxisAlignment": [PropertyType.crossAxisAlignment],
      "mainAxisSize": [PropertyType.mainAxisSize]
    };
    this.defaultParamsValues = {
      "mainAxisAlignment": 'start',
      "crossAxisAlignment": 'center',
      "mainAxisSize": 'max',
    };
    this.params = {};
  }

  @override
  Widget toWidget(wrap, isSelectMode, resolveParams) {
    resolveChildren(wrap, isSelectMode, resolveParams);
    final children = this
        .childGroups
        .where((group) => group.name == 'children')
        .toList()
        .firstOrNull
        ?.child;
    return Row(
      key: globalKey,
      mainAxisAlignment: params["mainAxisAlignment"] == null
          ? MainAxisAlignment.start
          : EnumToString.fromString(
              MainAxisAlignment.values, params["mainAxisAlignment"]),
      crossAxisAlignment: params["crossAxisAlignment"] == null
          ? CrossAxisAlignment.start
          : EnumToString.fromString(
              CrossAxisAlignment.values, params["crossAxisAlignment"]),
      mainAxisSize: params["mainAxisSize"] == null
          ? MainAxisSize.max
          : EnumToString.fromString(
              MainAxisSize.values, params["mainAxisSize"]),
      children: children ?? [],
    );
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
