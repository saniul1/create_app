import 'package:flutter/widgets.dart';
import '../property.dart';
import './types.dart';

/// Model Widget class
abstract class ModelWidget {
  late String key;

  /// Type of widget ([Text], [Center], [Column], etc)
  late FlutterWidgetType widgetType;

  /// Children of the widget
  late List<ModelWidget> children = [];

  bool get isParent => children.isNotEmpty;

  /// which property of parent it belongs to
  late String group;

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
  Map params = {};

  Map inheritData = {};

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

  ModelWidget copyWith({required List<ModelWidget> children}) {
    this.children = children;
    return this;
  }

  /// Converts current widget to code and returns as string
  String toCode();
}
