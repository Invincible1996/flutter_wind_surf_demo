import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_video_demo/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:web_video_demo/features/theme/presentation/bloc/theme_event.dart';
import 'package:web_video_demo/features/theme/presentation/bloc/theme_state.dart';
import 'package:web_video_demo/routes/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<ThemeBloc>()..add(LoadTheme()),
        ),
        BlocProvider(
          create: (context) => di.sl<AuthBloc>(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Web Video Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routerConfig: _appRouter.config(),
          );
        },
      ),
    );
  }
}
