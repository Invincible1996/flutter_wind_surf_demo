import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/theme_cubit.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          BlocBuilder<ThemeCubit, bool>(
            builder: (context, isDarkMode) {
              return SwitchListTile(
                secondary: const Icon(Icons.dark_mode),
                title: const Text('Dark Mode'),
                value: isDarkMode,
                onChanged: (value) {
                  context.read<ThemeCubit>().toggleTheme();
                },
              );
            },
          ),
          const ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            // TODO: Implement language selection
          ),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            // TODO: Implement about section
          ),
        ],
      ),
    );
  }
}
