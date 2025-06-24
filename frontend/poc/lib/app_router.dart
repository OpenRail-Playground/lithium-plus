import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:poc/flotte_dashboard/pages/flotte_page.dart';
import 'package:poc/layout_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: LayoutRoute.page,
          path: '/',
          initial: true,
          children: [
            AutoRoute(page: FlotteRoute.page, path: 'flotte', initial: true),
          ],
        ),
      ];
}
