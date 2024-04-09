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
    AccountRoute.name: (routeData) {
      final args = routeData.argsAs<AccountRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AccountScreen(
          key: args.key,
          account: args.account,
        ),
      );
    },
    CameraRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CameraScreen(),
      );
    },
    HistoryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HistoryScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    NavBarAuthUserRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NavBarAuthUserScreen(),
      );
    },
    NavigationBarDefaultRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NavigationBarDefaultScreen(),
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
    TrackRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TrackScreen(),
      );
    },
  };
}

/// generated route for
/// [AccountScreen]
class AccountRoute extends PageRouteInfo<AccountRouteArgs> {
  AccountRoute({
    Key? key,
    required Account account,
    List<PageRouteInfo>? children,
  }) : super(
          AccountRoute.name,
          args: AccountRouteArgs(
            key: key,
            account: account,
          ),
          initialChildren: children,
        );

  static const String name = 'AccountRoute';

  static const PageInfo<AccountRouteArgs> page =
      PageInfo<AccountRouteArgs>(name);
}

class AccountRouteArgs {
  const AccountRouteArgs({
    this.key,
    required this.account,
  });

  final Key? key;

  final Account account;

  @override
  String toString() {
    return 'AccountRouteArgs{key: $key, account: $account}';
  }
}

/// generated route for
/// [CameraScreen]
class CameraRoute extends PageRouteInfo<void> {
  const CameraRoute({List<PageRouteInfo>? children})
      : super(
          CameraRoute.name,
          initialChildren: children,
        );

  static const String name = 'CameraRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HistoryScreen]
class HistoryRoute extends PageRouteInfo<void> {
  const HistoryRoute({List<PageRouteInfo>? children})
      : super(
          HistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'HistoryRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
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
/// [NavBarAuthUserScreen]
class NavBarAuthUserRoute extends PageRouteInfo<void> {
  const NavBarAuthUserRoute({List<PageRouteInfo>? children})
      : super(
          NavBarAuthUserRoute.name,
          initialChildren: children,
        );

  static const String name = 'NavBarAuthUserRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NavigationBarDefaultScreen]
class NavigationBarDefaultRoute extends PageRouteInfo<void> {
  const NavigationBarDefaultRoute({List<PageRouteInfo>? children})
      : super(
          NavigationBarDefaultRoute.name,
          initialChildren: children,
        );

  static const String name = 'NavigationBarDefaultRoute';

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

/// generated route for
/// [TrackScreen]
class TrackRoute extends PageRouteInfo<void> {
  const TrackRoute({List<PageRouteInfo>? children})
      : super(
          TrackRoute.name,
          initialChildren: children,
        );

  static const String name = 'TrackRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
