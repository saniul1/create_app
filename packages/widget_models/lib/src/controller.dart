import 'dart:convert' show jsonDecode, jsonEncode;
import 'package:enum_to_string/enum_to_string.dart';
import 'flutter/model.dart';
import 'flutter/types.dart';
import 'flutter/widgets.dart';
import 'property.dart';
import 'property_helpers/colors_helper.dart';
import 'property_helpers/icons_helper.dart';
import 'utils/resolve_inherit_data.dart';

/// Defines the insertion mode adding a new [Node] to the [TreeView].
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
  WidgetModelController copyWith(
      {List<ModelWidget> children, String selectedKey}) {
    return WidgetModelController(
      children: children ?? this.children,
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
    return WidgetModelController(
      children: treeData,
    );
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
    _children.forEach((child) {
      widget.addChild(child);
    });
    map['data'].forEach((key, values) {
      widget.paramNameAndTypes.entries.forEach((element) {
        final type =
            EnumToString.fromString(PropertyType.values, values['type']);
        if (element.key == key && element.value.contains(type)) {
          // print('${element.key}: ${values['value']}');
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
          if (values['inherit'] != null)
            value = getValue(
                element.value.first, values['inherit'], values['value']);
          widget.params[element.key] = value;
        }
      });
    });
    widget.paramNameAndTypes.forEach((key, value) {});
    return widget;
  }

  /// Adds a new node to an existing node identified by specified key.
  /// It returns a new controller with the new node added. This method
  /// expects the user to properly place this call so that the state is
  /// updated.
  ///
  /// See [WidgetModelController.addNode] for info on optional parameters.
  ///
  /// ```dart
  /// setState((){
  ///   controller = controller.withAddNode(key, newNode);
  /// });
  /// ```
  WidgetModelController withAddNode(
    String key,
    ModelWidget newNode, {
    ModelWidget parent,
    InsertMode mode: InsertMode.append,
    int index,
  }) {
    List<ModelWidget> _data =
        addNode(key, newNode, parent: parent, mode: mode, index: index);
    return WidgetModelController(
      children: _data,
    );
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
    );
  }

  /// Removes an existing node identified by specified key.
  /// It returns a new controller with the node removed. This method
  /// expects the user to properly place this call so that the state is
  /// updated.
  ///
  /// See [WidgetModelController.deleteNode] for info on optional parameters.
  ///
  /// ```dart
  /// setState((){
  ///   controller = controller.withDeleteNode(key);
  /// });
  /// ```
  WidgetModelController withDeleteNode(String key, {ModelWidget parent}) {
    List<ModelWidget> _data = deleteNode(key, parent: parent);
    return WidgetModelController(
      children: _data,
    );
  }

  /// Expands all nodes down to ModelWidget identified by specified key.
  /// It returns a new controller with the nodes expanded.
  /// This method expects the user to properly place this call so
  /// that the state is updated.
  ///
  /// Internally uses [WidgetModelController.expandToNode].
  ///
  /// ```dart
  /// setState((){
  ///   controller = controller.withExpandToNode(key, newNode);
  /// });
  /// ```
  WidgetModelController withExpandToNode(String key, {ModelWidget parent}) {
    List<ModelWidget> _data = expandToNode(key);
    return WidgetModelController(
      children: _data,
    );
  }

  /// Collapses all nodes down to ModelWidget identified by specified key.
  /// It returns a new controller with the nodes collapsed.
  /// This method expects the user to properly place this call so
  /// that the state is updated.
  ///
  /// Internally uses [WidgetModelController.collapseToNode].
  ///
  /// ```dart
  /// setState((){
  ///   controller = controller.withCollapseToNode(key, newNode);
  /// });
  /// ```
  WidgetModelController withCollapseToNode(String key, {ModelWidget parent}) {
    List<ModelWidget> _data = collapseToNode(key);
    return WidgetModelController(
      children: _data,
    );
  }

  /// Gets the node that has a key value equal to the specified key.
  ModelWidget getNode(String key, {ModelWidget parent}) {
    ModelWidget _found;
    List<ModelWidget> _children =
        parent == null ? this.children : parent.children;
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

  /// Expands a node and all of the node's ancestors so that the node is
  /// visible without the need to manually expand each node.
  List<ModelWidget> expandToNode(String key) {
    List<String> _ancestors = [];
    String _currentKey = key;

    _ancestors.add(_currentKey);

    ModelWidget _parent = this.getParent(_currentKey);
    while (_parent.key != _currentKey) {
      _currentKey = _parent.key;
      _ancestors.add(_currentKey);
      _parent = this.getParent(_currentKey);
    }
    WidgetModelController _this = this;
    _ancestors.forEach((String k) {
      ModelWidget _widget = _this.getNode(k);
      ModelWidget _updated = _widget.copyWith(expanded: true);
      _this = _this.withUpdateNode(k, _updated);
    });
    return _this.children;
  }

  /// Collapses a node and all of the node's ancestors without the need to
  /// manually collapse each node.
  List<ModelWidget> collapseToNode(String key) {
    List<String> _ancestors = [];
    String _currentKey = key;

    _ancestors.add(_currentKey);

    ModelWidget _parent = this.getParent(_currentKey);
    while (_parent.key != _currentKey) {
      _currentKey = _parent.key;
      _ancestors.add(_currentKey);
      _parent = this.getParent(_currentKey);
    }
    WidgetModelController _this = this;
    _ancestors.forEach((String k) {
      ModelWidget _widget = _this.getNode(k);
      ModelWidget _updated = _widget.copyWith(expanded: false);
      _this = _this.withUpdateNode(k, _updated);
    });
    return _this.children;
  }

  /// Adds a new node to an existing node identified by specified key. It optionally
  /// accepts an [InsertMode] and index. If no [InsertMode] is specified,
  /// it appends the new node as a child at the end. This method returns
  /// a new list with the added node.
  List<ModelWidget> addNode(
    String key,
    ModelWidget newNode, {
    ModelWidget parent,
    InsertMode mode: InsertMode.append,
    int index,
  }) {
    List<ModelWidget> _children =
        parent == null ? this.children : parent.children;
    return _children.map((ModelWidget child) {
      if (child.key == key) {
        List<ModelWidget> _children = child.children.toList(growable: true);
        if (mode == InsertMode.prepend) {
          _children.insert(0, newNode);
        } else if (mode == InsertMode.insert) {
          _children.insert(index ?? _children.length, newNode);
        } else {
          _children.add(newNode);
        }
        return child.copyWith(children: _children);
      } else {
        return child.copyWith(
          children: addNode(
            key,
            newNode,
            parent: child,
            mode: mode,
            index: index,
          ),
        );
      }
    }).toList();
  }

  /// Updates an existing node identified by specified key. This method
  /// returns a new list with the updated node.
  List<ModelWidget> updateNode(String key, ModelWidget newNode,
      {ModelWidget parent}) {
    List<ModelWidget> _children =
        parent == null ? this.children : parent.children;
    return _children.map((ModelWidget child) {
      if (child.key == key) {
        return newNode;
      } else {
        if (child.isParent) {
          return child.copyWith(
            children: updateNode(
              key,
              newNode,
              parent: child,
            ),
          );
        }
        return child;
      }
    }).toList();
  }

  /// Deletes an existing node identified by specified key. This method
  /// returns a new list with the specified node removed.
  List<ModelWidget> deleteNode(String key, {ModelWidget parent}) {
    List<ModelWidget> _children =
        parent == null ? this.children : parent.children;
    List<ModelWidget> _filteredChildren = [];
    Iterator iter = _children.iterator;
    while (iter.moveNext()) {
      ModelWidget child = iter.current;
      if (child.key != key) {
        if (child.isParent) {
          _filteredChildren.add(child.copyWith(
            children: deleteNode(key, parent: child),
          ));
        } else {
          _filteredChildren.add(child);
        }
      }
    }
    return _filteredChildren;
  }

  // /// Map representation of this object
  // List<Map<String, dynamic>> get asMap {
  //   return children.map((ModelWidget child) => child.asMap).toList();
  // }

  // @override
  // String toString() {
  //   return jsonEncode(asMap);
  // }
}
