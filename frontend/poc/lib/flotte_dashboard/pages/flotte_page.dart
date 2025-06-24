import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class FlottePage extends StatelessWidget {
  const FlottePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Flotte Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      ),
    );
  }
}
