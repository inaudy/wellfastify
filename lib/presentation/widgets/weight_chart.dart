import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wellfastify/models/weight_model.dart';

class DynamicWeightChart extends StatelessWidget {
  final List<Weight> weightData;

  const DynamicWeightChart({super.key, required this.weightData});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      weightData.isEmpty ? _emptyChart() : _chartWithData(),
    );
  }

  LineChartData _emptyChart() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false, // Disable vertical grid lines
        horizontalInterval: 5, // Set horizontal lines every 5 units
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.grey, // Grid line color
            strokeWidth: 1, // Grid line thickness
          );
        },
      ),
      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false), //
        ),
        bottomTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false), // Hide bottom titles
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false), // Hide top titles
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 5, // Show Y-axis titles at 5-unit intervals
            getTitlesWidget: (value, meta) {
              if (value >= 60 && value <= 80) {
                return Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: Colors.black, fontSize: 10),
                  ),
                );
              }
              return Container(); // Hide other Y-axis labels
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: Colors.black, width: 1),
      ),
      minX: 0,
      maxX: 1, // Placeholder X-axis range for an empty chart
      minY: 60,
      maxY: 80, // Set Y-axis range between 60 and 80
      lineBarsData: [
        LineChartBarData(
          spots: [], // No data points for the empty chart
          isCurved: false,
          barWidth: 3,
          color: Colors.transparent, // Hide the line
          belowBarData: BarAreaData(show: false),
          dotData: const FlDotData(show: false), // Hide dots
        ),
      ],
    );
  }

  LineChartData _chartWithData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false, // Disable vertical grid lines
        horizontalInterval:
            _calculateYInterval(), // Dynamic interval for grid lines
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.grey, // Grid line color
            strokeWidth: 1, // Grid line thickness
          );
        },
      ),
      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index < 0 || index >= weightData.length) return Container();

              String dateLabel =
                  DateFormat('M/d').format(weightData[index].date);
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Container(
                  margin: const EdgeInsets.only(top: 2),
                  child: Text(
                    dateLabel,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                  ),
                ),
              );
            },
            reservedSize: 32,
            interval: 1,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: _calculateYInterval(), // Dynamic Y-axis interval
            getTitlesWidget: (value, meta) {
              return Container(
                margin: const EdgeInsets.only(left: 20),
                child: Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.left,
                ),
              );
            },
            reservedSize: 40,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: Colors.black, width: 1),
      ),
      minX: 0,
      maxX: weightData.length.toDouble() - 1,
      minY: _calculateMinY(),
      maxY: _calculateMaxY(),
      lineBarsData: [
        LineChartBarData(
          spots: _getSpots(),
          isCurved: false, // No curve
          barWidth: 3,
          color: Colors.blue,
          belowBarData:
              BarAreaData(show: false), // No shaded area below the line
          dotData: const FlDotData(show: true), // Show dots on data points
        ),
      ],
    );
  }

  List<FlSpot> _getSpots() {
    return weightData.asMap().entries.map((entry) {
      int index = entry.key;
      Weight data = entry.value;
      return FlSpot(index.toDouble(), data.weight);
    }).toList();
  }

  double _calculateMinY() {
    if (weightData.isEmpty) return 0;

    double minWeight =
        weightData.map((data) => data.weight).reduce((a, b) => a < b ? a : b);
    return (minWeight ~/ _calculateYInterval()) *
        _calculateYInterval(); // Round down to nearest interval
  }

  double _calculateMaxY() {
    if (weightData.isEmpty) return 1; // Default max value for empty chart

    double maxWeight =
        weightData.map((data) => data.weight).reduce((a, b) => a > b ? a : b);
    return ((maxWeight / _calculateYInterval()).ceil()) *
        _calculateYInterval(); // Round up to nearest interval
  }

  double _calculateYInterval() {
    if (weightData.isEmpty) return 1; // Default interval for empty chart

    double minWeight =
        weightData.map((data) => data.weight).reduce((a, b) => a < b ? a : b);
    double maxWeight =
        weightData.map((data) => data.weight).reduce((a, b) => a > b ? a : b);
    double range = maxWeight - minWeight;

    // Determine the interval based on the range
    if (range <= 20) {
      return 5;
    } else if (range <= 50) {
      return 10;
    } else if (range <= 100) {
      return 20;
    } else if (range <= 200) {
      return 50;
    } else {
      return 100; // For very large ranges, use a larger interval
    }
  }
}
