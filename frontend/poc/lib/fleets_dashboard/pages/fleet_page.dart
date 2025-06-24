import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

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
    return Text('Fleet: $fleetName (category: $category)');
  }
}
