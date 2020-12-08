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

final propertyViewController = ChangeNotifierProvider<PropertyViewNotifier>(
    (ref) => PropertyViewNotifier(ref));

class PropertyViewNotifier extends ChangeNotifier {
  final ProviderReference _ref;
  PropertyViewNotifier(ref) : _ref = ref;
  PropertyViewController _controller = PropertyViewController();
  late Node _node;
  PropertyViewController get controller => _controller;
  final uuid = Uuid();

  setPropertyView() {
    _node = _ref.read(treeViewController).controller.selectedNode;
    final ModelWidget? widget =
        _ref.read(appBuildController).controller.getNode(_node.key);
    if (widget != null) {
      final propertyList = widget.params.entries.map((data) {
        // print('${data.key}: ${data.value}');
        final type = widget.paramNameAndTypes.entries
            .firstWhere((element) => element.key == data.key)
            .value;
        return PropertyBox(
            key: '${widget.key}.${data.key}',
            label: data.key,
            value: data.value,
            type: type);
      }).toList();
      _controller = PropertyViewController(children: propertyList);
      notifyListeners();
    }
  }

  updateValue(String key, dynamic value) {
    _controller = PropertyViewController(
      children: _controller.updateDataValue(key, value),
    );
    _ref.read(treeViewController).updateNodeData(
          _controller.getPropertyBox(key).asMap,
          value,
        );
    notifyListeners();
  }
}
