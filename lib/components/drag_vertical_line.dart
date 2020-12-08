import 'package:create_app/types/enums.dart';
import 'package:create_app/_utils/handle_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef DragCallback<T> = void Function(double dx);

class DragVerticalLine extends StatefulWidget {
  DragVerticalLine({
    required this.areaKey,
    required this.onDrag,
    required this.onTap,
    this.position = RelativePosition.end,
  });
  final GlobalKey areaKey;
  final DragCallback onDrag;
  final void Function() onTap;
  final RelativePosition position;
  @override
  DragVerticalLineState createState() => DragVerticalLineState();
}

class DragVerticalLineState extends State<DragVerticalLine> {
  bool isOnHover = false;
  double _width = 2.0;
  setWidth(double val) {
    setState(() {
      _width = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setWidth(2.0);
        widget.onTap();
      },
      onHorizontalDragUpdate: _width == 2
          ? (dt) {
              final dragPos = (dt.globalPosition.dx).round().toDouble();
              switch (widget.position) {
                case RelativePosition.start:
                  final pos = getPositionFromKey(widget.areaKey);
                  final size = getSizeFromKey(widget.areaKey);
                  final end =
                      pos != null && size != null ? pos.dx + size.width : 0;
                  if (end - dragPos < 50) setWidth(8);
                  widget.onDrag(end - dragPos);
                  break;
                case RelativePosition.end:
                  final pos = getPositionFromKey(widget.areaKey);
                  if (dragPos - (pos?.dx ?? 0) < 50) setWidth(8);
                  widget.onDrag(dragPos - (pos?.dx ?? 0));
                  break;
                default:
              }
              // print('${pos.dx}, $dragPos');
            }
          : null,
      child: MouseRegion(
        cursor: _width == 2
            ? SystemMouseCursors.resizeColumn
            : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => isOnHover = true),
        onExit: (_) => setState(() => isOnHover = false),
        child: Padding(
          padding: EdgeInsets.only(right: _width / 2),
          child: VerticalDivider(
            width: _width / 2,
            thickness: _width,
            color: isOnHover
                ? Theme.of(context).primaryColor
                : _width == 2
                    ? Colors.grey.shade300
                    : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}
