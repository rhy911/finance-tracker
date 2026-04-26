import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/database/transaction.dart' as db;

class StatisticChart extends StatelessWidget {
  final List<db.Transaction> transactions;
  final String period;
  final bool isIncome;

  const StatisticChart({
    super.key,
    required this.transactions,
    this.period = 'Month',
    this.isIncome = false,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(child: Text('No ${isIncome ? 'income' : 'expense'} data for this period'));
    }

    final currencyFormat = NumberFormat.compactCurrency(locale: 'vi_VN', symbol: '₫');
    final Map<double, double> groupedMap = {};
    
    switch (period) {
      case 'Day':
        for (var t in transactions) {
          final hour = t.timestamp.hour.toDouble();
          groupedMap[hour] = (groupedMap[hour] ?? 0) + t.amount;
        }
        break;
      case 'Week':
        for (var t in transactions) {
          final weekday = t.timestamp.weekday.toDouble();
          groupedMap[weekday] = (groupedMap[weekday] ?? 0) + t.amount;
        }
        break;
      case 'Month':
        for (var t in transactions) {
          final day = t.timestamp.day.toDouble();
          groupedMap[day] = (groupedMap[day] ?? 0) + t.amount;
        }
        break;
      case 'Year':
        for (var t in transactions) {
          final month = t.timestamp.month.toDouble();
          groupedMap[month] = (groupedMap[month] ?? 0) + t.amount;
        }
        break;
    }

    final spots = groupedMap.entries
        .map((e) => FlSpot(e.key, e.value))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));

    if (spots.isEmpty) {
      return const Center(child: Text('No transaction spots found'));
    }

    // Ensure chart has at least 2 points to draw line
    if (spots.length == 1) {
      final sole = spots[0];
      spots.insert(0, FlSpot(sole.x - 0.5, 0));
      spots.add(FlSpot(sole.x + 0.5, 0));
    }

    final chartColor = isIncome ? Colors.green : const Color(0xFF438883);

    return LineChart(
      LineChartData(
        minX: _getMinX(),
        maxX: _getMaxX(),
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                String text = '';
                switch (period) {
                  case 'Day':
                    if (value % 4 == 0) text = '${value.toInt()}:00';
                    break;
                  case 'Week':
                    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                    int idx = value.toInt() - 1;
                    if (idx >= 0 && idx < days.length) text = days[idx];
                    break;
                  case 'Month':
                    if (value % 5 == 0 || value == 1) text = value.toInt().toString();
                    break;
                  case 'Year':
                    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                    int idx = value.toInt() - 1;
                    if (idx >= 0 && idx < months.length) text = months[idx];
                    break;
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(text, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: false,
            color: chartColor,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: chartColor.withValues(alpha: 0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => chartColor,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((barSpot) {
                return LineTooltipItem(
                  currencyFormat.format(barSpot.y),
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  double _getMinX() {
    switch (period) {
      case 'Day': return 0;
      case 'Week': return 1;
      case 'Month': return 1;
      case 'Year': return 1;
      default: return 0;
    }
  }

  double _getMaxX() {
    switch (period) {
      case 'Day': return 23;
      case 'Week': return 7;
      case 'Month': return 31;
      case 'Year': return 12;
      default: return 0;
    }
  }
}
