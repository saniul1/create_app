import 'package:create_app/_utils/resolve_inherit_data.dart';
import 'package:create_app/states/tree_view_state.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/widgets.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_treeview/tree_view.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:create_app/states/app_view_state.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:widget_models/widget_models.dart';

final appBuildController = ChangeNotifierProvider<AppBuilderNotifier>(
    (ref) => AppBuilderNotifier(ref));

class AppBuilderNotifier extends ChangeNotifier {
  final ProviderReference _ref;
  AppBuilderNotifier(ref) : _ref = ref;
  WidgetModelController _controller = WidgetModelController();
  WidgetModelController get controller => _controller;

  buildApps() {
    final tree = _ref.read(treeViewController).controller;
    _ref.read(appViewList).list.forEach((app) {
      Node? node = tree.getNode(app.node);
      // ignore: unnecessary_null_comparison
      _controller = _controller.loadMap(list: node != null ? [node.asMap] : []);
    });
    notifyListeners();
  }

  buildWidgetTree(Node node) {}

  dynamic? resolveWidgetModelPropertyData(
      String key, PropertyType type, String args) {
    final tree = _ref.read(treeViewController);
    final parent = getParentCustomWidget(key);
    switch (type) {
      case PropertyType.function:
        var arg = args.split('+');
        final data = tree.controller.getNode(parent.key).data;
        return () {
          var val = (data[arg.first]['value']);
          tree.updateNodeData({'${parent.key}.${arg.first}': val++}, val++);
        };
      default:
        return null;
    }
  }

  ModelWidget getParentCustomWidget(String key) {
    final parent = _controller.getParent(key);
    // print(parent.widgetType);
    if (parent.widgetType != FlutterWidgetType.CustomWidget)
      return getParentCustomWidget(parent.key);
    else
      return parent;
  }
}
