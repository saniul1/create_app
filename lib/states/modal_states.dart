import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ModalKey extends ChangeNotifier {
  String? id;
  late GlobalKey key;
  late void Function() onActionComplete;
  Map<String, dynamic>? data;
  void setKey(String? i, GlobalKey k, void Function() onActComplete,
      [Map<String, dynamic>? _data]) {
    id = i;
    key = k;
    onActionComplete = onActComplete;
    data = _data;
    notifyListeners();
  }
}

final currentModalKey = ChangeNotifierProvider((ref) => ModalKey());
