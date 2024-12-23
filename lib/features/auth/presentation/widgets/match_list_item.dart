import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              match['date'],
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
          const SizedBox(height: 12),
          // Match details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: buildTeamInfo(teamName: match['home_team'], imageUrl: match['home_team_img'], isHome: true)),
              Text(
                match['time'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(child: buildTeamInfo(teamName: match['away_team'], imageUrl: match['away_team_img'], isHome: false)),
            ],
          ),
        ],
      ),
    );
  }
}

// 优化后的 buildTeamInfo 实现
Widget buildTeamInfoExample({
  required String teamName,
  required String imageUrl,
  required bool isHome,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Row(
        mainAxisAlignment:
            isHome ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (!isHome)
            Flexible(
              child: Text(
                teamName,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.2,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.sports_soccer,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          if (isHome)
            Flexible(
              child: Text(
                teamName,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.2,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      );
    },
  );
}

// 使用示例
class MatchListExample extends StatelessWidget {
  const MatchListExample({super.key});

  @override
  Widget build(BuildContext context) {
    // 测试数据，包含长队名
    final sampleMatch = {
      'time': '21:00',
      'league': '传奇杯S2小组赛',
      'home_team': '皇家社会足球俱乐部', // 长队名测试
      'away_team': '曼彻斯特联足球俱乐部', // 长队名测试
      'home_team_img': 'https://example.com/home.png',
      'away_team_img': 'https://example.com/away.png',
    };

    return MatchListItem(
      match: sampleMatch,
      buildTeamInfo: buildTeamInfoExample,
    );
  }
}
