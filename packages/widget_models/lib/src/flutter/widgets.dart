import './types.dart';
import './model.dart';
import './models/text_model.dart';
import './models/center_model.dart';
import './models/container_model.dart';

// ignore: missing_return
ModelWidget getFlutterWidgetModelFromType(String key, FlutterWidgetType type) {
  switch (type) {
    case FlutterWidgetType.Text:
      return TextModel(key);
      break;
    case FlutterWidgetType.Center:
      return CenterModel(key);
      break;
    case FlutterWidgetType.Container:
      return ContainerModel(key);
      break;
    default:
      return null;
      break;
  }
}
