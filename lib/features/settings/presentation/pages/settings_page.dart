import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/presentation/providers/theme_provider.dart';

@RoutePage()
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          themeState.when(
            data: (isDarkMode) => SwitchListTile(
              secondary: const Icon(Icons.dark_mode),
              title: const Text('Dark Mode'),
              value: isDarkMode,
              onChanged: (_) {
                ref.read(themeNotifierProvider.notifier).toggleTheme();
              },
            ),
            loading: () => const ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Loading theme preference...'),
            ),
            error: (error, _) => ListTile(
              leading: const Icon(Icons.error),
              title: Text('Error: $error'),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
          ),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
          ),
        ],
      ),
    );
  }
}
