import 'package:create_app/dialogs/settings_dialog.dart';
import 'package:create_app/states/file_storage_state.dart';
import 'package:create_app/states/modal_states.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_hooks/flutter_hooks.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'snack_bars.dart';

class AddWidgetModal extends HookWidget {
  static const id = 'add-widgets-dialogue';
  AddWidgetModal(this.offset, this.onActionComplete);
  final Offset offset;
  final void Function() onActionComplete;
  @override
  Widget build(BuildContext context) {
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
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Exit'),
              onTap: () {
                onActionComplete();
              },
            ),
          ],
        ),
      ),
    );
  }
}
