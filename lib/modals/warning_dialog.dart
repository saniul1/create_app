import 'package:create_app/states/modal_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WarningModal extends HookWidget {
  static const id = 'warning-dialog-modal';
  WarningModal(this.warningMsg, this.onYes, [this.onNo]);
  final void Function() onYes;
  final void Function()? onNo;
  final String warningMsg;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        constraints: BoxConstraints(minHeight: 80, minWidth: 300),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                warningMsg,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FlatButton(
                        child: Text('Yes'),
                        onPressed: () {
                          onYes();
                          context.read(currentModalNotifier).setModal(null);
                        },
                      ),
                      FlatButton(
                        child: Text('No'),
                        onPressed: () {
                          // if (onNo != null) onNo();
                          context.read(currentModalNotifier).setModal(null);
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
