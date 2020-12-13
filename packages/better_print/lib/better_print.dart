library better_print;

import 'package:flutter/widgets.dart';

class Console {
  final String message;
  final String? label;
  Console(this.message, [this.label]);
  factory Console.print(dynamic msg, [String? lbl]) {
    return Console(msg.toString(), lbl);
  }

  show([only = true, int? max]) {
    final stackTrace = StackTrace.current;
    Iterable<String> lines = stackTrace.toString().trimRight().split('\n');
    if (!only) {
      if (max != null) lines = lines.take(max);
      debugPrint(FlutterError.defaultStackFilter(lines).join('\n'));
    } else {
      final line = lines.toList()[1];
      final file = line.substring(line.indexOf('package:'));
      debugPrint('$message \n $file');
    }
  }
}
