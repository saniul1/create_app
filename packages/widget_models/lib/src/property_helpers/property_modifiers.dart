import '../../src/flutter/model.dart';
import '../property.dart';

attachModifiers(ModelWidget widget, String paramKey) {
  final type = widget.paramTypes[paramKey];
  widget.modifiers[paramKey] = {};
  switch (type) {
    case PropertyType.integer:
      widget.modifiers[paramKey]['addition'] = (int i, [String condition]) {
        if (_numConditionCheck(widget, condition, widget.params[paramKey]))
          widget.params[paramKey] += i;
      };
      widget.modifiers[paramKey]['subtraction'] = (int i, [String condition]) {
        if (_numConditionCheck(widget, condition, widget.params[paramKey]))
          widget.params[paramKey] -= i;
      };
      widget.modifiers[paramKey]['multiplication'] =
          (int i, [String condition]) {
        if (_numConditionCheck(widget, condition, widget.params[paramKey]))
          widget.params[paramKey] *= i;
      };
      widget.modifiers[paramKey]['division'] = (int i, [String condition]) {
        if (_numConditionCheck(widget, condition, widget.params[paramKey]))
          widget.params[paramKey] *= i;
      };
      widget.modifiers[paramKey]['set'] = (int i, [String condition]) {
        if (_numConditionCheck(widget, condition, widget.params[paramKey]))
          widget.params[paramKey] = i;
      };
      break;
    default:
  }
}

bool _numConditionCheck(ModelWidget widget, String statement, num value) {
  if (statement == null) return true;
  final conditions = statement.split(',');
  bool result = false;
  for (var condition in conditions) {
    // "> $count" || "< 10"
    final num v = condition.contains('\$')
        ? widget.params[condition.substring(condition.indexOf('\$') + 1).trim()]
        : double.tryParse(
            condition.substring(condition.indexOf(' ') + 1).trim());
    print(v);
    if (condition.contains('>')) {
      result = value > v;
    }
    if (condition.contains('<')) {
      result = value < v;
    }
    if (condition.contains('=')) {
      result = value == v;
    }
    if (condition.contains('!')) {
      result = value != v;
    }
  }
  return result;
}
