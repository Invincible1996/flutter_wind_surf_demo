import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/settings/presentation/cubit/theme_cubit.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init(); // Initialize dependency injection
  final prefs = await SharedPreferences.getInstance();
  final appRouter = AppRouter();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AuthBloc>(), // Use service locator
        ),
        BlocProvider(
          create: (context) => ThemeCubit(prefs),
        ),
      ],
      child: MyApp(appRouter: appRouter),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({
    super.key,
    required this.appRouter,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDarkMode) {
        return MaterialApp.router(
          title: 'Web Video Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(
            useMaterial3: true,
          ).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
          ),
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          routerConfig: appRouter.config(),
        );
      },
    );
  }
}
