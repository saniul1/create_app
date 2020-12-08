import 'dart:ui' as ui;
import 'package:create_app/_utils/widget_screenshot.dart';
import 'package:create_app/areas/sub_area/app_view.dart';
import 'package:create_app/states/app_view_state.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore: import_of_legacy_library_into_null_safe

final canvasScreenshot = ChangeNotifierProvider((ref) => CanvasScreenshot(ref));

class CanvasScreenshot extends ChangeNotifier {
  ProviderReference _ref;
  CanvasScreenshot(ProviderReference ref) : _ref = ref;
  ui.Image? _img;
  ui.Image? get img => _img;
  capture() async {
    // final list = _ref.read(appViewList).list;
    // final offset = _ref.read(offsetPos).state;
    // final widget = Stack(
    //   children: [
    //     ...list.map(
    //       (widget) {
    //         return Center(
    //           child: Transform.translate(
    //               offset: offset + widget.offset, child: AppView()),
    //         );
    //       },
    //     ),
    //   ],
    // );
    // final width = 3500.0;
    // final height = 3500.0;
    // _img = await createImageFromWidget(widget,
    //     logicalSize: Size(width, height), imageSize: Size(width, height));
    // notifyListeners();
  }
}
