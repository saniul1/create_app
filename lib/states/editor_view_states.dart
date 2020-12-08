import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:create_app/_helper/classes.dart';

final isMenuBarActive = StateProvider((ref) => false);

final mousePosition = StateProvider((ref) => Offset.zero);

final editorLayout = ChangeNotifierProvider((ref) => EditorLayout());

class EditorLayout with ChangeNotifier {
  final List<WidgetWrapper> _list = [];
  bool _isChanged = false;
  List<WidgetWrapper> get list => _list;
  bool get isChanged => _isChanged;

  void initializeList(List<WidgetWrapper> list) {
    _list.addAll(list);
  }

  int getIndex(String id) {
    return _list.indexWhere((element) => element.id == id);
  }

  void updateLayout(String moveId, String posId, int i) {
    final moveIndex = getIndex(moveId);
    final dependIndex = getIndex(posId);
    int newIndex = i == 0
        ? moveIndex < dependIndex
            ? dependIndex - 1
            : dependIndex
        : moveIndex > dependIndex
            ? dependIndex + 1
            : dependIndex;
    newIndex = newIndex < 0
        ? 0
        : newIndex > _list.length - 1
            ? _list.length - 1
            : newIndex;
    // print('$moveIndex, $dependIndex, $newIndex');
    _isChanged = moveIndex != newIndex;
    _list.insert(newIndex, _list.removeAt(moveIndex));
    notifyListeners();
  }
}
