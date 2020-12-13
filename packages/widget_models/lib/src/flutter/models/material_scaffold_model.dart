import 'package:flutter/material.dart';
import 'package:widget_models/src/utils/code_utils.dart';
import 'package:widget_models/src/property.dart';

import '../model.dart';
import '../types.dart';

/// Provides a model for recreating the [Container] widget
class MaterialScaffoldModel extends ModelWidget {
  MaterialScaffoldModel(String key, String group) {
    this.key = key;
    this.group = group;
    this.widgetType = FlutterWidgetType.MaterialScaffold;
    this.parentType = ParentType.MultipleChildren;
    this.paramNameAndTypes = {};
    this.params = {};
  }

  @override
  Widget toWidget(wrap, isSelectMode, resolveParams) {
    final appBar = children
        .map((e) => e.group == 'appBar'
            ? e.toWidget(wrap, isSelectMode, resolveParams)
            : null)
        .toList();
    final body = children
        .map((e) => e.group == 'body'
            ? e.toWidget(wrap, isSelectMode, resolveParams)
            : null)
        .toList();
    final float = children
        .map((e) => e.group == 'floatingActionButton'
            ? e.toWidget(wrap, isSelectMode, resolveParams)
            : null)
        .toList();
    appBar.removeWhere((element) => element == null);
    body.removeWhere((element) => element == null);
    float.removeWhere((element) => element == null);
    PreferredSizeWidget? _appbar =
        appBar.first.runtimeType == PreferredSizeWidget
            ? appBar.first as PreferredSizeWidget
            : null;
    return wrap(
        Scaffold(
          appBar: _appbar,
          body: body.length > 0 ? body.first : null,
          floatingActionButton: float.length > 0 ? float.first : null,
        ),
        key);
  }

  @override
  Map getParamValuesMap() {
    return {};
  }

  @override
  String toCode() {
    return "Scaffold(\n"
        "\n    appBar: ${children.length > 0 ? children.map((e) => e.group == 'appBar' ? e.toCode() : null).toList().first : 'null'},"
        "\n    body: ${children.length > 0 ? children.map((e) => e.group == 'body' ? e.toCode() : null).toList().first : 'null'},"
        "\n    floatingActionButton: ${children.length > 0 ? children.map((e) => e.group == 'floatingActionButton' ? e.toCode() : null).toList().first : 'null'},"
        "\n  )";
  }
}
