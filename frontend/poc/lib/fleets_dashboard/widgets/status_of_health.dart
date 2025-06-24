import 'package:flutter/material.dart';
import 'package:sbb_design_system_mobile/sbb_design_system_mobile.dart';

class StatusOfHealth extends StatelessWidget {
  final int percent;

  const StatusOfHealth({
    super.key,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    final clampedPercent = percent.clamp(0, 100);
    final healthRatio = clampedPercent / 100.0;

    Color getBarColor(int percent) {
      if (percent >= 85) {
        return SBBColors.green;
      } else if (percent >= 70) {
        return SBBColors.lemon;
      } else {
        return SBBColors.red;
      }
    }

    double barHeight = 50;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: sbbDefaultSpacing),
          height: 80,
          child: const Text(
            'Batteriezustand(SoH gesamt)',
            style: SBBTextStyles.extraExtraLargeBold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: sbbDefaultSpacing),
          child: Stack(
            children: [
              Container(
                height: barHeight,
                decoration: BoxDecoration(
                  color: SBBColors.cloud,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: SBBColors.graphite, width: 1),
                ),
              ),
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: healthRatio,
                child: Container(
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: getBarColor(clampedPercent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Text(
                    '$clampedPercent%',
                    style: SBBTextStyles.mediumBold.copyWith(
                      color: SBBColors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(sbbDefaultSpacing),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LegendItem(color: SBBColors.red, label: '<70'),
              LegendItem(color: SBBColors.lemon, label: '70<= X <85'),
              LegendItem(color: SBBColors.green, label: '>=85')
            ],
          ),
        ),
        const SizedBox(
          height: sbbDefaultSpacing,
        )
      ],
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({
    super.key,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: SBBColors.graphite),
          ),
        ),
        Text(
          label,
          style: SBBTextStyles.smallBold,
        ),
        const SizedBox(width: sbbDefaultSpacing)
      ],
    );
  }
}
