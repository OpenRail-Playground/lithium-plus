import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:poc/fahrzeug_dashboard/model/usage.dart';
import 'package:sbb_design_system_mobile/sbb_design_system_mobile.dart';

class UsagePie extends StatefulWidget {
  const UsagePie({super.key});

  @override
  State<UsagePie> createState() => _UsagePieState();
}

class _UsagePieState extends State<UsagePie> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    final data = Usage.defaultData;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: sbbDefaultSpacing),
          height: 80,
          child: const Text(
            'Nutzung',
            style: SBBTextStyles.extraExtraLargeBold,
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: PieChart(
                    PieChartData(
                      sections: data.toChartSections(
                        highlightedIndex: touchedIndex,
                        radius: 200,
                      ),
                      centerSpaceRadius: 0,
                      sectionsSpace: 0,
                      borderData: FlBorderData(show: false),
                      pieTouchData: PieTouchData(
                        touchCallback: (event, response) {
                          setState(() {
                            touchedIndex = response?.touchedSection?.touchedSectionIndex;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: sbbDefaultSpacing),
              _buildLegend(data),
              const SizedBox(height: sbbDefaultSpacing),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(List<Usage> data) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: data.map((e) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: e.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text('${e.title} (${e.value.toStringAsFixed(0)}%)', style: SBBTextStyles.mediumLight),
          ],
        );
      }).toList(),
    );
  }
}
