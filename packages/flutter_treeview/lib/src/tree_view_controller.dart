import 'dart:convert' show jsonDecode, jsonEncode;

import 'models/node.dart';

/// Defines the insertion mode adding a new [Node] to the [TreeView].
enum InsertMode { prepend, append, insert, replace, changeParent }

/// Defines the controller needed to display the [TreeView].
///
/// Used by [TreeView] to display the nodes and selected node.
///
/// This class also defines methods used to manipulate data in
/// the [TreeView]. The methods ([addNode], [updateNode],
/// and [deleteNode]) are non-mutilating, meaning they will not
/// modify the tree but instead they will return a mutilated
/// copy of the data. You can then use your own logic to appropriately
/// update the [TreeView]. e.g.
///
/// ```dart
/// TreeViewController controller = TreeViewController(children: nodes);
/// Node node = controller.getNode('unique_key');
/// Node updatedNode = node.copyWith(
///   key: 'another_unique_key',
///   label: 'Another Node',
/// );
/// List<Node> newChildren = controller.updateNode(node.key, updatedNode);
/// controller = TreeViewController(children: newChildren);
/// ```
class TreeViewController {
  /// The data for the [TreeView].
  final List<Node> children;

  /// The key of the select node in the [TreeView].
  final String selectedKey;

  TreeViewController({
    this.children: const [],
    this.selectedKey,
  });

