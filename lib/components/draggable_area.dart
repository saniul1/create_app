import 'package:flutter/material.dart';

class EditorLayoutDragArea extends StatelessWidget {
  const EditorLayoutDragArea({
    Key? key,
    required this.title,
    required this.id,
    required this.width,
  }) : super(key: key);

  final String title;
  final String id;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Draggable(
      data: id,
      feedback: Container(
        width: width,
        color: Colors.grey.withOpacity(0.2),
        padding: const EdgeInsets.all(10.0),
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
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(color: Colors.grey.shade600),
              ),
            ),
            Icon(
              Icons.drag_handle,
              color: Colors.grey.shade600,
            )
          ],
        ),
      ),
      childWhenDragging: SizedBox(
        height: 60,
      ),
    );
  }
}
