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
  Map<String, WidgetModelController> _controllers = {};
  Map<String, WidgetModelController> _rootControllers = {};
  WidgetModelController? controllerById(String id) {
    return _controllers[id];
  }

  void removeController(String id) {
    _controllers.removeWhere((key, value) => key == id);
  }

  buildRoots() {
    final tree = _ref.read(treeViewController).controller;
    final _ctrl = WidgetModelController(inheritDataMap: {});
    tree.children.forEach((node) {
      _rootControllers[node.key] =
          // ignore: unnecessary_null_comparison
          _ctrl.loadMap(list: node != null ? [node.asMap] : []);
    });
  }

  buildApps() {
    buildRoots();
    final tree = _ref.read(treeViewController).controller;
    _ref.read(appViewList).list.forEach((app) {
      Node? node = tree.getNode(app.node);
      if (!_controllers.containsKey(app.id))
        _controllers[app.id] = WidgetModelController(inheritDataMap: {});
      _controllers[app.id] =
          // ignore: unnecessary_null_comparison
          _controllers[app.id]!.loadMap(list: node != null ? [node.asMap] : []);
    });
    notifyListeners();
  }

  void resolveWidgetModelPropertyData(
      String key, PropertyType type, dynamic args) {
    if (args.runtimeType.toString() == 'List<dynamic>') {
      for (var arg in args) {
        _controllers.forEach((key, value) {
          final map = Map<String, dynamic>.from(arg);
          final parent = value.getModel(map.keys.first);
          if (parent != null) {
            parent.modifiers[map.values.first.keys.first]
                    [map.values.first.values.first['action']](
                map.values.first.values.first['value'],
                map.values.first.values.first['condition']);
            // do it once by checking the high parent
            updateNodeData(map.keys.first, key);
          }
        });
      }
    }
  }

  ModelWidget? getModelFromRoots(String id) {
    for (final key in _rootControllers.keys) {
      final model = _rootControllers[key]?.getModel(id);
      if (model != null) return model;
    }
    return null;
  }

  ModelWidget? getModel(String id) {
    for (final key in _controllers.keys) {
      final model = _controllers[key]?.getModel(id);
      if (model != null) return model;
    }
    return null;
  }

  WidgetModelController? getControllerByModelId(String id) {
    for (final key in _controllers.keys) {
      final model = _controllers[key]?.getModel(id);
      if (model != null) return _controllers[key];
    }
    return null;
  }

  String? getIdByModelId(String id) {
    for (final key in _controllers.keys) {
      final model = _controllers[key]?.getModel(id);
      if (model != null) return key;
    }
    return null;
  }

  void updateNodeData(String key, [String? id]) {
    final controllerId = id ?? getIdByModelId(key);
    final _controller = _controllers[controllerId];
    if (_controller != null) {
      final node = _controller.getModel(key);
      if (node != null)
        _controllers[controllerId!] = WidgetModelController(
          children: _controller.updateModel(key, node),
          inheritDataMap: _controller.inheritDataMap,
        );
    }
    // print(_controller.children.first.key);
    notifyListeners();
  }
}
