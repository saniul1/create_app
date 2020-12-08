// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';

final prefs = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});
