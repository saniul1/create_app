import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_hooks/flutter_hooks.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';

class EditorLayoutDragArea extends HookWidget {
  const EditorLayoutDragArea({
    Key? key,
    required this.title,
    this.titleOption,
    required this.id,
    required this.width,
    this.actions = const [],
    required this.onTap,
  }) : super(key: key);

  final String title;
  final List<String>? titleOption;
  final String id;
  final double width;
  final List<Widget> actions;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    final isCollapsed = useState(true);
    return Column(
      children: [
        Draggable(
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 6.0),
                  child: InkWell(
                    onTap: titleOption != null
                        ? () {
                            isCollapsed.value = !isCollapsed.value;
                          }
                        : null,
                    child: Row(
                      children: [
                        Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                        if (titleOption != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0, top: 4),
                            child: Icon(
                              isCollapsed.value
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              size: 15,
                              color: Colors.grey.shade600,
                            ),
                          )
                      ],
                    ),
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
        ),
        if (titleOption != null && !isCollapsed.value)
          ListView(
            shrinkWrap: true,
            children: titleOption
                    ?.map((e) => ListTile(
                          title: Text(e),
                          onTap: () => onTap(e),
                          tileColor: e == title
                              ? Colors.grey.withOpacity(0.5)
                              : Colors.white,
                        ))
                    .toList() ??
                [],
          ),
      ],
    );
  }
}
