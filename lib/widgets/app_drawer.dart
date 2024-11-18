import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../routes/app_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          AutoRouter.of(context).replace(const LoginRoute());
        }
      },
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Web Video Demo'),
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(state.user.name ?? state.user.email),
                      ),
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text('Settings'),
                        onTap: () {
                          AutoRouter.of(context).push(const SettingsRoute());
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text('Logout'),
                        onTap: () {
                          // context.read<AuthBloc>().add(LogoutRequested());
                          showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Logout'),
                                content: const Text(
                                    'Are you sure you want to logout?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child: const Text('Logout'),
                                  ),
                                ],
                              );
                            },
                          ).then((confirmed) {
                            if (confirmed ?? false) {
                              context.read<AuthBloc>().add(LogoutRequested());
                              AutoRouter.of(context).pushAndPopUntil(
                                  const LoginRoute(),
                                  predicate: (_) => false);
                            }
                          });
                        },
                      ),
                    ],
                  );
                } else {
                  return ListTile(
                    leading: const Icon(Icons.login),
                    title: const Text('Login'),
                    onTap: () {
                      AutoRouter.of(context).replace(const LoginRoute());
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
