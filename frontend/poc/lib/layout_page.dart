import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:poc/app_router.dart';
import 'package:poc/layout_view_model.dart';
import 'package:sbb_design_system_mobile/sbb_design_system_mobile.dart';

@RoutePage()
class LayoutPage extends StatelessWidget {
  const LayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = LayoutViewModel();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pathParams = AutoRouter.of(context).routeData.inheritedPathParams;
      final currentCategory = pathParams.optString('category');
      viewModel.expandFromPath(currentCategory);
    });

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
            color: Colors.grey.shade100,
            child: StreamBuilder<Set<String>>(
              stream: viewModel.expandedStream,
              initialData: const {},
              builder: (context, snapshot) {
                final expanded = snapshot.data ?? {};
                return ListView(
                  children: fleetData.entries.map((entry) {
                    return _buildCategory(
                      context,
                      viewModel,
                      title: entry.key == 'infrastructure' ? 'Infrastructure' : 'Cargo',
                      icon: entry.key == 'infrastructure' ? SBBIcons.tunnel_small : SBBIcons.freight_wagon_small,
                      fleets: entry.value,
                      category: entry.key,
                      isExpanded: expanded.contains(entry.key),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          const VerticalDivider(thickness: 1),
          const Expanded(child: AutoRouter()),
        ],
      ),
    );
  }

  Widget _buildCategory(
    BuildContext context,
    LayoutViewModel viewModel, {
    required String title,
    required IconData icon,
    required List<String> fleets,
    required String category,
    required bool isExpanded,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          selected: isExpanded,
          selectedTileColor: SBBColors.white,
          onTap: () {
            viewModel.toggleCategory(category);
            context.pushRoute(FleetRoute(category: category, fleetName: fleets.first));
          },
        ),
        if (isExpanded)
          ...fleets.map(
            (fleet) => Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: ListTile(
                title: Text(fleet),
                onTap: () {
                  context.pushRoute(FleetRoute(category: category, fleetName: fleet));
                },
              ),
            ),
          ),
      ],
    );
  }
}
