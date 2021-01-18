import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NameOptionModal extends HookWidget {
  NameOptionModal(this.offset, this.onActionComplete, [this.text]);
  final Offset offset;
  final String? text;
  final void Function(String name) onActionComplete;
  final focusNode = FocusNode();
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    useEffect(() {
      controller.text = text ?? '';
      controller.selection =
          TextSelection(baseOffset: 0, extentOffset: controller.text.length);
      focusNode.requestFocus();
      return;
    }, const []);
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
        constraints: BoxConstraints(maxWidth: 250),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
            focusNode: focusNode,
            controller: controller,
            decoration: InputDecoration(border: InputBorder.none),
            onSubmitted: (txt) => onActionComplete(txt),
          ),
        ),
      ),
    );
  }
}
