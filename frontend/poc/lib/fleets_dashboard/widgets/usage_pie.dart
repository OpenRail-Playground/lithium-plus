import 'package:flutter/material.dart';
import 'package:poc/fahrzeug_dashboard/model/usage.dart';
import 'package:sbb_design_system_mobile/sbb_design_system_mobile.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class UsagePie extends StatefulWidget {
  const UsagePie({super.key});

  @override
  State<UsagePie> createState() => _UsagePieState();
}

class _UsagePieState extends State<UsagePie> {
  late List<Usage> data;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    data = Usage.defaultData;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: sbbDefaultSpacing),
          child: Text('Nutzung (gesamt)', style: SBBTextStyles.largeBold),
        ),
        Expanded(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: SfCircularChart(
              legend: const Legend(
                isVisible: false,
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <PieSeries<Usage, String>>[
                PieSeries<Usage, String>(
                  dataSource: data,
                  xValueMapper: (Usage u, _) => u.title,
                  yValueMapper: (Usage u, _) => u.value,
                  pointColorMapper: (Usage u, _) => u.color,
                  dataLabelMapper: (Usage u, _) => '${u.title}\n${u.value.toStringAsFixed(0)}%',
                  dataLabelSettings: const DataLabelSettings(
                    labelIntersectAction: LabelIntersectAction.shift,
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    connectorLineSettings: ConnectorLineSettings(
                      type: ConnectorType.line,
                      length: '10%',
                    ),
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  explode: true,
                  explodeIndex: selectedIndex,
                  radius: '60%',
                  onPointTap: (ChartPointDetails details) {
                    setState(() {
                      selectedIndex = details.pointIndex;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: sbbDefaultSpacing),
        _buildCustomLegend(),
        const SizedBox(height: sbbDefaultSpacing),
      ],
    );
  }

  Widget _buildCustomLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
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
