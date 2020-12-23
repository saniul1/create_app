import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum ModalSubActions { delete, replace, addChild, addParent }

final currentModalNotifier =
    ChangeNotifierProvider((ref) => ModalWidgetNotifier());

class ModalWidgetNotifier extends ChangeNotifier {
  Widget? _widget;
  String? _key;
  ModalSubActions? _subActions;
  Widget? get widget => _widget;
  String? get key => _key;
  ModalSubActions? get subActions => _subActions;
  void setModal(Widget? widget, [String? key, ModalSubActions? subActions]) {
    _widget = widget;
    _key = key;
    _subActions = subActions;
    notifyListeners();
  }
}
