import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RevenueChart extends StatelessWidget {
  final List<double> weeklyRevenue;

  const RevenueChart({super.key, required this.weeklyRevenue});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _getMaxY(),
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: _getBottomTitles,
                reservedSize: 38,
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: _getBarGroups(),
        ),
      ),
    );
  }

  double _getMaxY() {
    double max = weeklyRevenue.fold(0, (prev, element) => element > prev ? element : prev);
    return max == 0 ? 100000 : max * 1.2;
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    const days = ['Sn', 'Sl', 'Rb', 'Km', 'Jm', 'Sb', 'Mg'];
    final index = value.toInt();
    if (index < 0 || index >= days.length) return const SizedBox.shrink();
    
    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(days[index], style: const TextStyle(fontSize: 10, color: Colors.grey)),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    return List.generate(weeklyRevenue.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: weeklyRevenue[i],
            color: const Color(0xFF1E3A8A),
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }
}
