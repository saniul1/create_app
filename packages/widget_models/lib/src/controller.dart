import 'dart:convert' show jsonDecode, jsonEncode;
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:widget_models/src/property_helpers/property_modifiers.dart';
import 'flutter/model.dart';
import 'flutter/types.dart';
import 'flutter/widgets.dart';
import 'property.dart';
import 'property_helpers/colors_helper.dart';
import 'property_helpers/icons_helper.dart';

/// Defines the insertion mode adding a new [Node] to the [TreeView].
enum InsertMode {
  prepend,
  append,
  insert,
}

class WidgetModelController {
  /// The data for the [TreeView].
  final List<ModelWidget> children;
  final Map<String, Map<String, String>> inheritDataMap;

  WidgetModelController({
    this.children: const [],
    @required this.inheritDataMap,
  });

  // {key:{inheritTo: inheritFrom}}
  final Map<String, Map<String, String>> _inheritDataMap = {};

  /// Creates a copy of this controller but with the given fields
  /// replaced with the new values.
  WidgetModelController copyWith(
      {List<ModelWidget> children, String inheritDataMap}) {
    return WidgetModelController(
      children: children ?? this.children,
      inheritDataMap: inheritDataMap ?? this.inheritDataMap,
    );
  }

  /// Loads this controller with data from a JSON String
  /// This method expects the user to properly update the state
  ///
  /// ```dart
  /// setState((){
  ///   controller = controller.loadJSON(json: jsonString);
  /// });
  /// ```
  WidgetModelController loadJSON({String json: '[]'}) {
    List jsonList = jsonDecode(json);
    List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(jsonList);
    return loadMap(list: list);
  }

  /// Loads this controller with data from a Map.
  /// This method expects the user to properly update the state
  ///
  /// ```dart
  /// setState((){
  ///   controller = controller.loadMap(map: dataMap);
  /// });
  /// ```
  WidgetModelController loadMap({List<Map<String, dynamic>> list: const []}) {
    List<ModelWidget> treeData =
        list.map((Map<String, dynamic> item) => _fromMap(item)).toList();
    _resolveInheritData(treeData, _inheritDataMap);
    return WidgetModelController(
      children: treeData,
      inheritDataMap: _inheritDataMap,
    );
  }

  _resolveInheritData(
      List<ModelWidget> treeData, Map<String, Map<String, String>> inheritMap) {
    inheritMap.forEach((key, inherit) {
      final to = getNode(key, children: treeData);
      final from = getNode(inherit.values.first, children: treeData);
      to.inheritData[inherit.keys.first] = from.params[inherit.keys.first];
    });
  }

  ModelWidget _fromMap(Map<String, dynamic> map) {
    final _type = map['type'];
    final _group = map['group'];
    List<ModelWidget> _children = [];
    if (map['children'] != null) {
      List<Map<String, dynamic>> _childrenMap = List.from(map['children']);
      _children = _childrenMap
          .map((Map<String, dynamic> child) => _fromMap(child))
          .toList();
    }
    final ModelWidget widget = getFlutterWidgetModelFromType(map['key'], _group,
        EnumToString.fromString(FlutterWidgetType.values, _type));
    if (widget.widgetType == FlutterWidgetType.CustomWidget) {
      // print(map['data']);
      map['data'].forEach((key, values) {
        widget.paramNameAndTypes[key] = [
          EnumToString.fromString(PropertyType.values, values['type'])
        ];
      });
    }
    _children.forEach((child) {
      widget.addChild(child);
    });
    map['data'].forEach((key, values) {
      widget.paramNameAndTypes.entries.forEach((element) {
        final type =
            EnumToString.fromString(PropertyType.values, values['type']);
        if (element.key == key && element.value.contains(type)) {
          // print('${element.key}: ${values['value']}');
          widget.paramTypes[key] = type;
          var value;
          switch (type) {
            case PropertyType.materialColor:
              final name = values['value'].split('.').last;
              value =
                  colors.firstWhere((icon) => icon.name == name)?.color ?? null;
              break;
            case PropertyType.icon:
              final name = values['value'].split('.').last;
              value = icons.firstWhere((icon) => icon.name == name)?.iconData ??
                  null;
              break;
            default:
              value = values['value'];
          }
          widget.params[element.key] = value;
          if (widget.widgetType == FlutterWidgetType.CustomWidget) {
            if (!values['isFinal']) {
              attachModifiers(widget, key);
            }
          }
        }
        if (values['inherit'] != null) {
          _inheritDataMap[map['key']] = {key: values['inherit']};
        }
      });
    });
    // widget.paramNameAndTypes.forEach((key, value) {});
    return widget;
  }

