import 'package:flutter/material.dart';
import 'package:widget_models/src/utils/code_utils.dart';
import 'package:widget_models/src/property.dart';

import '../model.dart';
import '../types.dart';

/// Provides a model for recreating the [Container] widget
class CustomModel extends ModelWidget {
  CustomModel(String key, String group) {
    this.key = key;
    this.parentGroup = group;
    this.type = FlutterWidgetType.CustomWidget;
    this.parentType = ParentType.SingleChild;
    this.widgetType = StateFullCustom();
    this.childGroups = [
      ChildGroup(
        childCount: 1,
        type: ChildType.widget,
        name: 'child',
      )
    ];
    this.paramNameAndTypes = {};
    this.defaultParamsValues = {};
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
        Container(
          child: child,
        ),
        key);
  }

  @override
  String toCode() {
    return "Container(\n"
        "${paramToCode(paramName: "width", currentValue: double.tryParse(params["width"]), type: PropertyType.double)}"
        "${paramToCode(paramName: "height", currentValue: double.tryParse(params["height"]), type: PropertyType.double)}"
        "${paramToCode(paramName: "alignment", type: PropertyType.alignment, currentValue: params["alignment"])}"
        "    decoration: BoxDecoration(\n"
        "${paramToCode(paramName: "color", type: PropertyType.color, currentValue: params["color"])}"
        "    ),"
        "\n    child: ${children.length > 0 ? children.map((e) => e.parentGroup == 'child' ? e.toCode() : null).toList().first : 'null'},"
        "\n  )";
  }
}
