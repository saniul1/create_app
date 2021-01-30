import 'package:create_app/states/app_builder_state.dart';
import 'package:create_app/states/tree_view_state.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:enum_to_string/camel_case_to_words.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:uuid/uuid.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_treeview/tree_view.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:property_view/property_view.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:widget_models/widget_models.dart';
import 'package:better_print/better_print.dart';

final propertyViewController = ChangeNotifierProvider<PropertyViewNotifier>(
    (ref) => PropertyViewNotifier(ref));

class PropertyViewNotifier extends ChangeNotifier {
  final ProviderReference _ref;
  PropertyViewNotifier(ref) : _ref = ref;
  PropertyViewController _controller = PropertyViewController();
  late Node _node;
  PropertyViewController get controller => _controller;
  final uuid = Uuid();

  void notify() {
    notifyListeners();
  }

  setPropertyView() {
    _node = _ref.read(treeViewController).controller.selectedNode;
    final ModelWidget? widget =
        _ref.read(appBuildController).getModel(_node.key) ??
            _ref.read(appBuildController).rootController.getModel(_node.key);
    if (widget != null) {
      final propertyList = widget.paramNameAndTypes.entries.map((param) {
        var _isInit = true;
        final data = widget.params.entries
            .firstWhere((element) => element.key == param.key, orElse: () {
          _isInit = false;
          return {param.key: widget.defaultParamsValues[param.key]}
              .entries
              .first;
        });
        final type = widget.paramTypes[data.key] ?? param.value.first;
        // Console.print('${data.key}: ${data.value}, type: $type').show();
        // Console.print(types).show();
        final value = data.value != null
            ? type == PropertyType.icon
                ? materialIconsList
                    .firstWhere((e) => e.iconData == data.value)
                    .name
                : data.value
            : null;
        return PropertyBox(
          key: '${widget.key}.${data.key}',
          label: data.key,
          value: value,
          type: type,
          acceptedTypes: param.value,
          isInitialized: _isInit,
        );
      }).toList();
      _controller = PropertyViewController(children: propertyList);
      notifyListeners();
    }
  }

  initializeValue(String key) {
    _controller = PropertyViewController(
      children: _controller.initializeValue(key),
    );
    final Map<String, dynamic>? data = _controller.getPropertyBox(key)?.asMap;
    if (data != null) _ref.read(treeViewController).initializeNodeData(data);
    notifyListeners();
  }

  updateValue(String key, dynamic value) {
    _controller = PropertyViewController(
      children: _controller.updateDataValue(key, value),
    );
    final Map<String, dynamic>? data = _controller.getPropertyBox(key)?.asMap;
    if (data != null)
      _ref.read(treeViewController).updateNodeData(
            data,
            value,
          );
    notifyListeners();
  }
}
