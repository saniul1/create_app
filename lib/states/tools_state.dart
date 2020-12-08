// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum ToolType { none, select }

final selectedTool = StateProvider((ref) => ToolType.none);
