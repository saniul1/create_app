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
  WidgetModelController _controller = WidgetModelController(inheritDataMap: {});
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

  void resolveWidgetModelPropertyData(
      String key, PropertyType type, dynamic args) {
    if (args.runtimeType.toString() == 'List<dynamic>') {
      for (var arg in args) {
        final map = Map<String, dynamic>.from(arg);
        final parent = getParentCustomWidget(map.keys.first);
        if (parent != null)
          parent.modifiers[map.values.first.keys.first]
                  [map.values.first.values.first['action']](
              map.values.first.values.first['value'],
              map.values.first.values.first['condition']);
        // do it once by checking the hight parent
        updateNodeData(map.keys.first);
      }
    }
  }

  void updateNodeData(String key) {
    final node = _controller.getNode(key);
    if (node != null)
      _controller = WidgetModelController(
        children: _controller.updateNode(key, node),
        inheritDataMap: _controller.inheritDataMap,
      );
    // print(_controller.children.first.params);
    notifyListeners();
  }

  ModelWidget? getParentCustomWidget(String key) {
    final parent = _controller.getParent(key);
    // print(parent.widgetType);
    if (parent != null && parent.widgetType != FlutterWidgetType.CustomWidget)
      return getParentCustomWidget(parent.key);
    else
      return parent;
  }
}
