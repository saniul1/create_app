import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:property_view/src/property_view.dart';
import 'package:property_view/src/property_view_theme.dart';
import 'package:widget_models/widget_models.dart';
// import 'package:flutter_treeview/tree_view.dart';

// import 'expander_theme_data.dart';
import 'models/property_box.dart';
import 'widgets/property_bool.dart';
import 'widgets/text_field_property.dart';

// const int _kExpander180Speed = 200;
// const int _kExpander90Speed = 125;
// const double _kBorderWidth = 0.75;

/// Defines the [PropertyBoxItem] widget.
///
/// This widget is used to display a tree node and its children. It requires
/// a single [PropertyBox] value. It uses this node to display the state of the
/// widget. It uses the [PropertyViewTheme] to handle the appearance and the
/// [PropertyView] properties to handle to user actions.
///
/// __This class should not be used directly!__
/// The [PropertyView] and [PropertyViewController] handlers the data and rendering
/// of the nodes.
class PropertyBoxItem extends StatefulWidget {
  /// The node object used to display the widget state
  final PropertyBox box;

  const PropertyBoxItem({Key key, @required this.box}) : super(key: key);

  @override
  _PropertyBoxItemState createState() => _PropertyBoxItemState();
}

class _PropertyBoxItemState extends State<PropertyBoxItem>
    with SingleTickerProviderStateMixin {
  // static final Animatable<double> _easeInTween =
  //     CurveTween(curve: Curves.easeIn);
  static Duration _kExpand = Duration(milliseconds: 200);
  // static double _kIconSize = 28;

  AnimationController _controller;
  // Animation<double> _heightFactor;
  bool _isExpanded = false;
  // bool _isOnHover = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    // _heightFactor = _controller.drive(_easeInTween);
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PropertyBoxItem oldWidget) {
    if (widget.box != oldWidget.box) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  // void _handleExpand() {
  //   PropertyView _propertyView = PropertyView.of(context);
  //   assert(_propertyView != null, 'PropertyView must exist in context');
  //   setState(() {
  //     _isExpanded = !_isExpanded;
  //     if (_isExpanded) {
  //       _controller.forward();
  //     } else {
  //       _controller.reverse().then<void>((void value) {
  //         if (!mounted) return;
  //         setState(() {});
  //       });
  //     }
  //   });
  //   if (_propertyView.onExpansionChanged != null)
  //     _propertyView.onExpansionChanged(widget.box.key, _isExpanded);
  // }

  void _handleValueChange(dynamic value) {
    PropertyView _propertyView = PropertyView.of(context);
    assert(_propertyView != null, 'PropertyView must exist in context');
    if (_propertyView.onPropertyActionComplete != null) {
      _propertyView.onPropertyActionComplete(widget.box.key, value);
    }
  }

  // void _handleActionSteps(dynamic value) {
  //   PropertyView _propertyView = PropertyView.of(context);
  //   assert(_propertyView != null, 'PropertyView must exist in context');
  //   if (_propertyView.onEachActionStep != null) {
  //     _propertyView.onEachActionStep(widget.box.key, value);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    PropertyView _propertyView = PropertyView.of(context);
    assert(_propertyView != null, 'PropertyView must exist in context');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (widget.box.type == PropertyType.string)
              TextFieldProperty(
                label: widget.box.label,
                value: widget.box.value,
                onChanged: _handleValueChange,
              )
            else if (widget.box.type == PropertyType.boolean)
              PropertyBoolWidget(
                valueKey: widget.box.key,
                label: widget.box.label,
                value: widget.box.value,
                onChanged: _handleValueChange,
              ),
          ],
        ),
      ),
    );
  }
}
