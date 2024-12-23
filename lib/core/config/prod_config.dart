import 'app_config.dart';

///  production  AppConfig
class ProdConfig {
  ///  production  AppConfig
  static const AppConfig prodConfig = AppConfig(
    ///  App 
    appName: "MyApp Prod",
    /// API 
    apiBaseUrl: "https://prod-api.example.com",
    ///  debug 
    isDebug: false
  );
}