import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class RevenueChart extends StatelessWidget {
  final List<double> weeklyRevenue;

  const RevenueChart({super.key, required this.weeklyRevenue});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1.8,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _getMaxY(),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => const Color(0xFF1E293B),
                  tooltipRoundedRadius: 8,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      'Rp ${rod.toY.toStringAsFixed(0)}',
                      GoogleFonts.firaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: _getBottomTitles,
                    reservedSize: 30,
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: _getBarGroups(),
            ),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
        ),
      ],
    );
  }

  double _getMaxY() {
    double max = weeklyRevenue.fold(
      0,
      (prev, element) => element > prev ? element : prev,
    );
    return max == 0 ? 100000 : max * 1.3;
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    final index = value.toInt();
    if (index < 0 || index >= days.length) return const SizedBox.shrink();

    return SideTitleWidget(
      meta: meta,
      space: 8,
      child: Text(
        days[index],
        style: GoogleFonts.firaSans(
          fontSize: 11,
          color: const Color(0xFF94A3B8),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    return List.generate(weeklyRevenue.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: weeklyRevenue[i],
            color: const Color(0xFF64748B),
            width: 14,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: _getMaxY(),
              color: const Color(0xFFF1F5F9),
            ),
          ),
        ],
      );
    });
  }
}
