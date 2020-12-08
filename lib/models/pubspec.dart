class Pubspec {
  final String name;
  final String description;
  final String version;
  final Map dependencies;
  Pubspec(
      {required this.name,
      required this.description,
      required this.version,
      required this.dependencies});

  factory Pubspec.fromMap(Map map) {
    try {
      String _name = map['name'] ?? '';
      String _desc = map['description'] ?? '';
      String _version = map['version'] ?? '';
      Map _dep = map['dependencies'] ?? {};
      return Pubspec(
          name: _name,
          description: _desc,
          version: _version,
          dependencies: _dep);
    } catch (e) {
      throw e;
    }
  }
}
