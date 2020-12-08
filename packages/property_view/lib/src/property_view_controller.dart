import 'dart:convert' show jsonDecode, jsonEncode;

import 'models/property_box.dart';

/// Defines the insertion mode adding a new [PropertyBox] to the [PropertyView].
enum InsertMode {
  prepend,
  append,
  insert,
}

/// Defines the controller needed to display the [PropertyView].
///
/// Used by [PropertyView] to display the nodes and selected node.
///
/// This class also defines methods used to manipulate data in
/// the [PropertyView]. The methods ([addPropertyBox], [updatePropertyBox],
/// and [deletePropertyBox]) are non-mutilating, meaning they will not
/// modify the tree but instead they will return a mutilated
/// copy of the data. You can then use your own logic to appropriately
/// update the [PropertyView]. e.g.
///
/// ```dart
/// PropertyViewController controller = PropertyViewController(children: nodes);
/// PropertyBox node = controller.getPropertyBox('unique_key');
/// PropertyBox updatedPropertyBox = node.copyWith(
///   key: 'another_unique_key',
///   label: 'Another PropertyBox',
/// );
/// List<PropertyBox> newChildren = controller.updatePropertyBox(node.key, updatedPropertyBox);
/// controller = PropertyViewController(children: newChildren);
/// ```
class PropertyViewController {
  /// The data for the [PropertyView].
  final List<PropertyBox> children;

  PropertyViewController({
    this.children: const [],
  });

  /// updateValue
  List<PropertyBox> updateDataValue(String key, dynamic value) {
    return children.map((PropertyBox child) {
      if (child.key == key) {
        return child.copyWith(value: value);
      } else {
        return child;
      }
    }).toList();
  }

  PropertyBox getPropertyBox(String key) {
    PropertyBox _property;
    Iterator iter = children.iterator;
    while (iter.moveNext()) {
      PropertyBox child = iter.current;
      if (child.key == key) {
        _property = child;
        break;
      }
    }
    return _property;
  }

  /// Creates a copy of this controller but with the given fields
  /// replaced with the new values.
  PropertyViewController copyWith({List<PropertyBox> children}) {
    return PropertyViewController(
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
  PropertyViewController loadJSON({String json: '[]'}) {
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
  PropertyViewController loadMap({List<Map<String, dynamic>> list: const []}) {
    List<PropertyBox> treeData = list
        .map((Map<String, dynamic> item) => PropertyBox.fromMap(item))
        .toList();
    return PropertyViewController(
      children: treeData,
    );
  }

  /// Map representation of this object
  List<Map<String, dynamic>> get asMap {
    return children.map((PropertyBox child) => child.asMap).toList();
  }

  @override
  String toString() {
    return jsonEncode(asMap);
  }
}
