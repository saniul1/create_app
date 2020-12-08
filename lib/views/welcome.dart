import 'package:create_app/states/preferences_state.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:create_app/views/editor.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Welcome extends HookWidget {
  static final routeName = '/';
  @override
  Widget build(BuildContext context) {
    final AsyncValue _prefs = useProvider(prefs);
    final animation = useAnimationController(
      duration: kThemeAnimationDuration * 2,
      initialValue: 2,
      upperBound: 2,
    );
    final logoAnimation = useAnimationController(
        duration: kThemeAnimationDuration, initialValue: 0);
    animation.reverse().then((value) => {
          Future.delayed(Duration(milliseconds: 100)).then((value) =>
              logoAnimation.forward().then((value) =>
                  Future.delayed(Duration(milliseconds: 900)).then((value) {
                    logoAnimation.reverse();
                    animation.forward();
                    _prefs.whenData((value) {
                      Future.delayed(Duration(milliseconds: 600)).then(
                          (value) => Navigator.popAndPushNamed(
                              context, Editor.routeName));
                    });
                  })))
        });
    return Stack(
      children: [
        Container(
          color: Colors.blue,
        ),
        ScaleTransition(
          scale: animation,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: FadeTransition(
            opacity: logoAnimation,
            child: ScaleTransition(
              scale: logoAnimation,
              child: FlutterLogo(
                size: 100,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
