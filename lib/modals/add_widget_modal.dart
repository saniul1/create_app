import 'package:create_app/states/modal_states.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_hooks/flutter_hooks.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:widget_models/widget_models.dart';
import 'package:better_print/better_print.dart';
import 'package:widget_models/widget_models.dart' hide InsertMode;
import 'package:uuid/uuid.dart';

import 'snack_bars.dart';

class AddWidgetModal extends HookWidget {
  static const id = 'add-widgets-dialogue';
  final uuid = Uuid();
  AddWidgetModal(this.offset, this.onActionComplete);
  final Offset offset;
  final void Function(String type) onActionComplete;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    List<FlutterWidgetType> widgetModels = [...FlutterWidgetType.values];
    final modalState = context.read(currentModalNotifier);
    if (modalState.key != null && modalState.subActions != null) {
      // final model =
      //     context.read(appBuildController).controller.getModel(modalState.key!);
      if (modalState.subActions == ModalSubActions.addParent) {
        widgetModels.removeWhere((e) {
          final mdl = getFlutterWidgetModelFromType(uuid.v1(), '', e);
          return mdl == null || mdl.childGroups.isEmpty;
        });
      }
    }
    height = height - offset.dy - 32;
    return Transform.translate(
      offset: offset,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8.0,
            ),
          ],
        ),
        constraints: BoxConstraints(
          maxWidth: 180,
          maxHeight: height,
        ),
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: widgetModels
                .map(
                  (e) => ListTile(
                      visualDensity: VisualDensity.compact,
                      title: Text(e.toString().substring(18)),
                      onTap: () =>
                          onActionComplete(EnumToString.convertToString(e))),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
