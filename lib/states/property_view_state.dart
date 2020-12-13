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

  setPropertyView() {
    _node = _ref.read(treeViewController).controller.selectedNode;
    final ModelWidget? widget =
        _ref.read(appBuildController).controller.getNode(_node.key);
    if (widget != null) {
      final propertyList = widget.params.entries.map((data) {
        final types = widget.paramNameAndTypes.entries
            .firstWhere((element) => element.key == data.key)
            .value;
        final type = widget.paramTypes[data.key] ?? types.first;
        // Console.print('${data.key}: ${data.value}, type: $type').show();
        // Console.print(types).show();
        return PropertyBox(
          key: '${widget.key}.${data.key}',
          label: data.key,
          value: data.value,
          type: type,
          acceptedTypes: types,
        );
      }).toList();
      _controller = PropertyViewController(children: propertyList);
      notifyListeners();
    }
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
