import 'dart:math';
import 'package:create_app/_utils/handle_assets.dart';
import 'package:create_app/models/app_view_model.dart';
import 'package:create_app/states/app_builder_state.dart';
import 'package:create_app/states/app_view_state.dart';
import 'package:create_app/states/property_view_state.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_treeview/tree_view.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:better_print/better_print.dart';
import 'file_storage_state.dart';

final treeViewController =
    ChangeNotifierProvider((ref) => TreeViewNotifier(ref));

class TreeViewNotifier extends ChangeNotifier {
  final ProviderReference _ref;
  TreeViewNotifier(ref) : _ref = ref;
  TreeViewController _controller = TreeViewController();
  String? _selectedKey;
  String? get selectedKey => _selectedKey;
  TreeViewController get controller => _controller;

  void loadTreeFromJson(String json) {
    _controller = _controller.loadJSON(json: json);
    selectNode(_controller.children.first.key);
    showApp();
    setPropertyView();
    notifyListeners();
  }

  void selectNode(String key) {
    _selectedKey = key;
    _controller = _controller.copyWith(selectedKey: key);
    setPropertyView();
    notifyListeners();
  }

  void showApp() {
    _ref.read(appViewList).adAll(
      [
        AppViewModel(
          id: 'app-2',
          offset: Offset(0, 0),
          node: 'my_app',
        ),
      ],
    );
  }

  void updateNodeData(Map<String, dynamic> data, value) {
    final keys = data.keys.first.split('.');
    final node = _controller.getNode(keys.first);
    Console.print(node.data[keys.last]).show();
    node.data[keys.last]['value'] = value;
    _controller = TreeViewController(
      selectedKey: _selectedKey,
      children: _controller.updateNode(keys.first, node),
    );
    _buildApps();
  }

  void deleteNode(String key) {
    _controller = TreeViewController(
        children: _controller.deleteNode(key), selectedKey: _selectedKey);
    _buildApps();
    notifyListeners();
  }

  int getChildNodeIndex(
    String key,
  ) {
    final parent = _controller.getParent(key);
    return parent.children.indexWhere((element) => element.key == key);
  }

  void replaceNode(String key, Map<String, dynamic> map) {
    final parent = _controller.getParent(key);
    final i = getChildNodeIndex(key);
    addNode(parent.key, map, InsertMode.replace, i);
  }

  void addNode(String key, Map<String, dynamic> map,
      [InsertMode mode = InsertMode.insert, int? index]) {
    final node = Node.fromMap(map);
    // Console.print(node).show();
    _controller = TreeViewController(
        selectedKey: _selectedKey,
        children: _controller.addNode(key, node, mode: mode, index: index));
    expandNode(key);
  }

  void expandNode(key) {
    _controller = TreeViewController(
        selectedKey: _selectedKey, children: _controller.expandToNode(key));
    _buildApps();
    notifyListeners();
  }

  void setPropertyView() {
    _ref.read(propertyViewController).setPropertyView();
  }

  _buildApps() {
    _ref.read(appBuildController).buildApps();
  }
}

final nodeMap = FutureProvider<bool?>((ref) async {
  final result = await ref.read(fileStorage).tryLastOpened();
  if (result) await ref.read(fileStorage).loadCurrentFile();
  return result;
});
