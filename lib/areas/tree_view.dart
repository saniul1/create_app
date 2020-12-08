import 'package:create_app/areas/property_view.dart';
import 'package:create_app/components/drag_vertical_line.dart';
import 'package:create_app/components/draggable_area.dart';
import 'package:create_app/components/draggable_target.dart';
import 'package:create_app/states/editor_view_states.dart';
import 'package:create_app/states/tree_view_state.dart';
import 'package:create_app/types/enums.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_hooks/flutter_hooks.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:create_app/areas/sub_area/tree_nodes.dart';

import 'package:create_app/states/sizes.dart';

class TreeViewArea extends HookWidget {
  static final id = 'tree-view-area';
  TreeViewArea({required this.key}) : super(key: key);
  final GlobalKey key;
  @override
  Widget build(BuildContext context) {
    final AsyncValue treeMap = useProvider(nodeMap);
    // print('build');
    useEffect(() {
      return;
    }, const []);
    final treeController = useProvider(treeViewController).controller;
    final _editorLayout = useProvider(editorLayout);
    final treeIndex = _editorLayout.getIndex(id);
    final propertyIndex = _editorLayout.getIndex(PropertyViewArea.id);
    final length = _editorLayout.list.length;
    final width = useProvider(treeViewAreaSize);
    return Stack(
      children: [
        Row(
          children: [
            if (treeIndex == length - 1 && treeIndex != 0 ||
                treeIndex == propertyIndex - 1 && treeIndex != 0)
              DragVerticalLine(
                areaKey: key,
                position: RelativePosition.start,
                onDrag: (dx) {
                  context.read(treeViewNotifier).set(dx);
                },
                onTap: () {
                  context.read(treeViewNotifier).reset();
                },
              ),
            Container(
              width: width,
              color: Colors.white,
              child: treeMap.when(
                  loading: () => Center(
                        child: DelayedDisplay(
                          delay: Duration(milliseconds: 1000),
                          child: const CircularProgressIndicator(),
                        ),
                      ),
                  error: (error, stack) =>
                      Center(child: Text('${error.toString()}')),
                  data: (value) {
                    return width == 0
                        ? Container()
                        : Column(
                            children: [
                              EditorLayoutDragArea(
                                width: width,
                                title: 'Tree View',
                                id: id,
                              ),
                              if (value || treeController.children.isNotEmpty)
                                Expanded(
                                  child: Container(
                                    child: TreeNodes(),
                                  ),
                                )
                              else
                                Center(
                                  child:
                                      Text('Open a project to start editing'),
                                ),
                            ],
                          );
                  }),
            ),
            if (treeIndex == 0 && treeIndex != length - 1 ||
                treeIndex != propertyIndex - 1 && treeIndex != length - 1)
              DragVerticalLine(
                areaKey: key,
                onDrag: (dx) {
                  context.read(treeViewNotifier).set(dx);
                },
                onTap: () {
                  context.read(treeViewNotifier).reset();
                },
              ),
          ],
        ),
        Container(
          width: width,
          child: EditorAreaPlacement(
            id: id,
            acceptId: [PropertyViewArea.id],
          ),
        ),
      ],
    );
  }
}
