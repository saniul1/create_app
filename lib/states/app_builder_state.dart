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

  dynamic? resolveWidgetModelPropertyData(
      String key, PropertyType type, String args) {
    final parent = getParentCustomWidget(key);
    switch (type) {
      case PropertyType.function:
        var arg = args.split('+');
        return () {
          var val = (parent.params[arg.first]);
          updateNodeData('${parent.key}.${arg.first}', val + 1);
        };
      default:
        return null;
    }
  }

  void updateNodeData(String keys, value) {
    final k = keys.split('.');
    final node = _controller.getNode(k.first);
    node.params[k.last] = value;
    _controller = WidgetModelController(
      children: _controller.updateNode(k.first, node),
      inheritDataMap: _controller.inheritDataMap,
    );
    // print(_controller.children.first.params);
    notifyListeners();
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
