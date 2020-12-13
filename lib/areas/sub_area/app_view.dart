import 'package:create_app/states/app_builder_state.dart';
import 'package:create_app/states/app_view_state.dart';
import 'package:create_app/states/tools_state.dart';
import 'package:create_app/states/tree_view_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_hooks/flutter_hooks.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppView extends HookWidget {
  AppView({required this.key}) : super(key: key);
  final ValueKey key;
  @override
  Widget build(BuildContext context) {
    final currentTool = useProvider(selectedTool);
    final _count = useState(0);
    final build = useProvider(appBuildController);
    useEffect(() {
      return;
    }, const []);
    final node = context.read(appViewList).getNodeId(key.value);
    // print(build.controller.children.first.params);
    // print(build.controller.getNode(node)?.toCode());
    return build.controller.getNode(node)?.toWidget(
            (child, key) => WidgetWrapper(id: key, child: child),
            currentTool.state == ToolType.select,
            build.resolveWidgetModelPropertyData) ??
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: Text("My App"),
            ),
            body: WidgetWrapper(
              id: 'body',
              child: Center(child: Text('count is ${_count.value}')),
            ),
            floatingActionButton: WidgetWrapper(
              id: "floatingActionButton",
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  _count.value += 1;
                },
              ),
            ),
          ),
        );
  }
}

class WidgetWrapper extends HookWidget {
  const WidgetWrapper({
    Key? key,
    required this.child,
    required this.id,
  }) : super(key: key);

  final Widget child;
  final String id;

  @override
  Widget build(BuildContext context) {
    final currentTool = useProvider(selectedTool);
    final tree = useProvider(treeViewController);
    final isHover = useState(false);
    return InkWell(
      mouseCursor: currentTool.state == ToolType.select
          ? SystemMouseCursors.none
          : SystemMouseCursors.basic,
      onTap: currentTool.state == ToolType.select
          ? () {
              tree.selectNode(id);
            }
          : null,
      onHover: currentTool.state == ToolType.select
          ? (value) {
              isHover.value = value;
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          // color: isHover.value ? Colors.yellow.withOpacity(0.2) : null,
          border:
              currentTool.state == ToolType.select && tree.selectedKey == id ||
                      isHover.value
                  ? Border.all(width: 1, color: Colors.deepOrange)
                  : null,
        ),
        child: child,
      ),
    );
  }
}
