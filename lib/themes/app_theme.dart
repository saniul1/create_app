import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/all.dart';

final themeMode = StateProvider((ref) => ThemeMode.system);
