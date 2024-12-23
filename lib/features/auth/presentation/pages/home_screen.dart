import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wind_surf_demo/features/auth/presentation/widgets/app_drawer.dart';
import 'package:flutter_wind_surf_demo/features/auth/presentation/widgets/match_list_item.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../routes/app_router.dart';
import '../../../match/presentation/providers/match_provider.dart';
import '../providers/auth_provider.dart';

@RoutePage()
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Widget buildTeamInfo({
    required String teamName,
    required String imageUrl,
    required bool isHome,
  }) {
    return Row(
      mainAxisAlignment:
          isHome ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        if (!isHome) ...[
          Flexible(
            child: Text(
              teamName,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            width: 40,
            height: 40,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        if (isHome) ...[
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              teamName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              context.router.push(const FavoriteRoute());
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
                      // Navigate to the AddMatchScreen
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
                return MatchListItem(
                  match: matches[index],
                  buildTeamInfo: buildTeamInfo,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
