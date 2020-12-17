import 'package:create_app/views/editor.dart';
import 'package:flutter/material.dart';
import 'package:create_app/_utils/handle_keys.dart';
import 'package:create_app/modals/add_widget_modal.dart';
import 'package:create_app/modals/main_menu_modal.dart';

Widget handleModals(
    String? id, GlobalKey key, void Function() onActionComplete) {
  if (id != null) {
    final pos = getPositionFromKey(key);
    final size = getSizeFromKey(key);
    if (pos != null && size != null) {
      final offset = Offset(pos.dx, pos.dy - Editor.paddingTop);
      switch (id) {
        case MainMenuModal.id:
          return MainMenuModal(
              offset + Offset(0, size.height + 8), onActionComplete);
        case AddWidgetModal.id:
          return AddWidgetModal(offset, onActionComplete);
      }
    }
  }
  return SizedBox();
}
