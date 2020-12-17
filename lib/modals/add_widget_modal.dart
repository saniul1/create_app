import 'package:create_app/dialogs/settings_dialog.dart';
import 'package:create_app/states/file_storage_state.dart';
import 'package:create_app/states/modal_states.dart';
import 'package:create_app/states/tree_view_state.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_hooks/flutter_hooks.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:widget_models/widget_models.dart';
import 'package:better_print/better_print.dart';

import 'snack_bars.dart';

class AddWidgetModal extends HookWidget {
  static const id = 'add-widgets-dialogue';
  AddWidgetModal(this.offset, this.onActionComplete, this.data);
  final Map<String, dynamic> data;
  final Offset offset;
  final void Function() onActionComplete;
  final uuid = Uuid();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
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
            children: FlutterWidgetType.values
                .map(
                  (e) => ListTile(
                    visualDensity: VisualDensity.compact,
                    title: Text(e.toString().substring(18)),
                    onTap: () {
                      onActionComplete();
                      Map<String, dynamic>? model =
                          getFlutterWidgetModelFromType(
                                  uuid.v1(), data['group']!, e)
                              ?.asMap;
                      // Console.print(model?['data']['text']['value'].runtimeType)
                      //     .show();
                      context
                          .read(treeViewController)
                          .addNode(data['key']!, model!);
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
