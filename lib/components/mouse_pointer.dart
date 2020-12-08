import 'package:flutter/widgets.dart';

class MousePointer extends CustomPainter {
  MousePointer({this.color});
  final Color? color;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    paint.color = color ?? Color(0xffffffff);
    path = Path();
    path.lineTo(size.width, size.height * 0.67);
    path.cubicTo(size.width, size.height * 0.67, size.width * 1.22, size.height,
        size.width * 1.22, size.height);
    path.cubicTo(size.width * 1.22, size.height, size.width * 1.02,
        size.height * 1.06, size.width * 1.02, size.height * 1.06);
    path.cubicTo(size.width * 1.02, size.height * 1.06, size.width * 0.79,
        size.height * 0.72, size.width * 0.79, size.height * 0.72);
    path.cubicTo(size.width * 0.79, size.height * 0.72, size.width * 0.46,
        size.height * 0.93, size.width * 0.46, size.height * 0.93);
    path.cubicTo(size.width * 0.46, size.height * 0.93, size.width * 0.46,
        size.height * 0.06, size.width * 0.46, size.height * 0.06);
    path.cubicTo(size.width * 0.46, size.height * 0.06, size.width * 1.46,
        size.height * 0.67, size.width * 1.46, size.height * 0.67);
    path.cubicTo(size.width * 1.46, size.height * 0.67, size.width,
        size.height * 0.67, size.width, size.height * 0.67);
    path.cubicTo(size.width, size.height * 0.67, size.width, size.height * 0.67,
        size.width, size.height * 0.67);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
