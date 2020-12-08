// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppInfo {
  AppInfo(
      {required this.appName,
      this.packageName,
      required this.version,
      this.buildNumber});

  final String appName;
  final String version;
  final String? packageName;
  final String? buildNumber;
}

final appInfo =
    Provider((ref) => AppInfo(appName: 'Create App', version: "0.0.1"));
