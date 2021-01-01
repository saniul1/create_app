import 'package:flutter/material.dart';
import 'package:widget_models/src/utils/code_utils.dart';
import 'package:widget_models/src/property.dart';

import '../model.dart';
import '../types.dart';

/// Provides a model for recreating the [Container] widget
class MaterialScaffoldModel extends ModelWidget {
  MaterialScaffoldModel(String key, String? group, String? name) {
    this.key = key;
    this.label = name;
    this.globalKey = GlobalKey();
    this.parentGroup = group;
    this.type = FlutterWidgetType.MaterialScaffold;
    this.parentType = ParentType.MultipleChildren;
    this.widgetType = Scaffold();
    this.childGroups = [
      ChildGroup(
        childCount: 1,
        type: ChildType.preferredSizeWidget,
        name: 'appBar',
      ),
      ChildGroup(
        childCount: 1,
        type: ChildType.widget,
        name: 'body',
      ),
      ChildGroup(
        childCount: 1,
        type: ChildType.widget,
        name: 'floatingActionButton',
      )
    ];
    this.paramNameAndTypes = {};
    this.defaultParamsValues = {};
    this.params = {};
  }

  @override
  Widget toWidget(wrap, isSelectMode, resolveParams) {
    resolveChildren(wrap, isSelectMode, resolveParams);
    final appBar = this
        .childGroups
        .where((group) => group.name == 'appBar')
        .toList()
        .firstOrNull
        ?.child;
    final body = this
        .childGroups
        .where((group) => group.name == 'body')
        .toList()
        .firstOrNull
        ?.child;
    final float = this
        .childGroups
        .where((group) => group.name == 'floatingActionButton')
        .toList()
        .firstOrNull
        ?.child;
    return wrap(
        Scaffold(
          key: globalKey,
          appBar: appBar,
          body: body,
          floatingActionButton: float,
        ),
        key);
  }

  @override
  String toCode() {
    return '''
Scaffold(
  appBar: ${children.length > 0 ? children.map((e) => e.parentGroup == 'appBar' ? e.toCode() : null).toList().first : 'null'},
  body: ${children.length > 0 ? children.map((e) => e.parentGroup == 'body' ? e.toCode() : null).toList().first : 'null'},
  floatingActionButton: ${children.length > 0 ? children.map((e) => e.parentGroup == 'floatingActionButton' ? e.toCode() : null).toList().first : 'null'},
)
''';
  }
}
