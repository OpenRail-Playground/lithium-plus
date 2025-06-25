import 'package:equatable/equatable.dart';
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
        const Usage(value: 75, title: 'Auslastung', color: SBBColors.green),
        const Usage(value: 2, title: 'Störung', color: SBBColors.cement),
        const Usage(value: 12, title: 'Ladezeit', color: SBBColors.smoke),
        const Usage(value: 5, title: 'Standzeit', color: SBBColors.granite),
        const Usage(value: 5, title: 'Fehlendes Signal', color: SBBColors.anthracite),
      ];

  @override
  List<Object?> get props => [value, title, color];
}
