import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ModalKey extends ChangeNotifier {
  late String id;
  GlobalKey? key;
  void setKey(String i, GlobalKey? k) {
    id = i;
    key = k;
    notifyListeners();
  }
}

final currentModalKey = ChangeNotifierProvider((ref) => ModalKey());
