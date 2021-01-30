import 'dart:convert' show jsonDecode, jsonEncode;
import 'package:enum_to_string/enum_to_string.dart';
import 'package:better_print/better_print.dart';
import 'package:flutter/cupertino.dart';
import 'package:widget_models/src/property_helpers/property_modifiers.dart';
import 'flutter/model.dart';
import 'flutter/types.dart';
import 'flutter/widgets.dart';
import 'property.dart';
import 'property_helpers/colors_helper.dart';
import 'property_helpers/icons_helper.dart';

/// Defines the insertion mode adding a new [Model] to the [TreeView].
enum InsertMode {
  prepend,
  append,
  insert,
}

class WidgetModelController {
  /// The data for the [TreeView].
  final List<ModelWidget> children;

  WidgetModelController({
    this.children: const [],
  });

  /// Creates a copy of this controller but with the given fields
  /// replaced with the new values.
  WidgetModelController copyWith({List<ModelWidget>? children}) {
    return WidgetModelController(
      children: children ?? this.children,
    );
  }

  /// Loads this controller with data from a JSON String
  /// This method expects the user to properly update the state
  WidgetModelController loadJSON({String json: '[]'}) {
    List jsonList = jsonDecode(json);
    List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(jsonList);
    return loadMap(list: list);
  }

  /// Loads this controller with data from a Map.
  /// This method expects the user to properly update the state
  WidgetModelController loadMap({List<Map<String, dynamic>> list: const []}) {
    List<ModelWidget> widgetTreeData =
        list.map((Map<String, dynamic> item) => _fromMap(item)!).toList();
    _resolveInheritData(widgetTreeData);
    return WidgetModelController(
      children: widgetTreeData,
    );
  }

  _resolveInheritData(List<ModelWidget> children,
      [Map<String, dynamic>? params]) {
    children.forEach((element) {
      element.inheritData = params ?? {};
      _resolveInheritData(element.children, params ?? element.params);
    });
  }

  ModelWidget? _fromMap(Map<String, dynamic> map) {
    final _type = map['type'];
    final _group = map['group'];
    List<ModelWidget> _children = [];
    if (map['children'] != null) {
      List<Map<String, dynamic>> _childrenMap = List.from(map['children']);
      _children = _childrenMap
          .map((Map<String, dynamic> child) => _fromMap(child)!)
          .toList();
    }
    final ModelWidget? widget = getFlutterWidgetModelFromType(map['key'],
        _group, EnumToString.fromString(FlutterWidgetType.values, _type));
    if (widget?.type == FlutterWidgetType.CustomWidget) {
      // print(map['data']);
      map['data'].forEach((key, values) {
        widget?.paramNameAndTypes[key] = [
          EnumToString.fromString(PropertyType.values, values['type'])
        ];
      });
    }
    _children.forEach((child) {
      widget?.addChild(child);
    });
    map['data'].forEach((key, values) {
      widget?.paramNameAndTypes.entries.forEach((element) {
        final type =
            EnumToString.fromString(PropertyType.values, values['type']);
        if (element.key == key && element.value.contains(type)) {
          // print('${element.key}: ${values['value']}');
          widget.paramTypes[key] = type;
          var value;
          if (values['value'] != null)
            switch (type) {
              case PropertyType.color:
                value = Color(values['value']);
                break;
              case PropertyType.icon:
                final name = values['value'].split('.').last;
                final IconInfo? info =
                    materialIconsList.firstWhere((icon) => icon.name == name);
                value = info?.iconData ?? null;
                break;
              case PropertyType.alignment:
                switch (values['value']) {
                  case 'topLeft':
                    value = Alignment.topLeft;
                    break;
                  case 'topCenter':
                    value = Alignment.topCenter;
                    break;
                  case 'topRight':
                    value = Alignment.topRight;
                    break;
                  case 'centerLeft':
                    value = Alignment.centerLeft;
                    break;
                  case 'center':
                    value = Alignment.center;
                    break;
                  case 'centerRight':
                    value = Alignment.centerRight;
                    break;
                  case 'bottomLeft':
                    value = Alignment.bottomLeft;
                    break;
                  case 'bottomCenter':
                    value = Alignment.bottomCenter;
                    break;
                  case 'bottomRight':
                    value = Alignment.bottomRight;
                    break;
                  default:
                }
                break;
              default:
                value = values['value'];
            }
          widget.params[element.key] = value;
          if (widget.type == FlutterWidgetType.CustomWidget) {
            if (!values['isFinal']) {
              attachModifiers(widget, key);
            }
          }
        }
      });
    });
    // widget.paramNameAndTypes.forEach((key, value) {});
    return widget;
  }

  /// Gets the Model that has a key value equal to the specified key.
  ModelWidget? getModel(String key,
      {ModelWidget? parent, List<ModelWidget>? children}) {
    ModelWidget? _found;
    List<ModelWidget> _children = children == null
        ? parent == null
            ? this.children
            : parent.children
        : children;
    Iterator iter = _children.iterator;
    while (iter.moveNext()) {
      ModelWidget child = iter.current;
      if (child.key == key) {
        _found = child;
        break;
      } else {
        if (child.isParent) {
          _found = this.getModel(key, parent: child);
          if (_found != null) {
            break;
          }
        }
      }
    }
    return _found;
  }

  /// Gets the parent of the Model identified by specified key.
  ModelWidget? getParent(String key, {ModelWidget? parent}) {
    ModelWidget? _found;
    List<ModelWidget> _children =
        parent == null ? this.children : parent.children;
    Iterator iter = _children.iterator;
    while (iter.moveNext()) {
      ModelWidget child = iter.current;
      if (child.key == key) {
        _found = parent ?? child;
        break;
      } else {
        if (child.isParent) {
          _found = this.getParent(key, parent: child);
          if (_found != null) break;
        }
      }
    }
    return _found;
  }

  /// Updates an existing Model identified by specified key. This method
  /// returns a new list with the updated Model.
  List<ModelWidget> updateModel(String key, ModelWidget newModel,
      {ModelWidget? parent}) {
    List<ModelWidget> _children = parent?.children ?? this.children;
    final widgetTreeData = _children.map((ModelWidget child) {
      if (child.key == key) {
        return newModel;
      } else {
        // Console.print(key).show();
        if (child.isParent) {
          return child.copyWithChildren(
            children: updateModel(
              key,
              newModel,
              parent: child,
            ),
          );
        }
        return child;
      }
    }).toList();
    _resolveInheritData(children);
    return widgetTreeData;
  }
}
