import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_treeview/src/tree_node.dart';
import 'package:flutter_treeview/src/utilities.dart';
import 'package:flutter_treeview/tree_view.dart';

import 'node_icon.dart';

/// Defines the data used to display a [TreeNode].
///
/// Used by [TreeView] to display a [TreeNode].
///
/// This object allows the creation of key, label and icon to display
/// a node on the [TreeView] widget. The key and label properties are
/// required. The key is needed for events that occur on the generated
/// [TreeNode]. It should always be unique.
class Node {
  /// The unique string that identifies this object.
  final String key;

  /// The string value that is displayed on the [TreeNode].
  final String label;

  /// The open or closed state of the [TreeNode]. Applicable only if the
  /// node is a parent
  final bool expanded;

  /// Generic data model that can be assigned to the [TreeNode]. This makes
  /// it useful to assign and retrieve data associated with the [TreeNode]
  final Map data;

  /// The sub [Node]s of this object.
  final List<Node> children;

  final String group;

  /// type of [Node]. holds string representation of a enum value
  final String type;

  Node({
    @required this.key,
    @required this.label,
    @required this.type,
    this.children: const [],
    this.group = 'child',
    this.expanded: true,
    this.data = const {},
  })  : assert(key != null),
        assert(type != null),
        assert(label != null);

  /// Creates a [Node] from a string value. It generates a unique key.
  factory Node.fromLabel(String label) {
    String _key = Utilities.generateRandom();
    return Node(
      key: '${_key}_$label',
      label: label,
      type: '',
    );
  }

  /// Creates a [Node] from a Map<String, dynamic> map. The map
  /// should contain a "label" value. If the key value is
  /// missing, it generates a unique key.
  /// If the expanded value, if present, can be any 'truthful'
  /// value. Excepted values include: 1, yes, true and their
  /// associated string values.
  factory Node.fromMap(Map<String, dynamic> map) {
    String _key = map['key'];
    String _label = map['label'];
    var _data = map['data'];
    var _type = map['type'];
    var _group = map['group'];
    List<Node> _children = [];
    if (_key == null) {
      _key = Utilities.generateRandom();
    }
    if (map['children'] != null) {
      List<Map<String, dynamic>> _childrenMap = List.from(map['children']);
      _children = _childrenMap
          .map((Map<String, dynamic> child) => Node.fromMap(child))
          .toList();
    }
    return Node(
      key: '$_key',
      label: _label,
      data: _data,
      type: _type,
      group: _group,
      children: _children,
    );
  }

  /// Creates a copy of this object but with the given fields
  /// replaced with the new values.
  Node copyWith({
    String key,
    String label,
    String type,
    String group,
    List<Node> children,
    List actions,
    bool expanded,
    NodeIcon icon,
    Map data,
  }) =>
      Node(
        key: key ?? this.key,
        label: label ?? this.label,
        type: type ?? this.type,
        group: group ?? this.group,
        children: children ?? this.children,
        data: data ?? this.data,
        expanded: expanded ?? this.expanded,
      );

  /// Whether this object has children [Node].
  bool get isParent => children.isNotEmpty;

  /// Whether this object has data associated with it.
  bool get hasData => data != null;

  /// Map representation of this object
  Map<String, dynamic> get asMap {
    Map<String, dynamic> _map = {
      "key": key,
      "label": label,
      "type": type,
      "group": group,
      "data": data,
      "children": children.map((Node child) => child.asMap).toList(),
    };
    //TODO: figure out a means to check for getter or method on generic to include map from generic
    return _map;
  }

  @override
  String toString() {
    return JsonEncoder().convert(asMap);
  }

  @override
  int get hashCode {
    return hashValues(
      key,
      label,
      type,
      group,
      expanded,
      children,
      group,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is Node &&
        other.key == key &&
        other.label == label &&
        other.type == type &&
        other.group == group &&
        other.data.runtimeType == Map &&
        other.children.length == children.length;
  }
}
