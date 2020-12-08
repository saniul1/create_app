// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';

final iconButtonSize = Provider((_) => 22.0);

final treeViewAreaSize = Provider<double>((ref) {
  final width = ref.watch(treeViewNotifier.state);
  return width;
});
final treeViewNotifier = StateNotifierProvider((ref) => TreeViewNotifier());

final propertyViewAreaSize = Provider<double>((ref) {
  final width = ref.watch(propertyViewNotifier.state);
  return width;
});
final propertyViewNotifier =
    StateNotifierProvider((ref) => PropertyViewNotifier());

class TreeViewNotifier extends StateNotifier<double> {
  TreeViewNotifier() : super(300.0);
  final maxWidth = 500.0;
  final minWidth = 200.0;
  void set(double newWidth) {
    if (newWidth < 50)
      hide();
    else {
      if (newWidth >= minWidth && newWidth <= maxWidth) {
        state = newWidth;
      } else {
        if (newWidth < minWidth)
          state = minWidth;
        else if (newWidth > maxWidth) state = maxWidth;
      }
    }
  }

  void reset() {
    state = 250;
  }

  void hide() {
    state = 0;
  }
}

class PropertyViewNotifier extends StateNotifier<double> {
  PropertyViewNotifier() : super(300.0);
  final maxWidth = 500.0;
  final minWidth = 300.0;
  void set(double newWidth) {
    if (newWidth < 50)
      hide();
    else {
      if (newWidth >= minWidth && newWidth <= maxWidth) {
        state = newWidth;
      } else {
        if (newWidth < minWidth)
          state = minWidth;
        else if (newWidth > maxWidth) state = maxWidth;
      }
    }
  }

  void reset() {
    state = 400;
  }

  void hide() {
    state = 0;
  }
}
