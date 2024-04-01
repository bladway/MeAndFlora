// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    PlantDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<PlantDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PlantDetailsScreen(
          key: args.key,
          plant: args.plant,
        ),
      );
    },
    SignInRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SignInScreen(),
      );
    },
    SignUpRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SignUpScreen(),
      );
    },
  };
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PlantDetailsScreen]
class PlantDetailsRoute extends PageRouteInfo<PlantDetailsRouteArgs> {
  PlantDetailsRoute({
    Key? key,
    required Plant plant,
    List<PageRouteInfo>? children,
  }) : super(
          PlantDetailsRoute.name,
          args: PlantDetailsRouteArgs(
            key: key,
            plant: plant,
          ),
          initialChildren: children,
        );

  static const String name = 'PlantDetailsRoute';

  static const PageInfo<PlantDetailsRouteArgs> page =
      PageInfo<PlantDetailsRouteArgs>(name);
}

class PlantDetailsRouteArgs {
  const PlantDetailsRouteArgs({
    this.key,
    required this.plant,
  });

  final Key? key;

  final Plant plant;

  @override
  String toString() {
    return 'PlantDetailsRouteArgs{key: $key, plant: $plant}';
  }
}

/// generated route for
/// [SignInScreen]
class SignInRoute extends PageRouteInfo<void> {
  const SignInRoute({List<PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SignUpScreen]
class SignUpRoute extends PageRouteInfo<void> {
  const SignUpRoute({List<PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
