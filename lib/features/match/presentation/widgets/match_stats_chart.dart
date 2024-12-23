import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MatchStatsChart extends StatelessWidget {
  final Map<String, dynamic> match;

  const MatchStatsChart({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Match Statistics',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 100,
              barGroups: [
                _generateBarGroup(0, 'Possession', 55, 45),
                _generateBarGroup(1, 'Shots', 12, 8),
                _generateBarGroup(2, 'Passes', 450, 380),
              ],
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 0:
                          return const Text('Possession');
                        case 1:
                          return const Text('Shots');
                        case 2:
                          return const Text('Passes');
                        default:
                          return const Text('');
                      }
                    },
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: false),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(match['home_team'], Colors.blue),
            const SizedBox(width: 24),
            _buildLegendItem(match['away_team'], Colors.red),
          ],
        ),
      ],
    );
  }

  BarChartGroupData _generateBarGroup(
    int x,
    String title,
    double homeValue,
    double awayValue,
  ) {
    // Normalize values for possession
    if (title == 'Possession') {
      homeValue = 50;
      awayValue = 50;
    }

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: homeValue,
          color: Colors.blue,
          width: 12,
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: awayValue,
          color: Colors.red,
          width: 12,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String team, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          team,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
