import 'package:flutter/material.dart';
import '../../data/datasources/database_helper.dart';

class MatchListScreen extends StatefulWidget {
  const MatchListScreen({Key? key}) : super(key: key);

  @override
  _MatchListScreenState createState() => _MatchListScreenState();
}

class _MatchListScreenState extends State<MatchListScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  late Future<List<Map<String, dynamic>>> _matchesFuture;

  @override
  void initState() {
    super.initState();
    _matchesFuture = _databaseHelper.getAllMatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _matchesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No matches available'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final match = snapshot.data![index];
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
