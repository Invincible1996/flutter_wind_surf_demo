import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../ranking/domain/models/ranking_item.dart';

@RoutePage()
class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  // Sample data for sales rankings
  final List<RankingItem> _salesRankings = [
    RankingItem(rank: 1, name: '金小迪', bu: '浦西.顾问一组', value: 10000000, secondaryValue: 316000),
    RankingItem(rank: 2, name: '许昌杰', bu: '浦东.顾问一组', value: 9200000, secondaryValue: 278000),
    RankingItem(rank: 3, name: '朱小帅', bu: '浦西.顾问二组', value: 8000000, secondaryValue: 268000),
    RankingItem(rank: 4, name: '李小明', bu: '浦西.顾问二组', value: 8000000, secondaryValue: 268000),
    RankingItem(rank: 5, name: '赵小晶', bu: '浦东.顾问一组', value: 8000000, secondaryValue: 268000),
    RankingItem(rank: 6, name: '杜有为', bu: '浦西.顾问二组', value: 8000000, secondaryValue: 268000),
    // Add more items...
  ];

  // Sample data for best sign-ups
  final List<RankingItem> _signupRankings = [
    RankingItem(rank: 1, name: '武小松', bu: '浦西.顾问一组', value: 1000, secondaryValue: 68),
    RankingItem(rank: 2, name: '赵小晶', bu: '浦东.顾问一组', value: 992, secondaryValue: 60),
    RankingItem(rank: 3, name: '杜有为', bu: '浦西.顾问二组', value: 800, secondaryValue: 50),
    // Add more items...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://va-papers.oss-accelerate.aliyuncs.com/oss-platform/eaca/8004/b706/a4cf0789-607b-4008-acae-85b5f4775eaf.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildRankingTable(
                          title: '销售业绩榜',
                          icon: Icons.trending_up,
                          iconColor: Colors.purple,
                          data: _salesRankings,
                          columns: const ['姓名', 'BU', '累计销售额', '当月销售额'],
                          valueFormatter: (value) => '${(value / 10000).toStringAsFixed(1)}w',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildRankingTable(
                          title: '最佳新签榜',
                          icon: Icons.person_add,
                          iconColor: Colors.pink,
                          data: _signupRankings,
                          columns: const ['姓名', 'BU', '累计人数', '当月人数'],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildRankingTable(
                          title: '转介绍新签榜',
                          icon: Icons.thumb_up,
                          iconColor: Colors.blue,
                          data: _salesRankings,
                          columns: const ['姓名', 'BU', '累计人数', '当月人数'],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildRankingTable(
                          title: '最佳新人榜',
                          icon: Icons.group,
                          iconColor: Colors.cyan,
                          data: _signupRankings,
                          columns: const ['姓名', 'BU', '累计销售额', '达标50w时间', '月均销售额'],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankingTable({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<RankingItem> data,
    required List<String> columns,
    String Function(dynamic)? valueFormatter,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: columns
                  .map((column) => Expanded(
                        child: Text(
                          column,
                          style: TextStyle(
                            color: Colors.blue[200],
                            fontSize: 12,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const Divider(color: Colors.blue, height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: index < 3
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            _buildRankBadge(item.rank),
                            const SizedBox(width: 8),
                            Text(
                              item.name,
                              style: TextStyle(
                                color: index < 3 ? Colors.yellow : Colors.white,
                                fontWeight:
                                    index < 3 ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item.bu,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          valueFormatter != null
                              ? valueFormatter(item.value)
                              : item.value.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item.secondaryValue.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    Color badgeColor;
    if (rank == 1) {
      badgeColor = Colors.amber;
    } else if (rank == 2) {
      badgeColor = Colors.grey[400]!;
    } else if (rank == 3) {
      badgeColor = Colors.brown;
    } else {
      badgeColor = Colors.blue;
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: badgeColor),
      ),
      child: Center(
        child: Text(
          rank.toString(),
          style: TextStyle(
            color: badgeColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
