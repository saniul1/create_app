import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_hooks/flutter_hooks.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_treeview/tree_view.dart';

import 'package:create_app/themes/tree_view_theme.dart';
import 'package:create_app/states/tree_view_state.dart';

class TreeNodes extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _treeViewController = useProvider(treeViewController);
    final _treeViewTheme = useProvider(treeViewTheme);
    return TreeView(
      controller: _treeViewController.controller,
      allowParentSelect: true,
      // supportParentDoubleTap: false,
      shrinkWrap: true,
      // primary: true,
      // onExpansionChanged: (key, expanded) => print(key),
      onNodeTap: (key) => _treeViewController.selectNode(key),
      // onNodeDoubleTap: (key) => print(key),
      theme: _treeViewTheme.state,
      buildActionsWidgets: (key, size) {
        return [
          ActionButton(Icons.add, size, () {
            _treeViewController.addNode(key, '', '');
          }),
          ActionButton(Icons.delete, size, () {
            _treeViewController.deleteNode(key);
          }),
          ActionButton(
            Icons.more_vert,
            size,
          ),
        ];
      },
    );
  }
}

class ActionButton extends StatelessWidget {
  ActionButton(this.icon, this.size, [this.action]);
  final IconData icon;
  final void Function()? action;
  final Size size;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action,
        hoverColor: Colors.white,
        child: Icon(icon, size: size.height * 4 - 4),
      ),
    );
  }
}
