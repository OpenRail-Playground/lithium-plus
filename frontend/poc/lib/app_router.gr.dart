// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [FlottePage]
class FlotteRoute extends PageRouteInfo<void> {
  const FlotteRoute({List<PageRouteInfo>? children})
      : super(FlotteRoute.name, initialChildren: children);

  static const String name = 'FlotteRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FlottePage();
    },
  );
}

/// generated route for
/// [LayoutPage]
class LayoutRoute extends PageRouteInfo<LayoutRouteArgs> {
  LayoutRoute({
    Key? key,
    required Widget child,
    required int selectedIndex,
    required void Function(int) onDestinationSelected,
    List<PageRouteInfo>? children,
  }) : super(
          LayoutRoute.name,
          args: LayoutRouteArgs(
            key: key,
            child: child,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
          ),
          initialChildren: children,
        );

  static const String name = 'LayoutRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LayoutRouteArgs>();
      return LayoutPage(
        key: args.key,
        child: args.child,
        selectedIndex: args.selectedIndex,
        onDestinationSelected: args.onDestinationSelected,
      );
    },
  );
}

class LayoutRouteArgs {
  const LayoutRouteArgs({
    this.key,
    required this.child,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final Key? key;

  final Widget child;

  final int selectedIndex;

  final void Function(int) onDestinationSelected;

  @override
  String toString() {
    return 'LayoutRouteArgs{key: $key, child: $child, selectedIndex: $selectedIndex, onDestinationSelected: $onDestinationSelected}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LayoutRouteArgs) return false;
    return key == other.key &&
        child == other.child &&
        selectedIndex == other.selectedIndex;
  }

  @override
  int get hashCode => key.hashCode ^ child.hashCode ^ selectedIndex.hashCode;
}
