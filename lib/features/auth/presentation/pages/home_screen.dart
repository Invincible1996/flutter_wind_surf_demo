import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../routes/app_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_drawer.dart';
import '../../../match/presentation/providers/match_provider.dart';

@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(matchesProvider);

    // Listen to auth state changes
    ref.listen<AsyncValue<bool>>(authNotifierProvider, (previous, next) {
      next.whenData((isAuthenticated) {
        if (!isAuthenticated) {
          context.router.replace(const LoginRoute());
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Implement add match functionality
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: matchesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (matches) {
          if (matches.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No matches yet',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement add match functionality
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Match'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () {
              return ref.refresh(matchesProvider.future);
            },
            child: ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          match['league'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _buildTeamInfo(
                                teamName: match['home_team'],
                                imageUrl: match['home_team_img'],
                                isHome: true,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  match['date'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  match['time'],
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: _buildTeamInfo(
                                teamName: match['away_team'],
                                imageUrl: match['away_team_img'],
                                isHome: false,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeamInfo({
    required String teamName,
    required String imageUrl,
    required bool isHome,
  }) {
    return Column(
      crossAxisAlignment:
          isHome ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.network(
            imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 50,
                height: 50,
                color: Colors.grey[300],
                child: const Icon(Icons.sports_soccer, color: Colors.grey),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          teamName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textAlign: isHome ? TextAlign.left : TextAlign.right,
        ),
      ],
    );
  }
}
