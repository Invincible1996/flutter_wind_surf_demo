import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/config/app_config.dart';
import 'core/config/dev_config.dart';
import 'core/config/prod_config.dart';
import 'features/theme/presentation/providers/theme_provider.dart';
import 'routes/app_router.dart';

void main() async {
  // 根据启动参数设置环境
  const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  switch (flavor) {
    case 'prod':
      Environment.setConfig(ProdConfig.prodConfig);
      break;
    case 'stage':
      Environment.setConfig(ProdConfig.prodConfig);
      break;
    case 'dev':
    default:
      Environment.setConfig(DevConfig.devConfig);
      break;
  }

  WidgetsFlutterBinding.ensureInitialized();
  final appRouter = AppRouter();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: MyApp(appRouter: appRouter),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final AppRouter appRouter;

  const MyApp({
    super.key,
    required this.appRouter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeNotifierProvider);
    final config = Environment.config;
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: config.appName,
      theme: ThemeData.light(
        useMaterial3: true,
      ).copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.indigo,
            // minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
        ),
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            // minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
        ),
      ),
      themeMode: isDarkMode.when(
        data: (isDark) => isDark ? ThemeMode.dark : ThemeMode.light,
        loading: () => ThemeMode.system,
        error: (e, s) => ThemeMode.system,
      ),
      routerConfig: appRouter.config(),
    );
  }
}
