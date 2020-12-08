// ignore: import_of_legacy_library_into_null_safe
import 'package:bitsdojo_window/bitsdojo_window.dart'; //c-spell: disable-line
import 'package:create_app/constants/app_info.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_hooks/flutter_hooks.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:create_app/views/welcome.dart';
import 'package:create_app/views/editor.dart';
import 'package:create_app/views/404.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
  doWhenWindowReady(() {
    final win = appWindow;
    final initialSize = Size(1200, 700);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = 'Create App';
    win.show();
  });
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final info = useProvider(appInfo);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: info.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Welcome.routeName,
      onGenerateRoute: (settings) {
        if (settings.name == Welcome.routeName) {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => Welcome(),
            transitionsBuilder: (_, anim, __, child) {
              return FadeTransition(opacity: anim, child: child);
            },
          );
        } else if (settings.name == Editor.routeName) {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => Editor(),
            transitionsBuilder: (_, anim, __, child) {
              return child;
            },
          );
        }
        // unknown route
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => Page404(),
          transitionsBuilder: (_, anim, __, child) {
            return FadeTransition(opacity: anim, child: child);
          },
        );
      },
    );
  }
}
