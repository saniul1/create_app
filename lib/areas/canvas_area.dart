import 'package:create_app/_helper/functions.dart';
import 'package:create_app/areas/sub_area/keyboard_shortcuts.dart';
import 'package:create_app/components/blend_mask.dart';
import 'package:create_app/components/mouse_pointer.dart';
import 'package:create_app/models/app_view_model.dart';
import 'package:create_app/states/editor_view_states.dart';
import 'package:create_app/states/screenshot_state.dart';
import 'package:create_app/states/tools_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_hooks/flutter_hooks.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart' hide Listener;
import 'package:create_app/states/app_view_state.dart';
import 'package:create_app/areas/sub_area/app_view.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:keyboard_shortcuts/keyboard_shortcuts.dart';
// ignore: import_of_legacy_library_into_null_safe

class CanvasArea extends HookWidget {
  CanvasArea(this.overlayKey);
  final GlobalKey overlayKey;
  final _maxZoom = 2.0;
  final _minZoom = 0.5;
  @override
  Widget build(BuildContext context) {
    final zoom = useProvider(zoomLevel);
    final offset = useProvider(offsetPos);
    final currentTool = useProvider(selectedTool);
    final mousePos = useProvider(mousePosition);
    final appList = useProvider(appViewList);
    final _selectedApps = useProvider(selectedApps);
    final selectedAppId = useState<String?>(null);
    useEffect(() {
      Future.delayed(Duration(milliseconds: 0)).then((value) => offset.state =
          Offset(resetCanvasToCenter(context, overlayKey).dx, 0));
      return;
    }, const []);
    return KeyBoardShortcuts(
      keysToPress: {
        LogicalKeyboardKey.controlLeft,
        LogicalKeyboardKey.shiftLeft,
        LogicalKeyboardKey.keyV
      },
      onKeysPressed: () => currentTool.state =
          currentTool.state != ToolType.select
              ? ToolType.select
              : ToolType.none,
      helpLabel: "Go to Second Page",
      child: KeyShortCuts(
        child: Listener(
          onPointerMove: currentTool.state == ToolType.select
              ? (event) {
                  mousePos.state = event.position;
                  if (selectedAppId.value != null) {
                    if (!_selectedApps.state.contains(selectedAppId.value))
                      appList.updateOffsetBy(selectedAppId.value!, event.delta);
                    else
                      _selectedApps.state.forEach((element) =>
                          appList.updateOffsetBy(element, event.delta));
                  } else {
                    final z = (1 - zoom.state) * 3;
                    offset.state += event.delta * (z <= 1 ? 1 : z);
                  }
                }
              : null,
          onPointerUp: (_) {
            if (currentTool.state == ToolType.select)
              context.read(canvasScreenshot).capture();
          },
          onPointerSignal: currentTool.state == ToolType.select
              ? (PointerSignalEvent event) {
                  if (event is PointerScrollEvent) {
                    if (event.scrollDelta.dy > 0) {
                      if (zoom.state < _maxZoom) zoom.state += 0.1;
                    } else {
                      if (zoom.state > _minZoom + 0.1) zoom.state -= 0.1;
                    }
                  }
                }
              : null,
          child: MouseRegion(
            cursor: currentTool.state == ToolType.select
                ? SystemMouseCursors.none
                : SystemMouseCursors.basic,
            onHover: (event) {
              if (currentTool.state == ToolType.select)
                mousePos.state = event.position + event.delta;
            },
            onExit: (_) => mousePos.state = Offset.zero,
            child: GestureDetector(
              onTap: () {
                _selectedApps.state = [];
              },
              child: Stack(
                children: [
                  MouseRegion(
                    onEnter: (_) {
                      if (currentTool.state == ToolType.select)
                        selectedAppId.value = null;
                    },
                    child: Container(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  ...appList.list.map(
                    (widget) => Center(
                      child: Transform.scale(
                        scale: zoom.state,
                        child: Transform.translate(
                          offset: offset.state + widget.offset,
                          child: MouseRegion(
                            onEnter: (_) {
                              if (currentTool.state == ToolType.select)
                                selectedAppId.value = widget.id;
                            },
                            child: GestureDetector(
                              onTapDown: (_) {
                                if (currentTool.state == ToolType.select) {
                                  if (!_selectedApps.state.contains(widget.id))
                                    _selectedApps.state = [
                                      ..._selectedApps.state,
                                      widget.id
                                    ];
                                  else
                                    _selectedApps.state
                                        .removeWhere((id) => id == widget.id);
                                  _selectedApps.state = _selectedApps.state;
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: currentTool.state == ToolType.select
                                      ? Border.all(
                                          width: 2,
                                          color: _selectedApps.state
                                                  .contains(widget.id)
                                              ? Colors.blue
                                              : Colors.grey.shade400,
                                        )
                                      : null,
                                ),
                                width: 380,
                                height: 620,
                                child: ClipRect(
                                  child: AppView(key: ValueKey(widget.id)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (currentTool.state == ToolType.select &&
                      mousePos.state != Offset.zero)
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      child: Transform.translate(
                        offset: mousePos.state - Offset(6, 32),
                        child: BlendMask(
                          opacity: 1.0,
                          blendMode: BlendMode.multiply,
                          child: CustomPaint(
                            painter: MousePointer(color: Colors.blue),
                            child: SizedBox(
                              width: 16,
                              height: 26,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