  /// Replaces an existing node identified by specified key with a new node.
  /// It returns a new controller with the updated node replaced. This method
  /// expects the user to properly place this call so that the state is
  /// updated.
  ///
  /// See [WidgetModelController.updateNode] for info on optional parameters.
  ///
  /// ```dart
  /// setState((){
  ///   controller = controller.withUpdateNode(key, newNode);
  /// });
  /// ```
  WidgetModelController withUpdateNode(String key, ModelWidget newNode,
      {ModelWidget parent}) {
    List<ModelWidget> _data = updateNode(key, newNode, parent: parent);
    return WidgetModelController(
      children: _data,
      inheritDataMap: inheritDataMap,
    );
  }

  /// Gets the node that has a key value equal to the specified key.
  ModelWidget getNode(String key,
      {ModelWidget parent, List<ModelWidget> children}) {
    ModelWidget _found;
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
          _found = this.getNode(key, parent: child);
          if (_found != null) {
            break;
          }
        }
      }
    }
    return _found;
  }

  /// Gets the parent of the node identified by specified key.
  ModelWidget getParent(String key, {ModelWidget parent}) {
    ModelWidget _found;
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
          if (_found != null) {
            break;
          }
        }
      }
    }
    return _found;
  }

  /// Adds a new node to an existing node identified by specified key. It optionally
  // /// accepts an [InsertMode] and index. If no [InsertMode] is specified,
  // /// it appends the new node as a child at the end. This method returns
  // /// a new list with the added node.
  // List<ModelWidget> addNode(
  //   String key,
  //   ModelWidget newNode, {
  //   ModelWidget parent,
  //   InsertMode mode: InsertMode.append,
  //   int index,
  // }) {
  //   List<ModelWidget> _children =
  //       parent == null ? this.children : parent.children;
  //   return _children.map((ModelWidget child) {
  //     if (child.key == key) {
  //       List<ModelWidget> _children = child.children.toList(growable: true);
  //       if (mode == InsertMode.prepend) {
  //         _children.insert(0, newNode);
  //       } else if (mode == InsertMode.insert) {
  //         _children.insert(index ?? _children.length, newNode);
  //       } else {
  //         _children.add(newNode);
  //       }
  //       return child.copyWith(children: _children);
  //     } else {
  //       return child.copyWith(
  //         children: addNode(
  //           key,
  //           newNode,
  //           parent: child,
  //           mode: mode,
  //           index: index,
  //         ),
  //       );
  //     }
  //   }).toList();
  // }

  /// Updates an existing node identified by specified key. This method
  /// returns a new list with the updated node.
  List<ModelWidget> updateNode(String key, ModelWidget newNode,
      {ModelWidget parent}) {
    List<ModelWidget> _children =
        parent == null ? this.children : parent.children;
    final treeData = _children.map((ModelWidget child) {
      return newNode;
      // if (child.key == key) {
      //   return newNode;
      // } else {
      //   if (child.isParent) {
      //     return child.copyWith(
      //       children: updateNode(
      //         key,
      //         newNode,
      //         parent: child,
      //       ),
      //     );
      //   }
      //   return child;
      // }
    }).toList();
    _resolveInheritData(treeData, inheritDataMap);
    return treeData;
  }

  // /// Deletes an existing node identified by specified key. This method
  // /// returns a new list with the specified node removed.
  // List<ModelWidget> deleteNode(String key, {ModelWidget parent}) {
  //   List<ModelWidget> _children =
  //       parent == null ? this.children : parent.children;
  //   List<ModelWidget> _filteredChildren = [];
  //   Iterator iter = _children.iterator;
  //   while (iter.moveNext()) {
  //     ModelWidget child = iter.current;
  //     if (child.key != key) {
  //       if (child.isParent) {
  //         _filteredChildren.add(child.copyWith(
  //           children: deleteNode(key, parent: child),
  //         ));
  //       } else {
  //         _filteredChildren.add(child);
  //       }
  //     }
  //   }
  //   return _filteredChildren;
  // }

  // /// Map representation of this object
  // List<Map<String, dynamic>> get asMap {
  //   return children.map((ModelWidget child) => child.asMap).toList();
  // }

  // @override
  // String toString() {
  //   return jsonEncode(asMap);
  // }
}
