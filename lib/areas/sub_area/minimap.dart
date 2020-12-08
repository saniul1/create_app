import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class MiniMap extends StatelessWidget {
  final ui.Image? image;

  const MiniMap({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (image != null)
      return Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.shade400),
          color: Colors.grey.shade200,
        ),
        width: (image?.width.toDouble() ?? 0) / 15,
        height: (image?.height.toDouble() ?? 0) / 15,
        // constraints: BoxConstraints(maxHeight: 200),
        child: CustomPaint(
          painter: _UIImagePainter(image!),
        ),
      );
    return SizedBox();
  }
}

class _UIImagePainter extends CustomPainter {
  final ui.Image image;

  _UIImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );
  }

  @override
  bool shouldRepaint(_UIImagePainter oldDelegate) {
    return image != oldDelegate.image;
  }
}
