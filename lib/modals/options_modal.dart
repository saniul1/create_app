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

class OptionsModal extends HookWidget {
  static const id = 'options-dialogue';
  OptionsModal(this.offset, this.onActionComplete, this.options);
  final Offset offset;
  final void Function(String type) onActionComplete;
  final List<String> options;
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
            children: options
                .map(
                  (key) => ListTile(
                    visualDensity: VisualDensity.compact,
                    title: Text(key),
                    onTap: () => onActionComplete(key),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
