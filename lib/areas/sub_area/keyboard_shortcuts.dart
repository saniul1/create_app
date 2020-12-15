import 'package:create_app/states/key_states.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';

class KeyShortCuts extends HookWidget {
  static final focusNode = FocusNode();
  KeyShortCuts({required this.child});
  final Widget child;
  build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: focusNode,
      child: child,
      onKey: (event) {
        if (event.isControlPressed != context.read(isControlPressed).state) {
          context.read(isControlPressed).state = event.isControlPressed;
        }
        if (event.isShiftPressed != context.read(isShiftPressed).state) {
          context.read(isShiftPressed).state = event.isShiftPressed;
        }
        if (!context.read(isControlPressed).state &&
            !context.read(isShiftPressed).state &&
            event.isAltPressed != context.read(isAltPressed).state) {
          context.read(isAltPressed).state = event.isAltPressed;
        }
        if (event.isMetaPressed != context.read(isMetaPressed).state) {
          context.read(isMetaPressed).state = event.isMetaPressed;
        }
        // final _ctrl = context.read(isControlPressed).state;
        // final _shift = context.read(isShiftPressed).state;
        // final _alt = context.read(isAltPressed).state;
        // print('C:$_ctrl, S:$_shift, A:$_alt');

        // print(event.logicalKey.debugName);
      },
    );
  }
}
