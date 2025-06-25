// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [FleetPage]
class FleetRoute extends PageRouteInfo<FleetRouteArgs> {
  FleetRoute({
    Key? key,
    required String category,
    required String fleetName,
    List<PageRouteInfo>? children,
  }) : super(
          FleetRoute.name,
          args: FleetRouteArgs(
            key: key,
            category: category,
            fleetName: fleetName,
          ),
          rawPathParams: {'category': category, 'fleetName': fleetName},
          initialChildren: children,
        );

  static const String name = 'FleetRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<FleetRouteArgs>(
        orElse: () => FleetRouteArgs(
          category: pathParams.getString('category'),
          fleetName: pathParams.getString('fleetName'),
        ),
      );
      return FleetPage(
        key: args.key,
        category: args.category,
        fleetName: args.fleetName,
      );
    },
  );
}

class FleetRouteArgs {
  const FleetRouteArgs({
    this.key,
    required this.category,
    required this.fleetName,
  });

  final Key? key;

  final String category;

  final String fleetName;

  @override
  String toString() {
    return 'FleetRouteArgs{key: $key, category: $category, fleetName: $fleetName}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FleetRouteArgs) return false;
    return key == other.key &&
        category == other.category &&
        fleetName == other.fleetName;
  }

  @override
  int get hashCode => key.hashCode ^ category.hashCode ^ fleetName.hashCode;
}

/// generated route for
/// [LayoutPage]
class LayoutRoute extends PageRouteInfo<void> {
  const LayoutRoute({List<PageRouteInfo>? children})
      : super(LayoutRoute.name, initialChildren: children);

  static const String name = 'LayoutRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LayoutPage();
    },
  );
}

/// generated route for
/// [VehiclePage]
class VehicleRoute extends PageRouteInfo<VehicleRouteArgs> {
  VehicleRoute({
    Key? key,
    required String uicNumber,
    List<PageRouteInfo>? children,
  }) : super(
          VehicleRoute.name,
          args: VehicleRouteArgs(key: key, uicNumber: uicNumber),
          rawPathParams: {'uicNumber': uicNumber},
          initialChildren: children,
        );

  static const String name = 'VehicleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<VehicleRouteArgs>(
        orElse: () =>
            VehicleRouteArgs(uicNumber: pathParams.getString('uicNumber')),
      );
      return VehiclePage(key: args.key, uicNumber: args.uicNumber);
    },
  );
}

class VehicleRouteArgs {
  const VehicleRouteArgs({this.key, required this.uicNumber});

  final Key? key;

  final String uicNumber;

  @override
  String toString() {
    return 'VehicleRouteArgs{key: $key, uicNumber: $uicNumber}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VehicleRouteArgs) return false;
    return key == other.key && uicNumber == other.uicNumber;
  }

  @override
  int get hashCode => key.hashCode ^ uicNumber.hashCode;
}
