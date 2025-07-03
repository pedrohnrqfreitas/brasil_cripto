import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

/// Widget de gráfico de preços para criptomoedas
class PriceChartWidget extends StatelessWidget {
  final List<List<double>> prices; // [[timestamp, price], ...]
  final bool isPositive;

  const PriceChartWidget({
    super.key,
    required this.prices,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty) {
      return const Center(
        child: Text('Dados de preço não disponíveis'),
      );
    }

    final spots = prices.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value[1]);
    }).toList();

    final minPrice = prices.map((p) => p[1]).reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.map((p) => p[1]).reduce((a, b) => a > b ? a : b);
    final priceRange = maxPrice - minPrice;

    final chartColor = isPositive ? Colors.green : Colors.red;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: priceRange / 4,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[300]!,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: prices.length / 4,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= prices.length) return const Text('');

                final timestamp = prices[value.toInt()][0];
                final date = DateTime.fromMillisecondsSinceEpoch(timestamp.toInt());
                final formatter = DateFormat('dd/MM');

                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    formatter.format(date),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              interval: priceRange / 4,
              getTitlesWidget: (value, meta) {
                final formatter = NumberFormat.compact(locale: 'pt_BR');
                return Text(
                  'R\$ ${formatter.format(value)}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!),
            left: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        minX: 0,
        maxX: (prices.length - 1).toDouble(),
        minY: minPrice * 0.98,
        maxY: maxPrice * 1.02,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                chartColor.withAlpha(80),
                chartColor,
              ],
            ),
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  chartColor.withAlpha(20),
                  chartColor
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Theme.of(context).cardColor,
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 8,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final price = barSpot.y;
                final timestamp = prices[barSpot.x.toInt()][0];
                final date = DateTime.fromMillisecondsSinceEpoch(timestamp.toInt());
                final dateFormatter = DateFormat('dd/MM/yyyy HH:mm');
                final priceFormatter = NumberFormat.currency(
                  locale: 'pt_BR',
                  symbol: r'R$',
                );

                return LineTooltipItem(
                  '${priceFormatter.format(price)}\n${dateFormatter.format(date)}',
                  const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
          getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
            return spotIndexes.map((spotIndex) {
              return TouchedSpotIndicatorData(
                FlLine(
                  color: chartColor.withAlpha(30),
                  strokeWidth: 2,
                  dashArray: [5, 5],
                ),
                FlDotData(
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 6,
                      color: Colors.white,
                      strokeWidth: 3,
                      strokeColor: chartColor,
                    );
                  },
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}