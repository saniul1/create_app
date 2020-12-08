import 'package:flutter/material.dart';
import 'package:create_app/_utils/handle_keys.dart';
import 'package:create_app/areas/menu_bar.dart';
import 'main_menu_modal.dart';

Widget? handleModals(String id, GlobalKey? key) {
  if (key != null) {
    final pos = getPositionFromKey(key);
    final size = getSizeFromKey(key);
    if (id == MenuBar.id && pos != null && size != null) {
      final offset = Offset(pos.dx + size.width / 3, pos.dy + size.height);
      return MainMenuModal(offset);
    }
  }
  return null;
}
