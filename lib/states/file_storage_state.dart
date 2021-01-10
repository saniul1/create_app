import 'dart:async';
import 'dart:convert';
import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe
import 'package:create_app/states/app_view_state.dart';
import 'package:create_app/states/preferences_state.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:create_app/_utils/handle_assets.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:filepicker_windows/filepicker_windows.dart' as picker;
import 'package:create_app/models/pubspec.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:yaml/yaml.dart';
import 'package:flutter/widgets.dart';
import './tree_view_state.dart';

final fileStorage = ChangeNotifierProvider((ref) => FileStorage(ref));

class FileStorage extends ChangeNotifier {
  final ProviderReference _ref;
  FileStorage(ref) : _ref = ref;
  static final createAppFolderName = ".create_app_configs";
  String selectedFileName = "main.json";
  late Pubspec? _spec;
  Directory? _directory;
  Pubspec? get spec => _spec;
  Directory? get directory => _directory;

  Future<void> loadCurrentFile() async {
    final json = await File(
            '${_directory?.path}/$createAppFolderName/nodes/$selectedFileName')
        .readAsString();
    _ref.read(treeViewController).loadTreesFromJson(json);
  }

  Future<void> saveCurrentFile() async {
    // final contents = _ref.read(treeViewController).controller.toString();
    final contents = {
      "activeTree": _ref.read(treeViewController).activeTree,
      "views": _ref.read(appViewList).asMap,
      "trees": _ref.read(treeViewController).treesAsMap(),
    };
    await File(
            '${_directory?.path}/$createAppFolderName/nodes/$selectedFileName')
        .writeAsString(jsonEncode(contents));
  }

  Future<bool> loadPubSpec() async {
    try {
      final pubfile =
          await File('${_directory?.path}/pubspec.yaml').readAsString();
      _spec = Pubspec.fromMap(loadYaml(pubfile));
      if (_spec?.dependencies.keys.contains('flutter') ?? false)
        return true;
      else {
        print('not a flutter project.');
        return false;
      }
    } catch (e) {
      print('pubspec.yaml doesn\'t exist');
      return false;
    }
  }

  Future<bool> tryLastOpened() async {
    final path = _ref.read(prefs).data.value.getString('lastProject') ?? null;
    if (path != null) {
      _directory = Directory(path);
      selectedFileName = _ref.read(prefs).data.value.getString('lastFile');
      return true;
    }
    return false;
  }

  Future<void> setPaths() async {
    await _ref
        .read(prefs)
        .data
        .value
        .setString('lastProject', _directory?.path);
    await _ref.read(prefs).data.value.setString('lastFile', selectedFileName);
  }

  Future<bool> selectProject() async {
    await openDirectory("Select a folder");
    final isValidProject = await loadPubSpec();
    final isExist = await isCreateAppDirExist();
    if (!isExist && isValidProject) {
      await createAppDirectory();
    }
    if (isValidProject) await loadCurrentFile();
    await setPaths();
    return isValidProject;
  }

  Future<bool> createProject() async {
    await openDirectory("Select an empty folder to create a new project");
    final dirList = await dirContents();
    if (dirList.isEmpty) {
      await createPubSpec(name: _directory?.path.split(r'\').last ?? "My App");
      await createAppDirectory();
      await loadCurrentFile();
      await setPaths();
      return true;
    } else
      return false;
  }

  Future<void> openDirectory(String title) async {
    final file = picker.DirectoryPicker();
    file.title = title;
    _directory = file.getDirectory();
  }

  Future createAppDirectory() async {
    try {
      await Directory('${_directory?.path}/$createAppFolderName').create();
      final exampleMain = await loadJsonAsset('assets/mock_tree.json');
      final file =
          await File('${_directory?.path}/$createAppFolderName/nodes/main.json')
              .create(recursive: true);
      await file.writeAsString(exampleMain);
    } catch (e) {
      print('Error creating project.');
    }
  }

  Future<bool> isCreateAppDirExist() async {
    final isExist =
        await Directory('${_directory?.path}/$createAppFolderName').exists();
    return isExist;
  }

  Future<List<FileSystemEntity>> dirContents() {
    var files = <FileSystemEntity>[];
    var completer = Completer<List<FileSystemEntity>>();
    var lister = _directory?.list(recursive: false);
    lister?.listen((file) => files.add(file),
        // should also register onError
        onDone: () => completer.complete(files));
    return completer.future;
  }

  Future createPubSpec(
      {required String name, String sdk = ">=2.12.0-0 <3.0.0"}) async {
    await File('${_directory?.path}/pubspec.yaml').writeAsString('''
name: "$name"
description: A new Create-App Flutter project.

# The following line prevents the package from being accidentally published to
# pub.dev using `pub publish`. This is preferred for private packages.
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: "$sdk"

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter

# The following section is specific to Flutter.
flutter:
  uses-material-design: true
  # To add assets to your application, add an assets section, like this:
  # assets:
    # - images/a_dot_burr.jpeg
''');
  }
}
