import 'package:create_app/modals/handle_modals.dart';
import 'package:create_app/modals/main_menu_modal.dart';
import 'package:create_app/states/tools_state.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_hooks/flutter_hooks.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:create_app/components/app_icon_button.dart';

import 'package:create_app/states/sizes.dart';

import 'package:create_app/states/modal_states.dart';

class MenuBar extends HookWidget {
  final _menuBtnKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final iconSize = context.read(iconButtonSize);
    final selectTool = useProvider(selectedTool);
    final _currentModal = useProvider(currentModalNotifier);
    return Container(
      constraints: BoxConstraints(minWidth: 80),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(50)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIconButton(
              key: _menuBtnKey,
              info: 'main menu',
              icon: Entypo.menu,
              size: iconSize + 4,
              onClick: () {
                _currentModal.setModal(handleModals(MainMenuModal.id,
                    _menuBtnKey, (_) => _currentModal.setModal(null)));
              },
            ),
            AppIconButton(
              icon: Entypo.mouse_pointer,
              info: 'select',
              size: iconSize,
              color: selectTool.state == ToolType.select
                  ? Theme.of(context).primaryColor
                  // ignore: null_check_always_fails
                  : null,
              onClick: () => selectTool.state =
                  selectTool.state == ToolType.select
                      ? ToolType.none
                      : ToolType.select,
            ),
            AppIconButton(
              icon: Entypo.level_up,
              info: 'undo',
              size: iconSize,
              onClick: () {},
            ),
            AppIconButton(
              icon: Entypo.level_down,
              info: 'redo',
              size: iconSize,
              onClick: () {},
            ),
            AppIconButton(
              icon: Entypo.cog,
              info: 'settings',
              size: iconSize,
              onClick: () {},
            ),
            AppIconButton(
              icon: Entypo.help,
              info: 'help',
              size: iconSize,
              onClick: () {},
            ),
          ],
        ),
      ),
    );
  }
}
