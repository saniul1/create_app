import 'package:flutter/widgets.dart';
import '../property.dart';
import './types.dart';

/// Model Widget class
abstract class ModelWidget {
  String key;

  /// Type of widget ([Text], [Center], [Column], etc)
  FlutterWidgetType widgetType;

  /// Children of the widget
  List<ModelWidget> children = [];

  bool get isParent => children.isNotEmpty;

  /// The parent of the current widget
  ModelWidget parent;

  /// which property of parent it belongs to
  String group;

  /// How the widget fits into the tree
  /// [ParentType.End] is used for widgets that cannot have children
  /// [ParentType.SingleChild] and [ParentType.MultipleChildren] are self-explanatory
  ParentType parentType;

  /// Stores the names of all parameters and input types
  Map<String, List<PropertyType>> paramNameAndTypes = {};

  /// The parameter values of the widget
  /// Key is the parameter name and value is the value
  Map params = {};

  /// Denotes if the widget has any properties
  bool hasProperties;

  /// Denotes if the widget has any children
  bool hasChildren;

  /// This method takes the parameters and returns the actual widget to display
  Widget toWidget(Widget Function(Widget, String key) wrap, bool isSelectMode);

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

  copyWith({
    String key,
    String label,
    String type,
    List<ModelWidget> children,
    List actions,
    bool expanded,
    Map data,
  }) {
    // assert();
  }

  /// Get current values of all parameters of the widget model
  Map getParamValuesMap();

  /// Converts current widget to code and returns as string
  String toCode();
}
