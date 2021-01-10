/// Denotes if the widget can have zero, one or multiple children
enum ParentType {
  SingleChild,
  MultipleChildren,
  End,
}

enum ChildType { widget, preferredSizeWidget }

enum FlutterWidgetType {
  Icon,
  Text,
  Center,
  Align,
  Stack,
  Row,
  Column,
  Container,
  MaterialApp,
  MaterialScaffold,
  MaterialFloatingActionButton,
  CustomWidget,
}
