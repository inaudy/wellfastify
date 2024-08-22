import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:wellfastify/models/fasting_model.dart';

class BarChartSample extends StatelessWidget {
  final List<Fasting> fastingTimes;

  const BarChartSample({super.key, required this.fastingTimes});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BarChart(
          BarChartData(
            barTouchData: barTouchData,
            titlesData: titlesData,
            borderData: borderData,
            barGroups: barGroups(),
            gridData: const FlGridData(show: false),
            alignment: BarChartAlignment.spaceAround,
            maxY: 24, // Adjust as needed
          ),
        ),
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return null;
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontSize: 12,
    );
    int index = value.toInt();
    if (index < 0 || index >= 7) {
      return Container(); // Only show titles for 7 days
    }
    DateTime date = DateTime.now().subtract(Duration(days: 6 - index));
    String dayLetter = DateFormat.EEEE().format(date)[0];

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(dayLetter, style: style),
    );
  }

  Widget getTitlesX(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontSize: 12,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0h';
        break;
      case 6:
        text = '6';
        break;
      case 12:
        text = '12';
        break;
      case 18:
        text = '18';
        break;
      case 24:
        text = '24';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: getTitlesX,
              interval: 6),
        ),
      );

  FlBorderData get borderData => FlBorderData(show: false);

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Colors.indigo,
          Colors.blue,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> barGroups() {
    // Create a list with the last 7 days
    final lastSevenDays = List.generate(7, (index) {
      final dayIndex = 6 - index; // To start from the most recent day
      final date = DateTime.now().subtract(Duration(days: dayIndex));
      final fastingData = fastingTimes.firstWhere(
        (fasting) =>
            fasting.startTime.year == date.year &&
            fasting.startTime.month == date.month &&
            fasting.startTime.day == date.day,
        orElse: () => Fasting(
            startTime: date, fastingHours: 0, endTime: date, date: date),
      );

      final fastingTime =
          fastingData.fastingHours / 3600.0; // Convert seconds to hours

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            backDrawRodData: BackgroundBarChartRodData(
                color: Colors.blue[50], show: true, toY: 24),
            width: 14,
            toY: fastingTime,
            gradient: _barsGradient,
          )
        ],
        showingTooltipIndicators: [0],
      );
    });

    return lastSevenDays;
  }
}
