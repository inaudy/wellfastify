import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartSample extends StatelessWidget {
  final List<Map<String, dynamic>> fastingTimes;
  const BarChartSample({super.key, required this.fastingTimes});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8))),
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
            maxY: 24,
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
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'M';
        break;
      case 1:
        text = 'T';
        break;
      case 2:
        text = 'W';
        break;
      case 3:
        text = 'T';
        break;
      case 4:
        text = 'F';
        break;
      case 5:
        text = 'S';
        break;
      case 6:
        text = 'S';
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
    return fastingTimes.asMap().entries.map((entry) {
      final index = entry.key;
      final fastingTime =
          entry.value['totalFastingTime'] / 3600.0; // Convert seconds to hours

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
    }).toList();
  }

  /*List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              backDrawRodData: BackgroundBarChartRodData(
                  show: true, toY: 24, color: Colors.blue[50]),
              width: 14,
              toY: 24,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              backDrawRodData: BackgroundBarChartRodData(
                  show: true, toY: 24, color: Colors.indigo[50]),
              width: 14,
              toY: 10,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              backDrawRodData: BackgroundBarChartRodData(
                  show: true, toY: 24, color: Colors.indigo[50]),
              width: 14,
              toY: 14,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              backDrawRodData: BackgroundBarChartRodData(
                  show: true, toY: 24, color: Colors.indigo[50]),
              width: 14,
              toY: 15,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              backDrawRodData: BackgroundBarChartRodData(
                  show: true, toY: 24, color: Colors.indigo[50]),
              width: 14,
              toY: 13,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              backDrawRodData: BackgroundBarChartRodData(
                  show: true, toY: 24, color: Colors.indigo[50]),
              width: 14,
              toY: 10,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
              backDrawRodData: BackgroundBarChartRodData(
                  show: true, toY: 24, color: Colors.indigo[50]),
              width: 14,
              toY: 16,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
      ];*/
}
