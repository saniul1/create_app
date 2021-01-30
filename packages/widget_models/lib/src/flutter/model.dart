import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget;
import '../property.dart';
import './types.dart';

extension MyList<T> on List<T> {
  T? get firstOrNull => this.isEmpty ? null : this.first;
}

class StateLessCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class HookCustom extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class StateFullCustom extends StatefulWidget {
  @override
  _StateFullCustomState createState() => _StateFullCustomState();
}

class _StateFullCustomState extends State<StateFullCustom> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ChildGroup {
  final String name;
  final ChildType type;

  /// uses -1 as infinity
  final int childCount;

  final dynamic? child;
  ChildGroup({
    required this.name,
    required this.type,
    required this.childCount,
    this.child,
  });
}

/// Model Widget class
abstract class ModelWidget {
  late String key;

  late String? label;

  GlobalKey? globalKey;

  /// Type of widget ([Text], [Center], [Column], etc)
  late FlutterWidgetType type;

  late Object widgetType;

  /// Children of the widget
  late List<ModelWidget> children = [];

  late List<ChildGroup> childGroups = [];

  bool get isParent => children.isNotEmpty;

  /// which property of parent it belongs to
  late String? parentGroup;

  /// How the widget fits into the tree
  /// [ParentType.End] is used for widgets that cannot have children
  /// [ParentType.SingleChild] and [ParentType.MultipleChildren] are self-explanatory
  late ParentType parentType;

  /// Stores the names of all parameters and input types accepted
  Map<String, List<PropertyType>> paramNameAndTypes = {};

  /// Stores the names of all parameters and input types of current [params]
  Map<String, PropertyType> paramTypes = {};

  /// The parameter values of the widget
  /// Key is the parameter name and value is the value
  Map<String, dynamic> params = {};

  Map<String, dynamic> defaultParamsValues = {};

  Map<String, dynamic> inheritData = {};

  Map modifiers = {};

  /// This method takes the parameters and returns the actual widget to display
  Widget toWidget(
    Widget Function(Widget, String key) wrap,
    bool isSelectMode,
    void Function(String key, PropertyType type, dynamic args) resolveParams,
  );

  /// Add child if widget takes children and space is available and return true, else return false
  bool addChild(ModelWidget widget) {
    if (parentType == ParentType.SingleChild) {
      children = [widget];
      return true;
    } else if (parentType == ParentType.MultipleChildren) {
      children.add(widget);
      return true;
    }

    return false;
  }

  void resolveChildren(
      Widget Function(Widget, String key) wrap,
      bool isSelectMode,
      void Function(String key, PropertyType type, dynamic args)
          resolveParams) {
    List<ChildGroup> _newGroup = [];
    childGroups.forEach((group) {
      final childs =
          children.where((child) => child.parentGroup == group.name).toList();
      if (childs.length == group.childCount || group.childCount < 0) {
        final isTypeOk = childs.every((child) {
          if (group.type == ChildType.widget)
            return child.widgetType is Widget;
          else if (group.type == ChildType.preferredSizeWidget)
            return child.widgetType is PreferredSizeWidget;
          else
            return false;
        });
        if (isTypeOk) {
          if (group.childCount == 1 && childs.length == 1) {
            _newGroup.add(ChildGroup(
              type: group.type,
              name: group.name,
              childCount: 1,
              child: childs.first.toWidget(wrap, isSelectMode, resolveParams),
            ));
          }
          if (group.childCount < 0) {
            _newGroup.add(
              ChildGroup(
                type: group.type,
                name: group.name,
                childCount: -1,
                child: childs
                    .map((e) => e.toWidget(wrap, isSelectMode, resolveParams))
                    .toList(),
              ),
            );
          }
        }
      }
    });
    this
        .childGroups
        .removeWhere((el) => _newGroup.any((e) => e.name == el.name));
    this.childGroups.addAll(_newGroup);
  }

  // ? possible mistake
  ModelWidget copyWithChildren({required List<ModelWidget> children}) {
    this.children = children;
    return this;
  }

  ModelWidget coptWith({required ModelWidget model, String? name}) {
    print(model.dataAsMap);
    this.label = name;
    return this;
  }

  /// Converts current widget to code and returns as string
  String toCode();

  // {
  //   "text": {
  //     "label": "text",
  //     "value": "Hello World!!",
  //     "type": "string",
  //     "isFinal": true
  // }
  Map get dataAsMap {
    Map _map = {};
    params.forEach((key, value) {
      _map[key] = {
        "label": key,
        "value": value,
        "type": value.runtimeType.toString(),
        "isFinal": !modifiers.keys.contains(key),
      };
    });
    return _map;
  }

  // "key": "text",
  // "label": "Text",
  // "type": "Text",
  // "group": "children",
  // "data": {},
  // "children": []
  Map<String, dynamic> get asMap => {
        "key": key,
        "label": label ?? EnumToString.convertToString(type),
        "type": EnumToString.convertToString(type),
        "group": parentGroup,
        "data": dataAsMap,
        "children": children.map((child) => child.asMap).toList(),
      };

  String get asString => JsonEncoder().convert(asMap);
}
