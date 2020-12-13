import 'package:flutter/material.dart';
import 'package:property_view/src/property_box.dart';
import 'package:property_view/src/property_view_controller.dart';
import 'package:property_view/src/property_view_theme.dart';

import 'models/property_box.dart';

/// Defines the [PropertyView] widget.
///
/// This is the main widget for the package. It requires a controller
/// and allows you to specify other optional properties that manages
/// the appearance and handle events.
///
/// ```dart
/// PropertyView(
///   controller: _PropertyViewController,
///   allowParentSelect: false,
///   supportParentDoubleTap: false,
///   onExpansionChanged: _expandPropertyBoxHandler,
///   onPropertyBoxTap: (key) {
///     setState(() {
///       _PropertyViewController = _PropertyViewController.copyWith(selectedKey: key);
///     });
///   },
///   theme: PropertyViewTheme
/// ),
/// ```
class PropertyView extends InheritedWidget {
  /// The controller for the [PropertyView]. It manages the data and selected key.
  final PropertyViewController controller;

  /// The action to call after all property change happen in a particular property.
  final Function(String, dynamic) onPropertyActionComplete;

  /// This action gets called on every step when changing a value.
  final Function(String, dynamic)? onEachActionStep;

  /// The expand/collapse handler for a node. Passes the node key and the
  /// expansion state.
  final Function(String, bool)? onExpansionChanged;

  /// The theme for [PropertyView].
  final PropertyViewTheme? theme;

  /// Determines whether the user can select a parent node. If false,
  /// tapping the parent will expand or collapse the node. If true, the node
  /// will be selected and the use has to use the expander to expand or
  /// collapse the node.
  final bool allowParentSelect;

  /// How the [PropertyView] should respond to user input.
  final ScrollPhysics? physics;

  /// Whether the extent of the [PropertyView] should be determined by the contents
  /// being viewed.
  ///
  /// Defaults to false.
  final bool shrinkWrap;

  /// Whether the [PropertyView] is the primary scroll widget associated with the
  /// parent PrimaryScrollController..
  ///
  /// Defaults to true.
  final bool primary;

  /// Determines whether the parent node can receive a double tap. This is
  /// useful if [allowParentSelect] is true. This allows the user to double tap
  /// the parent node to expand or collapse the parent when [allowParentSelect]
  /// is true.
  /// ___IMPORTANT___
  /// _When true, the tap handler is delayed. This is because the double tap
  /// action requires a short delay to determine whether the user is attempting
  /// a single or double tap._
  final bool supportParentDoubleTap;

  final String? idleMessage;

  PropertyView({
    Key? key,
    required this.controller,
    required this.onPropertyActionComplete,
    this.onEachActionStep,
    this.physics,
    this.onExpansionChanged,
    this.allowParentSelect: false,
    this.supportParentDoubleTap: false,
    this.shrinkWrap: false,
    this.primary: true,
    PropertyViewTheme? theme,
    this.idleMessage,
  })  : this.theme = theme ?? const PropertyViewTheme(),
        super(
          key: key,
          child: _PropertyViewData(
            controller,
            shrinkWrap: shrinkWrap,
            primary: primary,
            physics: physics,
            idleMsg: idleMessage,
          ),
        );

  static PropertyView? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType(aspect: PropertyView);

  @override
  bool updateShouldNotify(PropertyView oldWidget) {
    return oldWidget.controller.children != this.controller.children ||
        oldWidget.onPropertyActionComplete != this.onPropertyActionComplete ||
        oldWidget.onEachActionStep != this.onEachActionStep ||
        oldWidget.onExpansionChanged != this.onExpansionChanged ||
        oldWidget.theme != this.theme ||
        oldWidget.supportParentDoubleTap != this.supportParentDoubleTap ||
        oldWidget.allowParentSelect != this.allowParentSelect;
  }
}

class _PropertyViewData extends StatelessWidget {
  final PropertyViewController _controller;
  final bool shrinkWrap;
  final bool primary;
  final ScrollPhysics? physics;
  final String? idleMsg;

  const _PropertyViewData(this._controller,
      {this.shrinkWrap = false,
      this.primary = true,
      this.physics,
      this.idleMsg});

  @override
  Widget build(BuildContext context) {
    ThemeData _parentTheme = Theme.of(context);
    return Theme(
      data: _parentTheme.copyWith(hoverColor: Colors.grey.shade100),
      child: _controller.children.length > 0
          ? ListView(
              shrinkWrap: shrinkWrap,
              primary: primary,
              physics: physics,
              padding: EdgeInsets.zero,
              children: _controller.children.map((PropertyBox node) {
                return PropertyBoxItem(box: node);
              }).toList(),
            )
          : Text(
              idleMsg ?? '',
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.color
                      ?.withOpacity(0.6)),
            ),
    );
  }
}
