import 'dart:ui';

import 'package:create_app/_utils/handle_keys.dart';
import 'package:create_app/areas/property_view.dart';
import 'package:create_app/components/drag_vertical_line.dart';
import 'package:create_app/components/draggable_area.dart';
import 'package:create_app/components/draggable_target.dart';
import 'package:create_app/modals/add_widget_modal.dart';
import 'package:create_app/modals/name_option.dart';
import 'package:create_app/states/editor_view_states.dart';
import 'package:create_app/states/modal_states.dart';
import 'package:create_app/states/tree_view_state.dart';
import 'package:create_app/types/enums.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:delayed_display/delayed_display.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_hooks/flutter_hooks.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:create_app/areas/sub_area/tree_nodes.dart';

import 'package:create_app/states/sizes.dart';
import 'package:uuid/uuid.dart';
import 'package:widget_models/widget_models.dart';

class TreeViewArea extends HookWidget {
  static final id = 'tree-view-area';
  TreeViewArea({required this.key}) : super(key: key);
  final GlobalKey key;
  final GlobalKey addKey = GlobalKey();
  final uuid = Uuid();
  @override
  Widget build(BuildContext context) {
    final AsyncValue treeMap = useProvider(nodeMap);
    // print('build');
    useEffect(() {
      return;
    }, const []);
    final treeController = useProvider(treeViewController);
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
                                onTap: (String name) {
                                  treeController.switchTree(name);
                                },
                                width: width,
                                title: treeController.activeTree,
                                titleOption: treeController.trees.keys.toList(),
                                id: id,
                                actions: [
                                  IconButton(
                                    key: addKey,
                                    icon: Icon(Icons.add),
                                    iconSize: 18,
                                    visualDensity: VisualDensity.compact,
                                    constraints: BoxConstraints(),
                                    color: Colors.grey,
                                    hoverColor: Colors.red,
                                    onPressed: () {
                                      context
                                          .read(currentModalNotifier)
                                          .setModal(
                                            NameOptionModal(
                                              getPositionFromKey(addKey) ??
                                                  Offset.zero,
                                              (name) {
                                                Map<String, dynamic>? model =
                                                    getFlutterWidgetModelFromType(
                                                            uuid.v1(),
                                                            null,
                                                            FlutterWidgetType
                                                                .CustomWidget,
                                                            name)
                                                        ?.asMap;
                                                context
                                                    .read(treeViewController)
                                                    .addNewRootParent(model!);
                                                context
                                                    .read(currentModalNotifier)
                                                    .setModal(null);
                                              },
                                            ),
                                          );
                                    },
                                  )
                                ],
                              ),
                              if (value ||
                                  treeController.controller.children.isNotEmpty)
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
