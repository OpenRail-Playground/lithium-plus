import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:poc/fleets_dashboard/view_model/fleet_page_view_model.dart';
import 'package:poc/fleets_dashboard/widgets/operation_time.dart';
import 'package:poc/fleets_dashboard/widgets/status_of_health.dart';
import 'package:poc/fleets_dashboard/widgets/usage_pie.dart';
import 'package:poc/fleets_dashboard/widgets/vehicles.dart';

@RoutePage()
class FleetPage extends StatelessWidget {
  final String category;
  final String fleetName;

  const FleetPage({
    super.key,
    @PathParam('category') required this.category,
    @PathParam('fleetName') required this.fleetName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Search(),
        const Divider(height: 5),
        Vehicles(fleetName: fleetName, category: category),
        const Divider(height: 5),
        const Expanded(
          child: Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  StatusOfHealth(
                    percent: 83,
                  ),
                  Divider(height: 5),
                  OperationTime()
                ],
              )),
              VerticalDivider(width: 5),
              Expanded(child: UsagePie())
            ],
          ),
        ),
      ],
    );
  }
}
