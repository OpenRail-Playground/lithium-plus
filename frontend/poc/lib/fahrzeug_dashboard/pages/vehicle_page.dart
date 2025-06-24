import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class VehiclePage extends StatelessWidget {
  final String uicNumber;

  const VehiclePage({
    super.key,
    @PathParam('uicNumber') required this.uicNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Text('Fahrzeug: $uicNumber');
  }
}
