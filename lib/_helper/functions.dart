import 'package:create_app/_utils/handle_keys.dart';
import 'package:flutter/widgets.dart';

Offset resetCanvasToCenter(BuildContext context, GlobalKey key) {
  final s = MediaQuery.of(context).size;
  final off = getCenterOffsetFromKey(key);
  return Offset(off.dx - s.width / 2, off.dy - s.height / 2);
}
