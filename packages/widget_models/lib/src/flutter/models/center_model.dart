import 'package:flutter/material.dart';
import 'package:widget_models/src/utils/code_utils.dart';
import 'package:widget_models/src/property.dart';

import '../model.dart';
import '../types.dart';

/// Provides a model for recreating the [Center] widget
class CenterModel extends ModelWidget {
  CenterModel(String key, String group) {
    this.key = key;
    this.parentGroup = group;
    this.type = FlutterWidgetType.Center;
    this.parentType = ParentType.SingleChild;
    this.widgetType = Center();
    this.childGroups = [
      ChildGroup(
        childCount: 1,
        type: ChildType.widget,
        name: 'child',
      )
    ];
    this.paramNameAndTypes = {
      "widthFactor": [PropertyType.double],
      "heightFactor": [PropertyType.double],
    };
    this.defaultParamsValues = {
      "heightFactor": "100.0",
      "widthFactor": "100.0",
    };
    this.params = {};
  }

  @override
  Widget toWidget(wrap, isSelectMode, resolveParams) {
    final groups = resolveChildren(wrap, isSelectMode, resolveParams);
    final child = groups
        .where((group) => group.name == 'child')
        .toList()
        .firstOrNull
        ?.child;
    return wrap(
        Center(
          child: child,
          widthFactor: params["widthFactor"] != null
              ? double.tryParse(params["widthFactor"].toString())
              : null,
          heightFactor: params["heightFactor"] != null
              ? double.tryParse(params["heightFactor"].toString())
              : null,
        ),
        key);
  }

  @override
  String toCode() {
    return "Center(\n"
        "${paramToCode(paramName: "widthFactor", currentValue: double.tryParse(params["widthFactor"].toString()), type: PropertyType.double)}"
        "${paramToCode(paramName: "heightFactor", currentValue: double.tryParse(params["heightFactor"].toString()), type: PropertyType.double)}"
        "    child: ${children.length > 0 ? children.map((e) => e.parentGroup == 'child' ? e.toCode() : null).toList().first : 'null'},"
        "\n  )";
  }
}