  /// Creates a copy of this controller but with the given fields
  /// replaced with the new values.
  TreeViewController copyWith({List<Node> children, String selectedKey}) {
    return TreeViewController(
      children: children ?? this.children,
      selectedKey: selectedKey ?? this.selectedKey,
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
  TreeViewController loadJSON({String json: '[]', String selectKey}) {
    List jsonList = jsonDecode(json);
    List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(jsonList);
    return loadMap(map: list, selectKey: selectKey);
  }

  /// Loads this controller with data from a Map.
  /// This method expects the user to properly update the state
  ///
  /// ```dart
  /// setState((){
  ///   controller = controller.loadMap(map: dataMap);
  /// });
  /// ```
  TreeViewController loadMap(
      {List<Map<String, dynamic>> map: const [], String selectKey}) {
    List<Node> treeData =
        map.map((Map<String, dynamic> item) => Node.fromMap(item)).toList();
    return TreeViewController(
      children: treeData,
      selectedKey: selectKey ?? this.selectedKey,
    );
  }

  /// Adds a new node to an existing node identified by specified key.
  /// It returns a new controller with the new node added. This method
  /// expects the user to properly place this call so that the state is
  /// updated.
  ///
  /// See [TreeViewController.addNode] for info on optional parameters.
  ///
  /// ```dart
  /// setState((){
  ///   controller = controller.withAddNode(key, newNode);
  /// });
  /// ```
  TreeViewController withAddNode(
    String key,
    Node newNode, {
    Node parent,
    InsertMode mode: InsertMode.append,
    int index,
  }) {
    List<Node> _data =
        addNode(key, newNode, parent: parent, mode: mode, index: index);
    return TreeViewController(
      children: _data,
      selectedKey: this.selectedKey,
    );
  }

  /// Replaces an existing node identified by specified key with a new node.
  /// It returns a new controller with the updated node replaced. This method
  /// expects the user to properly place this call so that the state is
  /// updated.
  ///
  /// See [TreeViewController.updateNode] for info on optional parameters.
  ///
  /// ```dart
  /// setState((){
  ///   controller = controller.withUpdateNode(key, newNode);
  /// });
  /// ```
  TreeViewController withUpdateNode(String key, Node newNode, {Node parent}) {
    List<Node> _data = updateNode(key, newNode, parent: parent);
    return TreeViewController(
      children: _data,
      selectedKey: this.selectedKey,
    );
  }

  /// Removes an existing node identified by specified key.
  /// It returns a new controller with the node removed. This method
  /// expects the user to properly place this call so that the state is
  /// updated.
  ///
  /// See [TreeViewController.deleteNode] for info on optional parameters.
  ///
  /// ```dart
  /// setState((){
  ///   controller = controller.withDeleteNode(key);
  /// });
  /// ```
  TreeViewController withDeleteNode(String key, {Node parent}) {
    List<Node> _data = deleteNode(key, parent: parent);
    return TreeViewController(
      children: _data,
      selectedKey: this.selectedKey,
    );
  }

  /// Toggles the expanded property of an existing node identified by
  /// specified key. It returns a new controller with the node toggled.
  /// This method expects the user to properly place this call so
  /// that the state is updated.
  ///
  /// See [TreeViewController.toggleNode] for info on optional parameters.
  ///
  /// ```dart
  /// setState((){
  ///   controller = controller.withToggleNode(key, newNode);
  /// });
  /// ```
  TreeViewController withToggleNode(String key, {Node parent}) {
    List<Node> _data = toggleNode(key, parent: parent);
    return TreeViewController(
      children: _data,
      selectedKey: this.selectedKey,
    );
  }

  /// Expands all nodes down to Node identified by specified key.
  /// It returns a new controller with the nodes expanded.
  /// This method expects the user to properly place this call so
  /// that the state is updated.
  ///
  /// Internally uses [TreeViewController.expandToNode].
  ///
  /// ```dart
  /// setState((){
  ///   controller = controller.withExpandToNode(key, newNode);
  /// });
  /// ```
  TreeViewController withExpandToNode(String key, {Node parent}) {
    List<Node> _data = expandToNode(key);
    return TreeViewController(
      children: _data,
      selectedKey: this.selectedKey,
    );
  }

  /// Collapses all nodes down to Node identified by specified key.
  /// It returns a new controller with the nodes collapsed.
  /// This method expects the user to properly place this call so
  /// that the state is updated.
  ///
  /// Internally uses [TreeViewController.collapseToNode].
  ///
  /// ```dart
  /// setState((){
  ///   controller = controller.withCollapseToNode(key, newNode);
  /// });
  /// ```
  TreeViewController withCollapseToNode(String key, {Node parent}) {
    List<Node> _data = collapseToNode(key);
    return TreeViewController(
      children: _data,
      selectedKey: this.selectedKey,
    );
  }

  /// Gets the node that has a key value equal to the specified key.
  Node getNode(String key, {Node parent}) {
    Node _found;
    List<Node> _children = parent == null ? this.children : parent.children;
    Iterator iter = _children.iterator;
    while (iter.moveNext()) {
      Node child = iter.current;
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
  Node getParent(String key, {Node parent}) {
    Node _found;
    List<Node> _children = parent == null ? this.children : parent.children;
    Iterator iter = _children.iterator;
    while (iter.moveNext()) {
      Node child = iter.current;
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

  List<Node> reorderNode(String key, [isUp = true]) {
    final parent = getParent(key);
    final index = parent.children.indexWhere((element) => element.key == key);
    if (index >= 0) {
      final n = parent.children.removeAt(index);
      if (isUp) {
        parent.children.insert(index > 0 ? index - 1 : index, n);
      } else {
        parent.children
            .insert(parent.children.length == index ? index : index + 1, n);
      }
    }
    return this.children;
  }

  /// Expands a node and all of the node's ancestors so that the node is
  /// visible without the need to manually expand each node.
  List<Node> expandToNode(String key) {
    List<String> _ancestors = [];
    String _currentKey = key;

    _ancestors.add(_currentKey);

    Node _parent = this.getParent(_currentKey);
    while (_parent.key != _currentKey) {
      _currentKey = _parent.key;
      _ancestors.add(_currentKey);
      _parent = this.getParent(_currentKey);
    }
    TreeViewController _this = this;
    _ancestors.forEach((String k) {
      Node _node = _this.getNode(k);
      Node _updated = _node.copyWith(expanded: true);
      _this = _this.withUpdateNode(k, _updated);
    });
    return _this.children;
  }

  /// Collapses a node and all of the node's ancestors without the need to
  /// manually collapse each node.
  List<Node> collapseToNode(String key) {
    List<String> _ancestors = [];
    String _currentKey = key;

    _ancestors.add(_currentKey);

    Node _parent = this.getParent(_currentKey);
    while (_parent.key != _currentKey) {
      _currentKey = _parent.key;
      _ancestors.add(_currentKey);
      _parent = this.getParent(_currentKey);
    }
    TreeViewController _this = this;
    _ancestors.forEach((String k) {
      Node _node = _this.getNode(k);
      Node _updated = _node.copyWith(expanded: false);
      _this = _this.withUpdateNode(k, _updated);
    });
    return _this.children;
  }

  /// Adds a new node to an existing node identified by specified key. It optionally
  /// accepts an [InsertMode] and index. If no [InsertMode] is specified,
  /// it appends the new node as a child at the end. This method returns
  /// a new list with the added node.
  List<Node> addNode(
    String key,
    Node newNode, {
    Node parent,
    InsertMode mode: InsertMode.append,
    int index,
    String group,
  }) {
    List<Node> _children = parent == null ? this.children : parent.children;
    return _children.map((Node child) {
      if (child.key == key) {
        List<Node> _children = child.children.toList(growable: true);
        if (mode == InsertMode.prepend) {
          _children.insert(index ?? 0, newNode);
        } else if (mode == InsertMode.append) {
          _children.insert(
              index != null ? index + 1 : _children.length, newNode);
        } else if (mode == InsertMode.replace) {
          final children = _addChildrenFrom(_children[index ?? 0].key);
          _children.removeAt(index ?? 0);
          _children.insert(index ?? 0, newNode.copyWith(children: children));
        } else if (mode == InsertMode.changeParent) {
          final _child = _children[index ?? 0];
          _children.removeAt(index ?? 0);
          _children.insert(
              index ?? 0,
              newNode.copyWith(
                  children: [_child.copyWith(group: group ?? _child.group)]));
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
            group: group,
          ),
        );
      }
    }).toList();
  }

  List<Node> _addChildrenFrom(String key) {
    List<Node> _children = [];
    final children = getNode(key).children;
    children.forEach((child) {
      _children.add(child.copyWith(
        children: deleteNode(key, parent: child),
      ));
    });
    return _children;
  }

  /// Updates an existing node identified by specified key. This method
  /// returns a new list with the updated node.
  List<Node> updateNode(String key, Node newNode, {Node parent}) {
    List<Node> _children = parent == null ? this.children : parent.children;
    return _children.map((Node child) {
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

  /// Toggles an existing node identified by specified key. This method
  /// returns a new list with the specified node toggled.
  List<Node> toggleNode(String key, {Node parent}) {
    Node _node = getNode(key, parent: parent);
    return updateNode(key, _node.copyWith(expanded: !_node.expanded));
  }

  /// Deletes an existing node identified by specified key. This method
  /// returns a new list with the specified node removed.
  List<Node> deleteNode(
    String key, {
    Node parent,
    bool deleteChildren = false,
    String group,
  }) {
    List<Node> _children = parent == null ? this.children : parent.children;
    List<Node> _filteredChildren = [];
    Iterator iter = _children.iterator;
    while (iter.moveNext()) {
      Node child = iter.current;
      if (child.key != key) {
        if (child.isParent) {
          _filteredChildren.add(child.copyWith(
            children: deleteNode(key,
                parent: child, group: group, deleteChildren: deleteChildren),
          ));
        } else {
          _filteredChildren.add(child);
        }
      } else {
        if (!deleteChildren) {
          final children = getNode(key).children;
          children.forEach((child) {
            _filteredChildren.add(child.copyWith(
              group: group ?? child.group,
              children: deleteNode(key,
                  parent: child, group: group, deleteChildren: deleteChildren),
            ));
          });
        }
      }
    }
    return _filteredChildren;
  }

  /// Get the current selected node. Returns null if there is no selectedKey
  Node get selectedNode {
    return this.selectedKey == null || this.selectedKey.isEmpty
        ? null
        : getNode(this.selectedKey);
  }

  /// Map representation of this object
  List<Map<String, dynamic>> get asMap {
    return children.map((Node child) => child.asMap).toList();
  }

  @override
  String toString() {
    return jsonEncode(asMap);
  }
}
