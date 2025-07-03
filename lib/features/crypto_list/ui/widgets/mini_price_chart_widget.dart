import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';

class MiniPriceChartWidget extends StatelessWidget {
  final List<double> prices;
  final bool isPositive;

  const MiniPriceChartWidget({
    super.key,
    required this.prices,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty || prices.length < 2) {
      return const SizedBox(width: 80, height: 40);
    }

    final spots = prices.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();

    final minY = prices.reduce((a, b) => a < b ? a : b);
    final maxY = prices.reduce((a, b) => a > b ? a : b);
    final chartColor = isPositive ? AppColors.priceUp : AppColors.priceDown;

    return Container(
      width: 80,
      height: 40,
      decoration: BoxDecoration(
        color: chartColor.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(4),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (prices.length - 1).toDouble(),
          minY: minY * 0.98,
          maxY: maxY * 1.02,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: chartColor,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    chartColor.withAlpha(20),
                    chartColor,
                  ],
                ),
              ),
            ),
          ],
          lineTouchData: const LineTouchData(enabled: false),
        ),
      ),
    );
  }
}