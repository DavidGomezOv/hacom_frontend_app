class FlavorConfig {
  final String name;
  final String apiBaseUrl;

  FlavorConfig._internal(this.name, this.apiBaseUrl);

  static late FlavorConfig instance;

  factory FlavorConfig({
    required String name,
    required String apiBaseUrl,
  }) {
    instance = FlavorConfig._internal(name, apiBaseUrl);
    return instance;
  }
}
