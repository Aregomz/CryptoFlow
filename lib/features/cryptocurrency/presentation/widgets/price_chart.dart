import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PriceChart extends StatelessWidget {
  final List<double> prices;
  final Color lineColor;

  const PriceChart({
    super.key,
    required this.prices,
    required this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: _createSpots(),
              isCurved: true,
              color: lineColor,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: lineColor.withOpacity(0.1),
              ),
            ),
          ],
          lineTouchData: const LineTouchData(enabled: false),
        ),
      ),
    );
  }

  List<FlSpot> _createSpots() {
    return List.generate(prices.length, (index) {
      return FlSpot(index.toDouble(), prices[index]);
    });
  }
} 