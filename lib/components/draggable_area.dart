import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class EditorLayoutDragArea extends StatelessWidget {
  const EditorLayoutDragArea({
    Key? key,
    required this.title,
    required this.id,
    required this.width,
    this.actions = const [],
  }) : super(key: key);

  final String title;
  final String id;
  final double width;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Draggable(
      data: id,
      feedback: Container(
        width: width,
        color: Colors.grey.withOpacity(0.2),
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .subtitle1
              ?.copyWith(color: Colors.grey.shade600),
        ),
      ),
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(color: Colors.grey.shade600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  ...actions,
                  Icon(
                    Entypo.copy,
                    color: Colors.grey.shade500,
                    size: 18,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      childWhenDragging: SizedBox(
        height: 32,
      ),
    );
  }
}
