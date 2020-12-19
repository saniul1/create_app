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
    };
    this.defaultParamsValues = {
      'onPressed': null,
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
