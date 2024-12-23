class AppConfig {
  final String appName;
  final String apiBaseUrl;
  final bool isDebug;
  
  const AppConfig({
    required this.appName,
    required this.apiBaseUrl,
    this.isDebug = false,
  });
}

class Environment {
  static late AppConfig _config;

  static void setConfig(AppConfig config) {
    _config = config;
  }

  static AppConfig get config => _config;
}