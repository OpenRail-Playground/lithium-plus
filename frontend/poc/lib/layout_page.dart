import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sbb_design_system_mobile/sbb_design_system_mobile.dart';

@RoutePage()
class LayoutPage extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final void Function(int index) onDestinationSelected;

  const LayoutPage({super.key, required this.child, required this.selectedIndex, required this.onDestinationSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(icon: Icon(SBBIcons.freight_wagon_container_small), label: Text('Flotte')),
              NavigationRailDestination(icon: Icon(Icons.settings), label: Text('Cargo')),
            ],
          ),

          const VerticalDivider(thickness: 1, width: 1),

          // Main content
          Expanded(
            child: Padding(padding: const EdgeInsets.all(24.0), child: child),
          ),
        ],
      ),
    );
  }
}
