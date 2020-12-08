import 'package:flutter/widgets.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_hooks/flutter_hooks.dart';

class Page404 extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffffffff),
      child: Opacity(
        opacity: 1,
        child: Center(
            child: Text(
          'You\'re not supposed to be here.',
          style: TextStyle(
            color: Color(0xff000000),
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        )),
      ),
    );
  }
}
