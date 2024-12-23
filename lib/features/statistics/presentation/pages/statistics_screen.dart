import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/match/data/datasources/database_helper.dart';

@RoutePage()
class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _matches = [];
  String _selectedLeague = 'All Leagues';
  List<String> _leagues = ['All Leagues'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final matches = await _databaseHelper.getAllMatches();
    final leagues = matches.map((m) => m['league'] as String).toSet().toList();
    setState(() {
      _matches = matches;
      _leagues = ['All Leagues', ...leagues];
    });
  }

  List<Map<String, dynamic>> get filteredMatches {
    if (_selectedLeague == 'All Leagues') {
      return _matches;
    }
    return _matches.where((m) => m['league'] == _selectedLeague).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: Column(
        children: [
          // League selector
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: _selectedLeague,
              isExpanded: true,
              items: _leagues.map((league) {
                return DropdownMenuItem(
                  value: league,
                  child: Text(league),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLeague = value;
                  });
                }
              },
            ),
          ),
          // Statistics cards
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Total matches card
                  _buildStatCard(
                    title: 'Total Matches',
                    value: filteredMatches.length.toString(),
                    icon: Icons.sports_soccer,
                  ),
                  const SizedBox(height: 16),
                  // Average possession chart
                  _buildChartCard(
                    title: 'Average Possession',
                    chart: _buildPieChart(),
                  ),
                  const SizedBox(height: 16),
                  // Shots and passes trends
                  _buildChartCard(
                    title: 'Match Statistics Trends',
                    chart: _buildLineChart(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required Widget chart,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: chart,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    double homeTotal = 0;
    double awayTotal = 0;

    for (var match in filteredMatches) {
      homeTotal += (match['home_possession'] ?? 50) as num;
      awayTotal += (match['away_possession'] ?? 50) as num;
    }

    final avgHome =
        homeTotal / (filteredMatches.isEmpty ? 1 : filteredMatches.length);
    final avgAway =
        awayTotal / (filteredMatches.isEmpty ? 1 : filteredMatches.length);

    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: avgHome,
            title: '${avgHome.toStringAsFixed(1)}%',
            color: Colors.blue,
            radius: 80,
          ),
          PieChartSectionData(
            value: avgAway,
            title: '${avgAway.toStringAsFixed(1)}%',
            color: Colors.red,
            radius: 80,
          ),
        ],
        sectionsSpace: 2,
      ),
    );
  }

  Widget _buildLineChart() {
    final spots = filteredMatches.asMap().entries.map((entry) {
      final match = entry.value;
      return FlSpot(
        entry.key.toDouble(),
        ((match['home_shots'] ?? 0) + (match['away_shots'] ?? 0)) / 2,
      );
    }).toList();

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: const FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Theme.of(context).primaryColor,
            barWidth: 3,
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
