import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AppIconButton extends StatefulWidget {
  AppIconButton(
      {Key? key,
      required this.icon,
      this.onClick,
      this.size,
      this.color,
      required this.info})
      : super(key: key);
  late final IconData? icon;
  late final Color? color;
  late final double? size;
  late final String info;
  late final void Function()? onClick;
  @override
  _AppIconButtonState createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      // key: widget.key,
      child: Tooltip(
        message: widget.info,
        child: InkWell(
          splashColor: Colors.black.withOpacity(0.08),
          highlightColor: Colors.transparent,
          customBorder: CircleBorder(),
          mouseCursor: SystemMouseCursors.basic,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(widget.icon, size: widget.size, color: widget.color),
          ),
          onTap: widget.onClick,
        ),
      ),
    );
  }
}
