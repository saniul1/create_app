import 'package:create_app/_utils/handle_keys.dart';
import 'package:create_app/modals/add_widget_modal.dart';
import 'package:create_app/modals/handle_modals.dart';
import 'package:create_app/modals/name_option.dart';
import 'package:create_app/modals/options_modal.dart';
import 'package:create_app/models/app_view_model.dart';
import 'package:create_app/states/app_builder_state.dart';
import 'package:create_app/states/app_view_state.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_hooks/flutter_hooks.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_treeview/tree_view.dart';
import 'package:create_app/states/modal_states.dart';
import 'package:uuid/uuid.dart';

import 'package:create_app/themes/tree_view_theme.dart';
import 'package:create_app/states/tree_view_state.dart';
import 'package:widget_models/widget_models.dart' hide InsertMode;
import 'package:better_print/better_print.dart';

class TreeNodes extends HookWidget {
  final addKey = GlobalKey();
  final addParentKey = GlobalKey();
  final replaceKey = GlobalKey();
  final deleteKey = GlobalKey();
  final moreKey = GlobalKey();
  final uuid = Uuid();
  @override
  Widget build(BuildContext context) {
    final _treeViewController = useProvider(treeViewController);
    final _treeViewTheme = useProvider(treeViewTheme);
    final _currentModal = useProvider(currentModalNotifier);
    final _isAddable = useState(false);
    final _isAddedToCanvas = useState(false);
    final _shadowKey = useState<String?>(null);
    void _selectWidgetModels(
        String key, GlobalKey gKey, String group, ModalSubActions actions,
        [InsertMode mode = InsertMode.insert, int? index]) {
      _shadowKey.value = key;
      _currentModal.setModal(
          handleModals(AddWidgetModal.id, gKey, (String type) {
            Map<String, dynamic>? model = getFlutterWidgetModelFromType(
                    uuid.v1(),
                    group,
                    EnumToString.fromString(FlutterWidgetType.values, type))
                ?.asMap;
            // Console.print(model?['data']['text']['value'].runtimeType)
            //     .show();
            context.read(treeViewController).addNode(key, model!, mode, index);
            _shadowKey.value = null;
            _currentModal.setModal(null);
          }),
          key,
          actions);
    }

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
        final _node = _treeViewController.controller.getNode(key);
        final model = getFlutterWidgetModelFromType(key, _node.group,
            EnumToString.fromString(FlutterWidgetType.values, _node.type));
        if (model != null) {
          int i = 0;
          model.childGroups.forEach((e) {
            e.childCount < 0 ? i = -1 : i += e.childCount;
          });
          _isAddable.value = i < 0 || _node.children.length < i ? true : false;
        } else {
          _isAddable.value = false;
        }
        _isAddedToCanvas.value = context
            .read(appViewList)
            .list
            .any((element) => element.node == _node.key);
      },
      theme: _treeViewTheme.state,
      buildNodeIcon: (groupe, size) {
        return Icon(
          Icons.ac_unit,
          size: size.width,
        );
      },
      buildActionsWidgets: (key, size) {
        final _node = _treeViewController.controller.getNode(key);
        final _model = getFlutterWidgetModelFromType(_node.key, _node.group,
            EnumToString.fromString(FlutterWidgetType.values, _node.type));
        if (_model != null)
          _node.children.forEach((el) {
            final _mdl = getFlutterWidgetModelFromType(el.key, el.group,
                EnumToString.fromString(FlutterWidgetType.values, el.type));
            if (_mdl != null) _model.addChild(_mdl);
            _model.resolveChildren(
                (_, key) => Container(), false, (key, type, args) {});
          });
        return _model != null
            ? [
                if (_model.type == FlutterWidgetType.CustomWidget)
                  Tooltip(
                    message: _isAddedToCanvas.value
                        ? 'Already in Canvas'
                        : 'Show in Canvas',
                    child: ActionButton(
                      GlobalKey(),
                      _isAddedToCanvas.value
                          ? Icons.important_devices
                          : Icons.devices_outlined,
                      size,
                      _isAddedToCanvas.value
                          ? () {
                              context.read(appViewList).remove(_node.key);
                              _isAddedToCanvas.value = !_isAddedToCanvas.value;
                            }
                          : () {
                              context.read(appViewList).add(
                                    AppViewModel(
                                      id: uuid.v1(),
                                      offset: Offset(0, 0),
                                      node: _node.key,
                                    ),
                                  );
                              _isAddedToCanvas.value = !_isAddedToCanvas.value;
                            },
                    ),
                  ),
                if (_isAddable.value)
                  Tooltip(
                    message: 'Add Node',
                    child: ActionButton(addKey, Icons.add, size, () {
                      final groups = _model.childGroups;
                      if (groups.length == 1)
                        _selectWidgetModels(
                          key,
                          addKey,
                          groups.first.name,
                          ModalSubActions.addChild,
                        );
                      else {
                        final ls = groups.map((e) => e.name).toList();
                        ls.removeWhere((el) =>
                            groups.where((g) => g.name == el).first.child !=
                            null);
                        _currentModal.setModal(
                          handleModals(OptionsModal.id, addKey, (String opt) {
                            _selectWidgetModels(
                              key,
                              addKey,
                              opt,
                              ModalSubActions.addChild,
                            );
                          }, ls),
                          key,
                        );
                      }
                    }),
                  ),
                Tooltip(
                  message: 'Change Parent Node',
                  child:
                      ActionButton(addParentKey, Icons.add_to_photos, size, () {
                    _shadowKey.value = key;
                    _currentModal.setModal(
                      handleModals(AddWidgetModal.id, addParentKey,
                          (String type) {
                        final model = getFlutterWidgetModelFromType(
                            uuid.v1(),
                            _model.parentGroup,
                            EnumToString.fromString(
                                FlutterWidgetType.values, type));
                        // Console.print(model?['data']['text']['value'].runtimeType)
                        //     .show();
                        if (model != null && model.childGroups.length == 1)
                          context.read(treeViewController).changeParent(
                              key, model.asMap, model.childGroups.first.name);
                        else
                          Console.print('resolve!').show(); //? resolve
                        _shadowKey.value = null;
                        _currentModal.setModal(null);
                      }),
                      key,
                      ModalSubActions.addParent,
                    );
                  }),
                ),
                Tooltip(
                  message: 'Replace Node',
                  child: ActionButton(replaceKey, Icons.find_replace, size, () {
                    _shadowKey.value = key;
                    _currentModal.setModal(
                      handleModals(AddWidgetModal.id, replaceKey,
                          (String type) {
                        Map<String, dynamic>? model =
                            getFlutterWidgetModelFromType(
                                    uuid.v1(),
                                    _model.parentGroup,
                                    EnumToString.fromString(
                                        FlutterWidgetType.values, type))
                                ?.asMap;
                        context
                            .read(treeViewController)
                            .replaceNode(key, model!);
                        _shadowKey.value = null;
                        _currentModal.setModal(null);
                      }),
                      key,
                      ModalSubActions.replace,
                    );
                  }),
                ),
                Tooltip(
                  message: 'Delete Node',
                  child: ActionButton(deleteKey, Icons.delete, size, () {
                    _treeViewController.deleteNode(key);
                  }),
                ),
                Tooltip(
                  message: 'More Options',
                  child: ActionButton(moreKey, Icons.more_vert, size, () {
                    final off = getPositionFromKey(moreKey) ?? Offset.zero;
                    _shadowKey.value = key;
                    _currentModal.setModal(
                      handleModals(OptionsModal.id, moreKey, (String opt) {
                        var _reset = true;
                        if (opt == 'Delete All') {
                          _treeViewController.deleteNode(key, true);
                        } else if (opt == 'rename') {
                          _reset = false;
                          _currentModal.setModal((NameOptionModal(off, (name) {
                            context.read(treeViewController).replaceNode(
                                key,
                                _model
                                    .coptWith(model: _model, name: name)
                                    .asMap);
                            _shadowKey.value = null;
                            context.read(currentModalNotifier).setModal(null);
                          }, _node.label)));
                        } else if (opt == 'copy') {
                        } else if (opt == 'move up') {
                          _treeViewController.moveUp(key);
                        } else if (opt == 'move down') {
                          _treeViewController.moveDown(key);
                        } else {
                          final i = context
                              .read(treeViewController)
                              .getChildNodeIndex(key);
                          final parentKey = context
                              .read(treeViewController)
                              .controller
                              .getParent(key)
                              .key;
                          if (opt == 'Insert Above') {
                            _selectWidgetModels(
                                parentKey,
                                moreKey,
                                'child',
                                ModalSubActions.addChild,
                                InsertMode.prepend,
                                i);
                          } else if (opt == 'Insert below') {
                            _selectWidgetModels(parentKey, moreKey, 'child',
                                ModalSubActions.addChild, InsertMode.append, i);
                          } else if (opt == 'Insert at Start') {
                            _selectWidgetModels(parentKey, moreKey, 'child',
                                ModalSubActions.addChild, InsertMode.prepend);
                          } else if (opt == 'Insert at End') {
                            _selectWidgetModels(
                              parentKey,
                              moreKey,
                              'child',
                              ModalSubActions.addChild,
                              InsertMode.append,
                            );
                          }
                        }
                        if (_reset) {
                          _shadowKey.value = null;
                          _currentModal.setModal(null);
                        }
                      }, [
                        'Delete All',
                        'rename',
                        'copy',
                        'paste replace',
                        'paste child',
                        'paste parent',
                        'swap with child',
                        'swap with parent',
                        'move up',
                        'move down',
                        'Insert at Start',
                        'Insert Above',
                        'Insert below',
                        'Insert at End'
                      ]),
                      key,
                    );
                  }),
                ),
              ]
            : [];
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
