import 'package:widget_models/src/flutter/models/custom_widget_model.dart';

import './types.dart';
import './model.dart';
import './models/text_model.dart';
import './models/center_model.dart';
import './models/container_model.dart';
import './models/material_app_model.dart';
import './models/material_scaffold_model.dart';
import './models/material_floating-action_button_model.dart';
import './models/icon_model.dart';
import './models/column_model.dart';

ModelWidget? getFlutterWidgetModelFromType(
    String key, String? group, FlutterWidgetType type) {
  switch (type) {
    case FlutterWidgetType.Icon:
      return IconModel(key, group);
    case FlutterWidgetType.Text:
      return TextModel(key, group);
    case FlutterWidgetType.Center:
      return CenterModel(key, group);
    case FlutterWidgetType.Column:
      return ColumnModel(key, group);
    case FlutterWidgetType.Container:
      return ContainerModel(key, group);
    case FlutterWidgetType.MaterialFloatingActionButton:
      return MaterialFloatingActionButtonModel(key, group);
    case FlutterWidgetType.MaterialScaffold:
      return MaterialScaffoldModel(key, group);
    case FlutterWidgetType.MaterialApp:
      return MaterialAppModel(key, group);
    case FlutterWidgetType.CustomWidget:
      return CustomModel(key, group);
    default:
      return null;
  }
}
