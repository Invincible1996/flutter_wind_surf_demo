import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/database_helper.dart';

final databaseProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.instance;
});

final matchesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final database = ref.watch(databaseProvider);
  return database.getAllMatches();
});
