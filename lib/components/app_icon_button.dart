import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AppIconButton extends StatefulWidget {
  AppIconButton({Key? key, this.icon, this.onClick, this.size, this.color})
      : super(key: key);
  late final IconData? icon;
  late final Color? color;
  late final double? size;
  late final void Function()? onClick;
  @override
  _AppIconButtonState createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      // key: widget.key,
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
    );
  }
}
