import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentModalNotifier =
    ChangeNotifierProvider((ref) => ModalWidgetNotifier());

class ModalWidgetNotifier extends ChangeNotifier {
  Widget? _widget;
  Widget? get widget => _widget;
  void setModal(Widget? widget) {
    _widget = widget;
    notifyListeners();
  }
}
