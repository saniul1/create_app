import 'package:flutter/widgets.dart';

class AppViewModel {
  AppViewModel({
    required this.id,
    this.label,
    required this.node,
    this.offset = Offset.zero,
  });
  final String id;
  final String? label;
  final String node;
  Offset offset;
}
