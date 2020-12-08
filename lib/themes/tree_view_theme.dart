import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_treeview/tree_view.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/all.dart';

final expanderPosition = StateProvider((ref) => ExpanderPosition.start);
final expanderType = StateProvider((ref) => ExpanderType.caret);
final expanderModifier = StateProvider((ref) => ExpanderModifier.none);

final treeViewTheme = StateProvider<TreeViewTheme>((ref) {
  final _expanderType = ref.watch(expanderType);
  final _expanderModifier = ref.watch(expanderModifier);
  final _expanderPosition = ref.watch(expanderPosition);

  return TreeViewTheme(
      expanderTheme: ExpanderThemeData(
        type: _expanderType.state,
        modifier: _expanderModifier.state,
        position: _expanderPosition.state,
        color: Colors.grey.shade800,
        size: 20,
      ),
      labelStyle: TextStyle(
        fontSize: 16,
        letterSpacing: 0.3,
      ),
      parentLabelStyle: TextStyle(
        fontSize: 16,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w800,
        color: Colors.blue.shade700,
      ),
      iconTheme: IconThemeData(
        size: 18,
        color: Colors.grey.shade800,
      ),
      colorScheme:
          // Theme.of(context).brightness == Brightness.light?
          ColorScheme.light(
        primary: Colors.blue.shade100,
        onPrimary: Colors.grey.shade900,
        background: Colors.transparent,
        onBackground: Colors.black,
      )
      // : ColorScheme.dark(
      //     primary: Colors.black26,
      //     onPrimary: Colors.white,
      //     background: Colors.transparent,
      //     onBackground: Colors.white70,
      //   ),
      );
});
