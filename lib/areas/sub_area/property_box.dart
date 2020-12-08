import 'package:create_app/states/tree_view_state.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_hooks/flutter_hooks.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:create_app/states/property_view_state.dart';
import 'package:property_view/property_view.dart';

class PropertyBox extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _propertyViewController = useProvider(propertyViewController);
    return PropertyView(
      controller: _propertyViewController.controller,
      allowParentSelect: true,
      // supportParentDoubleTap: false,
      shrinkWrap: true,
      idleMessage: context.read(treeViewController).selectedKey == null
          ? 'Select a Node to Start Editing'
          : 'This node doesn\'t have any property for editing.',
      // primary: true,
      // onExpansionChanged: (key, expanded) => print(key),
      onPropertyActionComplete: (key, value) {
        _propertyViewController.updateValue(key, value);
      },
      // onNodeDoubleTap: (key) => print(key),
      // theme: _propertyViewController.state,
    );
  }
}
