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
    const Vehicle(
      uicNumber: '99 85 9236 023-9',
      soh: 95,
    ),
    const Vehicle(
      uicNumber: '99 85 9236 024-7',
      soh: 60,
    ),
    const Vehicle(
      uicNumber: '99 85 9236 025-4',
      soh: 93,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(vertical: sbbDefaultSpacing),
            height: 80,
            child: const Text(
              'Verfügbarkeit',
              style: SBBTextStyles.extraExtraLargeBold,
            )),
        Container(
          height: 150,
          width: 500,
          color: SBBColors.silver,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return VehicleItem(vehicle: vehicle);
            },
          ),
        ),
      ],
    );
  }
}
