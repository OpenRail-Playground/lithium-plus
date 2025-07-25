import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:poc/fleets_dashboard/pages/fleet_page.dart';
import 'package:poc/layout_page.dart';

import 'fahrzeug_dashboard/pages/vehicle_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: LayoutRoute.page,
          initial: true,
          type: RouteType.custom(
            transitionsBuilder: TransitionsBuilders.noTransition,
          ),
          children: [
            AutoRoute(
              path: ':category/fleets/:fleetName',
              page: FleetRoute.page,
              type: RouteType.custom(
                transitionsBuilder: TransitionsBuilders.slideRightWithFade,
              ),
              children: [
                AutoRoute(
                  path: ':uicNumber',
                  page: VehicleRoute.page,
                  type: RouteType.custom(
                    transitionsBuilder: TransitionsBuilders.fadeIn,
                  ),
                ),
              ],
            ),
          ],
        ),
      ];
}
