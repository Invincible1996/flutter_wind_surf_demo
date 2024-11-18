import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_video_demo/routes/app_router.dart';
import 'package:web_video_demo/web_view_page.dart';
import 'package:web_video_demo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:web_video_demo/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:web_video_demo/widgets/app_drawer.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          AutoRouter.of(context).replace(const LoginRoute());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            BlocBuilder<ThemeCubit, bool>(
              builder: (context, isDarkMode) {
                return IconButton(
                  icon: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  ),
                  onPressed: () {
                    context.read<ThemeCubit>().toggleTheme();
                  },
                );
              },
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AuthAuthenticated) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Welcome ${state.user.name ?? state.user.email}!'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const WebViewPage()),
                        );
                      },
                      child: const Text('Go to Video Demo'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('Please login to continue'));
          },
        ),
      ),
    );
  }
}
