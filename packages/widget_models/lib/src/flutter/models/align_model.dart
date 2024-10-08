import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:widget_models/src/utils/code_utils.dart';
import 'package:widget_models/src/property.dart';

import '../model.dart';
import '../types.dart';

/// Provides a model for recreating the [Center] widget
class AlignModel extends ModelWidget {
  AlignModel(String key, String? group, String? name) {
    this.key = key;
    this.label = name;
    this.globalKey = GlobalKey();
    this.parentGroup = group;
    this.type = FlutterWidgetType.Align;
    this.parentType = ParentType.SingleChild;
    this.widgetType = Align();
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
      "alignment": [PropertyType.alignment]
    };
    this.defaultParamsValues = {
      "heightFactor": 100.0,
      "widthFactor": 100.0,
      "alignment": 'Alignment.center'
    };
    this.params = {};
  }

  @override
  Widget toWidget(wrap, isSelectMode, resolveParams) {
    resolveChildren(wrap, isSelectMode, resolveParams);
    final child = this
        .childGroups
        .where((group) => group.name == 'child')
        .toList()
        .firstOrNull
        ?.child;
    return wrap(
        Align(
          key: globalKey,
          child: child,
          alignment: params["alignment"] ?? Alignment.center,
          widthFactor:
              params["widthFactor"] != null ? params["widthFactor"] : null,
          heightFactor:
              params["heightFactor"] != null ? params["heightFactor"] : null,
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
