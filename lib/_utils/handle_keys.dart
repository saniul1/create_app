import 'package:flutter/cupertino.dart';

Offset? getPositionFromKey(GlobalKey key) {
  final RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
  return box?.localToGlobal(Offset.zero);
}

Size? getSizeFromKey(GlobalKey key) {
  final RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
  return box?.size;
}

Offset getCenterOffsetFromKey(GlobalKey key) {
  final size = getSizeFromKey(key);
  final pos = getPositionFromKey(key);
  if (pos != null && size != null)
    return Offset(pos.dx + size.width / 2, pos.dy + size.height / 2);
  else
    return Offset.zero;
}
