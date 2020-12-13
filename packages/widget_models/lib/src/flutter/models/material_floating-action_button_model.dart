import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:widget_models/src/utils/code_utils.dart';
import 'package:widget_models/src/property.dart';

import '../model.dart';
import '../types.dart';

/// Provides a model for recreating the [Container] widget
class MaterialFloatingActionButtonModel extends ModelWidget {
  MaterialFloatingActionButtonModel(String key, String group) {
    this.key = key;
    this.group = group;
    this.widgetType = FlutterWidgetType.MaterialFloatingActionButton;
    this.parentType = ParentType.SingleChild;
    this.paramNameAndTypes = {
      'onPressed': [PropertyType.function],
    };
    this.params = {
      'onPressed': null,
    };
  }

  @override
  Widget toWidget(wrap, isSelectMode, resolveParams) {
    return wrap(
        FloatingActionButton(
          mouseCursor:
              isSelectMode ? SystemMouseCursors.none : SystemMouseCursors.basic,
          onPressed: isSelectMode
              ? null
              : params["onPressed"] != null
                  ? () => resolveParams(key, paramTypes["onPressed"]!,
                      params["onPressed"]) // ? todo better func
                  : null,
          child: children.length > 0
              ? children
                  .map((e) => e.group == 'child'
                      ? e.toWidget(wrap, isSelectMode, resolveParams)
                      : null)
                  .toList()
                  .first
              : null,
        ),
        key);
  }

  @override
  Map getParamValuesMap() {
    return {};
  }

  @override
  String toCode() {
    return "FloatingActionButton(\n"
        "\n    child: ${children.length > 0 ? children.map((e) => e.group == 'child' ? e.toCode() : null).toList().first : 'null'},"
        "\n  )";
  }
}
