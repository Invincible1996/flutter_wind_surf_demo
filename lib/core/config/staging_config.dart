
import 'app_config.dart';

class StagingConfig {
  static const AppConfig stagingConfig =  AppConfig(
    appName: "MyApp Staging",
    apiBaseUrl: "https://staging-api.example.com",
    isDebug: true
  );
}
