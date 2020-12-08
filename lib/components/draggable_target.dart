import 'package:flutter/material.dart';
import 'package:create_app/states/editor_view_states.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/all.dart';

class EditorAreaPlacement extends ConsumerWidget {
  const EditorAreaPlacement(
      {Key? key, required this.id, required this.acceptId})
      : super(key: key);

  final String id;
  final List<String> acceptId;

  @override
  Widget build(BuildContext context, _) {
    return Row(
      children: List.generate(
        2,
        (i) => Flexible(
          flex: 2,
          child: Container(
            child: DragTarget(
              builder: (context, List<String?> candidateData, rejectedData) {
                return candidateData.length > 0 &&
                        acceptId.contains(candidateData[0])
                    ? Container(
                        color: Colors.deepPurple.withOpacity(0.2),
                      )
                    : Container(
                        // color: Colors.red.shade100,
                        );
              },
              // onWillAccept: (data) {
              //   return true;
              // },
              onAccept: (String data) {
                context.read(editorLayout).updateLayout(data, id, i);
              },
            ),
          ),
        ),
      ),
    );
  }
}
