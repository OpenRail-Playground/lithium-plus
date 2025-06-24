import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sbb_design_system_mobile/sbb_design_system_mobile.dart';

class OperationTime extends StatelessWidget {
  const OperationTime({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: sbbDefaultSpacing),
          height: 80,
          child: const Text(
            'Betriebsdauer',
            style: SBBTextStyles.extraExtraLargeBold,
          ),
        ),
        AspectRatio(
          aspectRatio: 2.5,
          child: BarChart(
            BarChartData(
              barTouchData: barTouchData,
              titlesData: titlesData,
              borderData: borderData,
              barGroups: barGroups,
              gridData: const FlGridData(show: false),
              alignment: BarChartAlignment.spaceAround,
              maxY: 20,
            ),
          ),
        ),
        const Text('X : Tage, Y: Stunden pro Tag'),
        const Text('Zeitraum: 1.5. - 31.5. 2025')
      ],
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
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: SBBColors.green,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: SBBColors.blue,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    int index = value.toInt();
    String text;

    if (index >= 0 && index <= 31) {
      text = '${index + 1}'; // Convert the index to a string
    } else {
      text = '';
    }

    return SideTitleWidget(
      meta: meta,
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
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          SBBColors.blue,
          SBBColors.turquoise,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups {
    // Define your xList
    List<int> xList = List.generate(31, (index) => index);
    Random random = Random();

    // Generate BarChartGroupData based on xList and random toY values
    List<BarChartGroupData> groups = xList.map((x) {
      return BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
            toY: random.nextInt(21).toDouble(), // Random number between 0 and 20
            gradient: _barsGradient,
          )
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();

    return groups;
  }
}
