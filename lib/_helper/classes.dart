import 'package:flutter/widgets.dart';

class WidgetWrapper<T> {
  WidgetWrapper(
      {required this.id,
      required this.child,
      this.offset = Offset.zero,
      this.data});
  final String id;
  final Widget child;
  Offset offset;
  T? data;
}
