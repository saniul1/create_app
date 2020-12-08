import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:create_app/_helper/functions.dart';
import 'package:create_app/areas/canvas_area.dart';
import 'package:create_app/states/app_view_state.dart';
import 'package:create_app/states/editor_view_states.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:create_app/areas/canvas_overlay.dart';
import 'package:create_app/_helper/classes.dart';

import 'package:create_app/areas/menu_bar.dart';
import 'package:create_app/areas/people_bar.dart';
import 'package:create_app/areas/property_view.dart';
import 'package:create_app/areas/tree_view.dart';
import 'package:create_app/modals/handle_modals.dart';

import 'package:create_app/states/modal_states.dart';

class Editor extends HookWidget {
  static final routeName = '/editor';
  final treeAreaKey = GlobalKey();
  final canvasAreaKey = GlobalKey();
  final propertyAreaKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    // SchedulerBinding.instance.addPostFrameCallback((_) => {print('sd')});
    final _children = useProvider(editorLayout);
    _children.addListener(() {
      if (_children.isChanged) {
        final oldCenter =
            Offset(resetCanvasToCenter(context, canvasAreaKey).dx, 0);
        final offset = oldCenter - context.read(offsetPos).state;
        Future.delayed(Duration(milliseconds: 100)).then(
          (value) {
            final newCenter =
                Offset(resetCanvasToCenter(context, canvasAreaKey).dx, 0);
            return context.read(offsetPos).state = newCenter - offset;
          },
        );
      }
    });
    useEffect(() {
      _children.initializeList([
        WidgetWrapper(
            id: TreeViewArea.id,
            child: TreeViewArea(
              key: treeAreaKey,
            )),
        WidgetWrapper(
            id: CanvasOverlayArea.id, child: CanvasOverlayArea(canvasAreaKey)),
        WidgetWrapper(
            id: PropertyViewArea.id,
            child: PropertyViewArea(
              key: propertyAreaKey,
            )),
      ]);
      return;
    }, const []);
    return Material(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Container(
              color: Colors.grey.shade100,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  CanvasArea(canvasAreaKey),
                  Row(children: [
                    ..._children.list.map((widget) => widget.child)
                  ]),
                  ModalWidget(),
                ],
              ),
            ),
          ),
          Container(
            height: 30,
            color: Colors.white,
            child: MoveWindow(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MinimizeWindowButton(),
              MaximizeWindowButton(),
              CloseWindowButton(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
            child: MenuBar(),
          ),
        ],
      ),
    );
  }
}

class ModalWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _modalKey = useProvider(currentModalKey);
    return Container(
      child: _modalKey.key != null
          ? GestureDetector(
              onTap: () {
                _modalKey.setKey('', null);
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
                child: Stack(
                  children: [
                    handleModals(_modalKey.id, _modalKey.key)!,
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
