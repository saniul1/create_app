import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:widget_models/src/utils/code_utils.dart';
import 'package:widget_models/src/property.dart';

import '../model.dart';
import '../types.dart';

/// Provides a model for recreating the [Container] widget
class MaterialFloatingActionButtonModel extends ModelWidget {
  MaterialFloatingActionButtonModel(String key, String? group, String? name) {
    this.key = key;
    this.label = name;
    this.globalKey = GlobalKey();
    this.parentGroup = group;
    this.type = FlutterWidgetType.MaterialFloatingActionButton;
    this.parentType = ParentType.SingleChild;
    this.widgetType = FloatingActionButton(
      onPressed: null,
    );
    this.childGroups = [
      ChildGroup(
        childCount: 1,
        type: ChildType.widget,
        name: 'child',
      )
    ];
    this.paramNameAndTypes = {
      'onPressed': [PropertyType.function],
      'backgroundColor': [PropertyType.color]
    };
    this.defaultParamsValues = {
      'onPressed': null,
      'backgroundColor': Colors.blue
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
        FloatingActionButton(
          key: globalKey,
          mouseCursor:
              isSelectMode ? SystemMouseCursors.none : SystemMouseCursors.basic,
          onPressed: isSelectMode
              ? null
              : params["onPressed"] != null
                  ? () => resolveParams(key, paramTypes["onPressed"]!,
                      params["onPressed"]) // ? todo better func
                  : null,
          child: child,
          backgroundColor: params["backgroundColor"],
        ),
        key);
  }

  @override
  String toCode() {
    return "FloatingActionButton(\n"
        "\n    child: ${children.length > 0 ? children.map((e) => e.parentGroup == 'child' ? e.toCode() : null).toList().first : 'null'},"
        "\n  )";
  }
}
