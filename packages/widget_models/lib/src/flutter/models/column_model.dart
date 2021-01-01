import 'package:flutter/material.dart';
import 'package:widget_models/src/utils/code_utils.dart';
import 'package:widget_models/src/property.dart';

import '../model.dart';
import '../types.dart';

/// Provides a model for recreating the [Column] widget
class ColumnModel extends ModelWidget {
  ColumnModel(String key, String? group) {
    this.key = key;
    this.globalKey = GlobalKey();
    this.parentGroup = group;
    this.type = FlutterWidgetType.Column;
    this.parentType = ParentType.MultipleChildren;
    this.widgetType = Column();
    this.childGroups = [
      ChildGroup(
        childCount: -1,
        type: ChildType.widget,
        name: 'children',
      )
    ];
    this.paramNameAndTypes = {
      "mainAxisAlignment": [PropertyType.mainAxisAlignment],
      "crossAxisAlignment": [PropertyType.crossAxisAlignment]
    };
    this.defaultParamsValues = {
      "mainAxisAlignment": MainAxisAlignment.center,
      "crossAxisAlignment": CrossAxisAlignment.center,
    };
    this.params = {};
  }

  @override
  Widget toWidget(wrap, isSelectMode, resolveParams) {
    final groups = resolveChildren(wrap, isSelectMode, resolveParams);
    final children = groups
        .where((group) => group.name == 'children')
        .toList()
        .firstOrNull
        ?.child;
    return Column(
      key: globalKey,
      mainAxisAlignment: params["mainAxisAlignment"] == null
          ? MainAxisAlignment.start
          : params["mainAxisAlignment"],
      crossAxisAlignment: params["crossAxisAlignment"] == null
          ? CrossAxisAlignment.start
          : params["crossAxisAlignment"],
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
