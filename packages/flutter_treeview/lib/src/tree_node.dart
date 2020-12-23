import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_treeview/tree_view.dart';

import 'expander_theme_data.dart';
import 'models/node.dart';

const int _kExpander180Speed = 200;
const int _kExpander90Speed = 125;
const double _kBorderWidth = 0.75;

/// Defines the [TreeNode] widget.
///
/// This widget is used to display a tree node and its children. It requires
/// a single [Node] value. It uses this node to display the state of the
/// widget. It uses the [TreeViewTheme] to handle the appearance and the
/// [TreeView] properties to handle to user actions.
///
/// __This class should not be used directly!__
/// The [TreeView] and [TreeViewController] handlers the data and rendering
/// of the nodes.
class TreeNode extends StatefulWidget {
  /// The node object used to display the widget state
  final Node node;

  const TreeNode({Key key, @required this.node}) : super(key: key);

  @override
  _TreeNodeState createState() => _TreeNodeState();
}

class _TreeNodeState extends State<TreeNode>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static Duration _kExpand = Duration(milliseconds: 200);
  static double _kIconSize = 28;

  AnimationController _controller;
  Animation<double> _heightFactor;
  bool _isExpanded = false;
  bool _isOnHover = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _isExpanded = widget.node.expanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TreeNode oldWidget) {
    if (widget.node.expanded != oldWidget.node.expanded) {
      setState(() {
        _isExpanded = widget.node.expanded;
        if (_isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse().then<void>((void value) {
            if (!mounted) return;
            setState(() {});
          });
        }
      });
    } else if (widget.node != oldWidget.node) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  void _handleExpand() {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {});
        });
      }
    });
    if (_treeView.onExpansionChanged != null)
      _treeView.onExpansionChanged(widget.node.key, _isExpanded);
  }

  void _handleTap() {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    if (_treeView.onNodeTap != null) {
      _treeView.onNodeTap(widget.node.key);
    }
  }

  void _handleDoubleTap() {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    if (_treeView.onNodeDoubleTap != null) {
      _treeView.onNodeDoubleTap(widget.node.key);
    }
  }

  Widget _buildNodeLabel() {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    TreeViewTheme _theme = _treeView.theme;
    bool isSelected = _treeView.controller.selectedKey != null &&
        _treeView.controller.selectedKey == widget.node.key;
    final icon = _treeView.buildNodeIcon(
        widget.node.group, Size(_theme.iconTheme.size, _theme.iconTheme.size));
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: () => _handleExpand(),
          child: Container(width: 20, child: icon),
        ),
        Tooltip(
          message: widget.node.type,
          child: Text(
            widget.node.label,
            softWrap: false,
            overflow: TextOverflow.clip,
            style: widget.node.isParent
                ? _theme.parentLabelStyle.copyWith(
                    fontWeight: _theme.parentLabelStyle.fontWeight,
                    color: isSelected
                        ? _theme.colorScheme.onPrimary
                        : _theme.parentLabelStyle.color == TextStyle().color
                            ? _theme.colorScheme.onBackground
                            : _theme.parentLabelStyle.color,
                  )
                : _theme.labelStyle.copyWith(
                    fontWeight: _theme.labelStyle.fontWeight,
                    color: isSelected
                        ? _theme.colorScheme.onPrimary
                        : _theme.colorScheme.onBackground,
                  ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Text(
              widget.node.group ?? '',
              softWrap: false,
              overflow: TextOverflow.clip,
              style: _theme.labelStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _theme.colorScheme.onBackground.withOpacity(0.6),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNodeTitle() {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    TreeViewTheme _theme = _treeView.theme;
    bool isSelected = _treeView.controller.selectedKey != null &&
        _treeView.controller.selectedKey == widget.node.key;
    bool canSelectParent = _treeView.allowParentSelect;
    final labelContainer = _buildNodeLabel();
    Widget _tappable = _treeView.onNodeDoubleTap != null
        ? InkWell(
            hoverColor: Colors.blue,
            onTap: _handleTap,
            onDoubleTap: _handleDoubleTap,
            child: labelContainer,
          )
        : InkWell(
            hoverColor: Colors.blue,
            onTap: _handleTap,
            child: labelContainer,
          );
    if (widget.node.isParent) {
      if (_treeView.supportParentDoubleTap && canSelectParent) {
        _tappable = InkWell(
          onTap: canSelectParent ? _handleTap : _handleExpand,
          onDoubleTap: () {
            _handleExpand();
            _handleDoubleTap();
          },
          child: labelContainer,
        );
      } else if (_treeView.supportParentDoubleTap) {
        _tappable = InkWell(
          onTap: _handleExpand,
          onDoubleTap: _handleDoubleTap,
          child: labelContainer,
        );
      } else {
        _tappable = InkWell(
          onTap: canSelectParent ? _handleTap : _handleExpand,
          child: labelContainer,
        );
      }
    }
    return MouseRegion(
      onEnter: (_) {
        TreeView _treeView = TreeView.of(context);
        assert(_treeView != null, 'TreeView must exist in context');
        if (_treeView.onHover != null) {
          _treeView.onHover(widget.node.key);
        }
        setState(() {
          _isOnHover = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isOnHover = false;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: _theme.density,
          horizontal: 0,
        ),
        color: isSelected
            ? _theme.colorScheme.primary
            : _isOnHover || _treeView.shadowKey == widget.node.key
                ? _theme.colorScheme.primary.withOpacity(0.5)
                : _theme.colorScheme.background,
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: _tappable,
                ),
              ],
            ),
            if (_isOnHover)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                // mainAxisSize: MainAxisSize.min,
                children: TreeView.of(context)
                        .buildActionsWidgets(widget.node.key, Size(6, 6)) ??
                    [],
              )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    final bool closed =
        (!_isExpanded || !widget.node.expanded) && _controller.isDismissed;
    final nodeLabel = _buildNodeTitle();
    return widget.node.isParent
        ? AnimatedBuilder(
            animation: _controller.view,
            builder: (BuildContext context, Widget child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  nodeLabel,
                  ClipRect(
                    child: Align(
                      heightFactor: _heightFactor.value,
                      child: child,
                    ),
                  ),
                ],
              );
            },
            child: closed
                ? null
                : Container(
                    margin: EdgeInsets.only(left: _kIconSize / 2),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                        left: BorderSide(
                          width: 1.0,
                          color: _treeView.theme.colorScheme.primary,
                        ),
                      )),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: widget.node.children.map((Node node) {
                          return TreeNode(node: node);
                        }).toList(),
                      ),
                    ),
                  ),
          )
        : nodeLabel;
  }
}
