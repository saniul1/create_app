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

  factory AppViewModel.fromMap(Map map) {
    return AppViewModel(
      id: map["key"],
      label: map["label"],
      node: map["node"],
      offset: Offset(map["x"], map["y"]),
    );
  }

  Map get asMap => {
        "key": id,
        "label": label,
        "node": node,
        "offset": {"x": offset.dx, "y": offset.dy}
      };
}
