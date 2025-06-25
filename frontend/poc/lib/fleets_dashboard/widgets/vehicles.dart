import 'package:flutter/material.dart';
import 'package:poc/fahrzeug_dashboard/model/vehicle.dart';
import 'package:poc/fleets_dashboard/widgets/vehicle_item.dart';
import 'package:sbb_design_system_mobile/sbb_design_system_mobile.dart';

class Vehicles extends StatelessWidget {
  Vehicles({
    super.key,
    required this.fleetName,
    required this.category,
  });

  final String fleetName;
  final String category;

  final List<Vehicle> vehicles = [
    const Vehicle(uicNumber: '99 85 9236 023-9', soh: 95),
    const Vehicle(uicNumber: '99 85 9236 024-7', soh: 60),
    const Vehicle(uicNumber: '99 85 9236 025-4', soh: 93),
    const Vehicle(uicNumber: '99 85 9236 026-2', soh: null),
  ];

  @override
  Widget build(BuildContext context) {
    const itemWidth = 160;
    const itemSpacing = 12.0;
    final double totalWidth = (vehicles.length) * itemWidth + ((vehicles.length) * itemSpacing) + 60 + 70;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: sbbDefaultSpacing),
        const Text(
          'Flotten Dashboard',
          style: SBBTextStyles.extraLargeBold,
        ),
        const SizedBox(height: sbbDefaultSpacing),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: totalWidth,
            padding: const EdgeInsets.all(sbbDefaultSpacing),
            decoration: BoxDecoration(
              color: SBBColors.silver,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: SBBColors.graphite.withOpacity(0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(fleetName, style: SBBTextStyles.mediumBold),
                const SizedBox(width: 12),
                ...vehicles.map((vehicle) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: VehicleItem(vehicle: vehicle),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
