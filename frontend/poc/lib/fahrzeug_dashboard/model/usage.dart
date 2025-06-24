import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sbb_design_system_mobile/sbb_design_system_mobile.dart';

class Usage extends Equatable {
  final double value;
  final String title;
  final Color color;

  const Usage({
    required this.value,
    required this.title,
    required this.color,
  });

  static List<Usage> get defaultData => [
        const Usage(value: 85, title: 'Auslastung', color: SBBColors.green),
        const Usage(value: 2, title: 'Störung', color: SBBColors.cement),
        const Usage(value: 3, title: 'Ladezeit', color: SBBColors.smoke),
        const Usage(value: 5, title: 'Standzeit', color: SBBColors.granite),
        const Usage(value: 5, title: 'Fehlendes Signal', color: SBBColors.anthracite),
      ];

  @override
  List<Object?> get props => [value, title, color];
}

extension UsageChartExtension on List<Usage> {
  List<PieChartSectionData> toChartSections({
    int? highlightedIndex,
    double radius = 40,
    double fontSize = 16,
  }) {
    return asMap().entries.map((entry) {
      final index = entry.key;
      final e = entry.value;
      final isTouched = index == highlightedIndex;
      final highlightRadius = radius + 10;

      return PieChartSectionData(
        value: e.value,
        title: '${e.title} ${e.value.toStringAsFixed(0)}%',
        color: e.color,
        radius: isTouched ? highlightRadius : radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
