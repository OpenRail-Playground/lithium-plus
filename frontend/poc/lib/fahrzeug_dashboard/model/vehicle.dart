import 'package:equatable/equatable.dart';

class Vehicle extends Equatable {
  const Vehicle({required this.uicNumber, this.soh});

  final String uicNumber;
  final int? soh;

  @override
  List<Object?> get props => [uicNumber, soh];
}
