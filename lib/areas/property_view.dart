import 'package:create_app/areas/sub_area/property_box.dart';
import 'package:create_app/areas/tree_view.dart';
import 'package:create_app/components/drag_vertical_line.dart';
import 'package:create_app/components/draggable_area.dart';
import 'package:create_app/components/draggable_target.dart';
import 'package:create_app/states/sizes.dart';
import 'package:create_app/states/editor_view_states.dart';
import 'package:create_app/types/enums.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_hooks/flutter_hooks.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PropertyViewArea extends HookWidget {
  static final id = 'property-view-area';
  PropertyViewArea({required this.key}) : super(key: key);
  final GlobalKey key;
  @override
  Widget build(BuildContext context) {
    final _editorLayout = useProvider(editorLayout);
    final treeIndex = _editorLayout.getIndex(TreeViewArea.id);
    final propertyIndex = _editorLayout.getIndex(id);
    final length = _editorLayout.list.length;
    final width = useProvider(propertyViewAreaSize);
    return Stack(
      children: [
        Row(
          children: [
            if (propertyIndex == length - 1 && propertyIndex != 0 ||
                propertyIndex == treeIndex - 1 && propertyIndex != 0)
              DragVerticalLine(
                areaKey: key,
                position: RelativePosition.start,
                onDrag: (dx) {
                  context.read(propertyViewNotifier).set(dx);
                },
                onTap: () {
                  context.read(propertyViewNotifier).reset();
                },
              ),
            Container(
              width: width,
              color: Colors.white,
              child: Column(
                children: [
                  EditorLayoutDragArea(
                    onTap: (_) {},
                    width: width,
                    title: 'Property Editor',
                    id: id,
                  ),
                  Expanded(
                    child: Container(
                      child: PropertyBox(),
                    ),
                  )
                ],
              ),
            ),
            if (propertyIndex == 0 && propertyIndex != length - 1 ||
                propertyIndex != treeIndex - 1 && propertyIndex != length - 1)
              DragVerticalLine(
                areaKey: key,
                onDrag: (dx) {
                  context.read(propertyViewNotifier).set(dx);
                },
                onTap: () {
                  context.read(propertyViewNotifier).reset();
                },
              ),
          ],
        ),
        Container(
          width: width,
          child: EditorAreaPlacement(
            id: id,
            acceptId: [TreeViewArea.id],
          ),
        ),
      ],
    );
  }
}
