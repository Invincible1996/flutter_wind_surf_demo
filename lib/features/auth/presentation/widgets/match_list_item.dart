import 'package:flutter/material.dart';

class MatchListItem extends StatelessWidget {
  final Map<String, dynamic> match;
  final Widget Function({
    required String teamName,
    required String imageUrl,
    required bool isHome,
  }) buildTeamInfo;

  const MatchListItem({
    super.key,
    required this.match,
    required this.buildTeamInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  match['time'],
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  match['league'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: buildTeamInfo(
                    teamName: match['home_team'],
                    imageUrl: match['home_team_img'],
                    isHome: true,
                  ),
                ),
                // staus
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.sports_soccer,
                    size: 32,
                  ),
                ),
                Expanded(
                  child: buildTeamInfo(
                    teamName: match['away_team'],
                    imageUrl: match['away_team_img'],
                    isHome: false,
                  ),
                ),
                // appointment
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.star_border,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
