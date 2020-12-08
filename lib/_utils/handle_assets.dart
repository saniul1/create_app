import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadJsonAsset(String asset) async {
  final json = await rootBundle.loadString(asset);
  return json;
}

toJson(Map map) {
  print(jsonEncode(map));
}
