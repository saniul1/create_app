import 'package:create_app/modals/add_widget_modal.dart';
import 'package:create_app/states/app_builder_state.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_hooks/flutter_hooks.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_treeview/tree_view.dart';
import 'package:create_app/states/modal_states.dart';

import 'package:create_app/themes/tree_view_theme.dart';
import 'package:create_app/states/tree_view_state.dart';
import 'package:widget_models/widget_models.dart';

class TreeNodes extends HookWidget {
  final addKey = GlobalKey();
  final deleteKey = GlobalKey();
  final moreKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final _treeViewController = useProvider(treeViewController);
    final _treeViewTheme = useProvider(treeViewTheme);
    final _currentModalKey = useProvider(currentModalKey);
    final _isAddable = useState(false);
    final _shadowKey = useState<String?>(null);
    return TreeView(
      controller: _treeViewController.controller,
      shadowKey: _shadowKey.value,
      allowParentSelect: true,
      // supportParentDoubleTap: false,
      shrinkWrap: true,
      // primary: true,
      // onExpansionChanged: (key, expanded) => print(key),
      onNodeTap: (key) => _treeViewController.selectNode(key),
      // onNodeDoubleTap: (key) => print(key),
      onHover: (String key) {
        final model = context.read(appBuildController).controller.getModel(key);
        if (model != null) {
          int i = 0;
          model.childGroups.forEach((e) {
            e.childCount < 0 ? i = -1 : i += e.childCount;
          });
          _isAddable.value = i < 0 || model.children.length < i ? true : false;
        } else {
          _isAddable.value = false;
        }
      },
      theme: _treeViewTheme.state,
      buildNodeIcon: (groupe, size) {
        return Icon(
          Icons.ac_unit,
          size: size.width,
        );
      },
      buildActionsWidgets: (key, size) {
        return [
          // if (_isAddable.value)
          ActionButton(addKey, Icons.add, size, () {
            _shadowKey.value = key;
            _currentModalKey.setKey(AddWidgetModal.id, addKey, () {
              _shadowKey.value = null;
              _currentModalKey.setKey(null, GlobalKey(), () {});
            });
            // _treeViewController.addNode(key, '', '');
          }),
          ActionButton(deleteKey, Icons.delete, size, () {
            _treeViewController.deleteNode(key);
          }),
          ActionButton(
            moreKey,
            Icons.more_vert,
            size,
          ),
        ];
      },
    );
  }
}

class ActionButton extends StatelessWidget {
  ActionButton(Key key, this.icon, this.size, [this.action]) : super(key: key);
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
