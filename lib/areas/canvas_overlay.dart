import 'package:create_app/_helper/functions.dart';
import 'package:create_app/_utils/handle_keys.dart';
import 'package:create_app/areas/canvas_area.dart';
import 'package:create_app/areas/tree_view.dart';
import 'package:create_app/areas/property_view.dart';
import 'package:create_app/components/app_icon_button.dart';
import 'package:create_app/components/draggable_target.dart';
import 'package:create_app/states/app_view_state.dart';
import 'package:create_app/states/screenshot_state.dart';
import 'package:create_app/states/tools_state.dart';
import 'package:flutter/material.dart';
import 'package:create_app/areas/sub_area/minimap.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_hooks/flutter_hooks.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CanvasOverlayArea extends HookWidget {
  CanvasOverlayArea(this.key) : super(key: key);
  final GlobalKey key;
  static final id = 'canvas-overlay-area';
  @override
  Widget build(BuildContext context) {
    final currentTool = useProvider(selectedTool);
    final zoom = useProvider(zoomLevel);
    final offset = useProvider(offsetPos);
    final appList = useProvider(appViewList);
    final _selectedApps = useProvider(selectedApps);
    final _canvasScreenshot = useProvider(canvasScreenshot);
    useEffect(() {
      Future.delayed(Duration(milliseconds: 0)).then(
        (value) => _canvasScreenshot.capture(),
      );
      return;
    }, const []);
    return Expanded(
      child: Container(
        child: Stack(
          children: [
            // if (currentTool.state == ToolType.select)
            //   Align(
            //     alignment: Alignment.bottomLeft,
            //     child: MiniMap(
            //       image: _canvasScreenshot.img,
            //     ),
            //   ),
            if (currentTool.state == ToolType.select)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text('zoom: ${zoom.state.toStringAsFixed(1)}')],
                ),
              ),
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ToolsWrapper(
                    children: [
                      if (currentTool.state == ToolType.select)
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            children: [
                              AppIconButton(
                                icon: Foundation.zoom_out,
                                size: 20,
                                onClick: () {
                                  zoom.state -= 0.1;
                                },
                              ),
                              AppIconButton(
                                icon: Foundation.zoom_in,
                                size: 20,
                                onClick: () {
                                  zoom.state += 0.1;
                                },
                              ),
                              AppIconButton(
                                icon: Foundation.arrows_compress,
                                size: 20,
                                onClick: () {
                                  zoom.state = 1.0;
                                },
                              ),
                              AppIconButton(
                                icon: Foundation.arrows_in,
                                size: 20,
                                onClick: () {
                                  offset.state =
                                      resetCanvasToCenter(context, key);
                                  _canvasScreenshot.capture();
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  ToolsWrapper(
                    children: [
                      if (_selectedApps.state.length > 0)
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(children: [
                            AppIconButton(
                              icon: Foundation.graph_bar,
                              size: 20,
                              onClick: () {
                                appList.alignVertical();
                                _canvasScreenshot.capture();
                              },
                            ),
                            AppIconButton(
                              icon: Foundation.graph_horizontal,
                              size: 20,
                              onClick: () {
                                appList.alignHorizontal();
                                _canvasScreenshot.capture();
                              },
                            ),
                            AppIconButton(
                              icon: Foundation.eye,
                              size: 20,
                              onClick: () {
                                appList.makeCenter();
                                offset.state =
                                    resetCanvasToCenter(context, key);
                                _canvasScreenshot.capture();
                              },
                            ),
                          ]),
                        ),
                    ],
                  )
                ],
              ),
            ),
            EditorAreaPlacement(
              id: id,
              acceptId: [TreeViewArea.id, PropertyViewArea.id],
            ),
          ],
        ),
      ),
    );
  }
}

class ToolsWrapper extends StatelessWidget {
  const ToolsWrapper({
    Key? key,
    this.children = const [],
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}
