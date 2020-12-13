import 'package:flutter/material.dart';
import 'package:widget_models/src/utils/code_utils.dart';
import 'package:widget_models/src/property.dart';

import '../model.dart';
import '../types.dart';

/// Provides a model for recreating the [Container] widget
class ContainerModel extends ModelWidget {
  ContainerModel(String key, String group) {
    this.key = key;
    this.group = group;
    this.widgetType = FlutterWidgetType.Container;
    this.parentType = ParentType.SingleChild;
    this.paramNameAndTypes = {
      "width": [PropertyType.double],
      "height": [PropertyType.double],
      "color": [PropertyType.color, PropertyType.materialColor],
      "alignment": [PropertyType.alignment]
    };
    this.params = {
      "width": "null",
      "height": "null",
    };
  }

  @override
  Widget toWidget(wrap, isSelectMode, resolveParams) {
    return wrap(
        Container(
          child: children.length > 0
              ? children
                  .map((e) => e.group == 'child'
                      ? e.toWidget(wrap, isSelectMode, resolveParams)
                      : null)
                  .toList()
                  .first
              : Container(),
          width: double.tryParse(params["width"]),
          height: double.tryParse(params["height"]),
          alignment: params["alignment"],
          decoration: BoxDecoration(
            color: params["color"],
          ),
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
        "\n    child: ${children.length > 0 ? children.map((e) => e.group == 'child' ? e.toCode() : null).toList().first : 'null'},"
        "\n  )";
  }
}
