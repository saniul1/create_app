import 'package:flutter/widgets.dart';

class AppViewModel {
  AppViewModel({
    required this.id,
    required this.node,
    required this.tree,
    this.offset = Offset.zero,
    this.label,
    this.width,
    this.height,
  });
  final String id;
  final String? label;
  final String node;
  final String tree;
  final double? width;
  final double? height;
  Offset offset;

  factory AppViewModel.fromMap(Map map) {
    return AppViewModel(
      id: map["key"],
      label: map["label"],
      node: map["node"],
      tree: map["tree"],
      width: map["width"],
      height: map["height"],
      offset: Offset(map["x"], map["y"]),
    );
  }

  Map get asMap => {
        "key": id,
        "label": label,
        "node": node,
        "tree": tree,
        "width": width,
        "height": height,
        "offset": {"x": offset.dx, "y": offset.dy}
      };
}
