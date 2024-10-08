import 'package:flutter/material.dart';
import 'package:widget_models/src/flutter/widgets/null_widget.dart';
import 'package:widget_models/src/utils/code_utils.dart';
import 'package:widget_models/src/property.dart';

import '../model.dart';
import '../types.dart';

/// Provides a model for recreating the [Container] widget
class MaterialAppModel extends ModelWidget {
  MaterialAppModel(String key, String? group, String? name) {
    this.key = key;
    this.label = name;
    this.globalKey = GlobalKey();
    this.parentGroup = group;
    this.type = FlutterWidgetType.MaterialApp;
    this.parentType = ParentType.SingleChild;
    this.widgetType = MaterialApp();
    this.childGroups = [
      ChildGroup(
        childCount: 1,
        type: ChildType.widget,
        name: 'home',
      )
    ];
    this.paramNameAndTypes = {
      "debugShowCheckedModeBanner": [PropertyType.boolean],
    };
    this.defaultParamsValues = {
      "debugShowCheckedModeBanner": true,
    };
    this.params = {};
  }

  @override
  Widget toWidget(wrap, isSelectMode, resolveParams) {
    resolveChildren(wrap, isSelectMode, resolveParams);
    final child = this
        .childGroups
        .where((group) => group.name == 'home')
        .toList()
        .firstOrNull
        ?.child;
    return wrap(
        MaterialApp(
          key: globalKey,
          debugShowCheckedModeBanner:
              params["debugShowCheckedModeBanner"] ?? true,
          home: child ?? NullWidget(),
        ),
        key);
  }

  @override
  String toCode() {
    return "MaterialApp(\n"
        "${paramToCode(paramName: "debugShowCheckedModeBanner", currentValue: params["debugShowCheckedModeBanner"], type: PropertyType.boolean)}"
        "\n    home: ${children.length > 0 ? children.map((e) => e.parentGroup == 'home' ? e.toCode() : null).toList().first : 'null'},"
        "\n  )";
  }
}
