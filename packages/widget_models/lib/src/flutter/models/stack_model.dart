import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:widget_models/src/utils/code_utils.dart';
import 'package:widget_models/src/property.dart';

import '../model.dart';
import '../types.dart';

/// Provides a model for recreating the [Column] widget
class StackModel extends ModelWidget {
  StackModel(String key, String? group, String? name) {
    this.key = key;
    this.label = name;
    this.globalKey = GlobalKey();
    this.parentGroup = group;
    this.type = FlutterWidgetType.Stack;
    this.parentType = ParentType.MultipleChildren;
    this.widgetType = Stack();
    this.childGroups = [
      ChildGroup(
        childCount: -1,
        type: ChildType.widget,
        name: 'children',
      )
    ];
    this.paramNameAndTypes = {};
    this.defaultParamsValues = {};
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
    return Stack(
      key: globalKey,
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
