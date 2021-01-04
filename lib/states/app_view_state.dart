import 'package:create_app/_helper/classes.dart';
import 'package:create_app/models/app_view_model.dart';
import 'package:create_app/states/app_builder_state.dart';
import 'package:flutter/widgets.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';

final zoomLevel = StateProvider((ref) => 1.0);

final offsetPos = StateProvider((ref) => Offset.zero);

final selectedApps = StateProvider<List<String>>((ref) => []);

final appViewList = ChangeNotifierProvider((ref) => AppViewListLayout(ref));

class AppViewListLayout with ChangeNotifier {
  ProviderReference _ref;
  AppViewListLayout(ProviderReference ref) : _ref = ref;
  final List<AppViewModel> _list = [];
  List<AppViewModel> get list => _list;

  void addAll(List<AppViewModel> list) {
    _list.addAll(list);
    _ref.read(appBuildController).buildApps();
    notifyListeners();
  }

  void add(AppViewModel app) {
    _list.add(app);
    _ref.read(appBuildController).buildApps();
    notifyListeners();
  }

  void remove(String node) {
    _ref.read(appBuildController).removeController(
        _list.firstWhere((element) => element.node == node).id);
    _list.removeWhere((element) => element.node == node);
    _ref.read(appBuildController).buildApps();
    notifyListeners();
  }

  int getIndex(String id) {
    return _list.indexWhere((element) => element.id == id);
  }

  AppViewModel getChild(String id) {
    return _list.firstWhere((element) => element.id == id);
  }

  String getNodeId(String id) {
    return _list.firstWhere((element) => element.id == id).node;
  }

  Offset getOffset(String id) {
    return _list.firstWhere((element) => element.id == id).offset;
  }

  alignVertical() {
    _ref.read(selectedApps).state.forEach((id) {
      getChild(id).offset = Offset(getChild(id).offset.dx,
          getChild(_ref.read(selectedApps).state.first).offset.dy);
    });
    notifyListeners();
  }

  alignHorizontal() {
    _ref.read(selectedApps).state.forEach((id) {
      getChild(id).offset = Offset(
          getChild(_ref.read(selectedApps).state.first).offset.dx,
          getChild(id).offset.dy);
    });
    notifyListeners();
  }

  void makeCenter() {
    var first = Offset.zero;
    Offset second = Offset.zero;
    Offset? distanceFromCenter;
    _ref.read(selectedApps).state.forEach((id) {
      final childOffset = getChild(id).offset;
      if (first == Offset.zero) first = childOffset;
      if (childOffset.dx < first.dx || childOffset.dy < first.dy)
        first = childOffset;
      if (second == Offset.zero) second = first;
      if (childOffset.dx > second.dx || childOffset.dy > second.dy)
        second = childOffset;
    });
    if (first == second)
      distanceFromCenter = first;
    else
      distanceFromCenter = first + (second - first) / 2;
    _list.forEach((element) {
      element.offset -= distanceFromCenter!;
    });
    notifyListeners();
  }

  void updateOffsetBy(String id, Offset offset) {
    final i = getIndex(id);
    final o = getOffset(id);
    final z = (1 - _ref.read(zoomLevel).state) * 4;
    _list[i].offset = (o + (offset * (z <= 1 ? 1 : z)));
    notifyListeners();
  }
}
