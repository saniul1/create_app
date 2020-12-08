class WidgetDataModel<T> {
  final String label;
  final T value;
  final String type;
  final inherit;
  WidgetDataModel({
    required this.label,
    required this.value,
    required this.type,
    required this.inherit,
  });

  factory WidgetDataModel.fromMap(String label, T value, String type, inherit) {
    return WidgetDataModel(
        label: label, value: value, type: type, inherit: inherit);
  }

  WidgetDataModel copyWith({String? label, value, String? type, inherit}) =>
      WidgetDataModel(
        label: label ?? this.label,
        value: value ?? this.value,
        type: type ?? this.type,
        inherit: inherit ?? this.inherit,
      );

  Map get asMap => {
        'label': label,
        'value': value,
        'type': type,
        'inherit': inherit,
      };
}
