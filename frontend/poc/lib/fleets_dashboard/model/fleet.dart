import 'package:equatable/equatable.dart';
import 'package:poc/fahrzeug_dashboard/model/vehicle.dart';

class Fleet extends Equatable {
  const Fleet({required this.name, required this.soh, required this.vehicles});

  final String name;
  final int soh;
  final List<Vehicle> vehicles;

  @override
  List<Object?> get props => [name, soh, vehicles];
}
