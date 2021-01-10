import 'dart:math' show pi;
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:property_view/src/property_view.dart';
import 'package:property_view/src/property_view_theme.dart';
import 'package:widget_models/widget_models.dart';
// import 'package:flutter_treeview/tree_view.dart';
import 'package:better_print/better_print.dart';

import 'models/property_box.dart';
import 'widgets/color_picker.dart';
import 'widgets/number_field_property.dart';
import 'widgets/property_bool.dart';
import 'widgets/selection_proprty.dart';
import 'widgets/text_field_property.dart';

class PropertyBoxItem extends StatefulWidget {
  final PropertyBox box;

  const PropertyBoxItem({Key? key, required this.box}) : super(key: key);

  @override
  _PropertyBoxItemState createState() => _PropertyBoxItemState();
}

class _PropertyBoxItemState extends State<PropertyBoxItem>
    with SingleTickerProviderStateMixin {
  // static final Animatable<double> _easeInTween =
  //     CurveTween(curve: Curves.easeIn);
  static Duration _kExpand = Duration(milliseconds: 200);
  // static double _kIconSize = 28;

  AnimationController? _controller;
  // Animation<double> _heightFactor;
  bool _isExpanded = false;
  // bool _isOnHover = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    // _heightFactor = _controller.drive(_easeInTween);
    if (_isExpanded) _controller?.value = 1.0;
  }

  @override
  void dispose() {
    _controller?.dispose();
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
    PropertyView? _propertyView = PropertyView.of(context);
    assert(_propertyView != null, 'PropertyView must exist in context');
    final call = _propertyView?.onPropertyActionComplete;
    if (call != null) call(widget.box.key, value);
  }

  void _handleValueInitialize() {
    PropertyView? _propertyView = PropertyView.of(context);
    assert(_propertyView != null, 'PropertyView must exist in context');
    final call = _propertyView?.initializePropertyValue;
    if (call != null) call(widget.box.key);
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
    PropertyView? _propertyView = PropertyView.of(context);
    assert(_propertyView != null, 'PropertyView must exist in context');
    // Console.print(widget.box.type).show();
    Widget? box;
    switch (widget.box.type) {
      case PropertyType.string:
        box = TextFieldProperty(
          label: widget.box.label,
          value: widget.box.value,
          onChanged: _handleValueChange,
        );

        break;
      case PropertyType.boolean:
        box = PropertyBoolWidget(
          valueKey: widget.box.key,
          label: widget.box.label,
          value: widget.box.value,
          onChanged: _handleValueChange,
        );
        break;

      case PropertyType.icon:
        // materialIconsList.map((e) => e.name).toList()
        // print(widget.box.value);
        box = SelectOptionsProperty(
          values: ['none', ...materialIconsList.map((e) => e.name).toList()],
          valueIcons: Map.fromIterable(materialIconsList,
              key: (e) => e.name, value: (e) => e.iconData),
          value: widget.box.value == null ? 'none' : widget.box.value,
          onChanged: (dynamic value) {
            _handleValueChange(value == 'none' ? null : value);
          },
        );
        break;
      case PropertyType.double:
        box = NumberFieldProperty(
          label: widget.box.label,
          value: widget.box.value,
          onChanged: _handleValueChange,
        );
        break;
      case PropertyType.integer:
        box = NumberFieldProperty(
          label: widget.box.label,
          value: widget.box.value,
          onChanged: _handleValueChange,
          isDouble: false,
        );
        break;
      case PropertyType.mainAxisAlignment:
        box = SelectOptionsProperty(
          values: EnumToString.toList(MainAxisAlignment.values),
          value: widget.box.value.toString(),
          onChanged: (dynamic value) {
            _handleValueChange(value);
          },
        );
        break;
      case PropertyType.crossAxisAlignment:
        box = SelectOptionsProperty(
          values: EnumToString.toList(CrossAxisAlignment.values),
          value: widget.box.value.toString(),
          onChanged: (dynamic value) {
            _handleValueChange(value);
          },
        );
        break;
      case PropertyType.mainAxisSize:
        box = SelectOptionsProperty(
          values: EnumToString.toList(MainAxisSize.values),
          value: widget.box.value.toString(),
          onChanged: (dynamic value) {
            _handleValueChange(value);
          },
        );
        break;
      case PropertyType.alignment:
        box = SelectOptionsProperty(
          key: ValueKey('${widget.box.key}-${widget.box.label}'),
          values: [
            'topLeft',
            'topCenter',
            'topRight',
            'centerLeft',
            'center',
            'centerRight',
            'bottomLeft',
            'bottomCenter',
            'bottomRight',
          ],
          value: widget.box.value.toString().split('.').last,
          onChanged: (dynamic value) {
            _handleValueChange(value);
          },
        );
        break;
      case PropertyType.widget:
        // TODO: Handle this case.
        break;
      case PropertyType.color:
        box = ColorPickerBox(
          key: ValueKey('${widget.box.key}-${widget.box.label}'),
          color: widget.box.value,
          onChanged: _handleValueChange,
        );
        break;
      case PropertyType.alignment:
        // TODO: Handle this case.
        break;
      case PropertyType.boxFit:
        // TODO: Handle this case.
        break;
      case PropertyType.scrollPhysics:
        // TODO: Handle this case.
        break;
      case PropertyType.axis:
        // TODO: Handle this case.
        break;
      case PropertyType.fontStyle:
        // TODO: Handle this case.
        break;
      case PropertyType.function:
        // TODO: Handle this case.
        break;
      // comment below two lines to check all types are implemented are not
      default:
        box = null;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: !widget.box.isInitialized
          ? RaisedButton(
              child: Text('Add ${widget.box.label}'),
              onPressed: () {
                _handleValueInitialize();
              },
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      widget.box.label,
                    ),
                  ],
                ),
                box ?? SizedBox(),
              ],
            ),
    );
  }
}
