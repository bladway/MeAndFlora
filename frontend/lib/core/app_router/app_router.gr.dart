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
    AccountListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountListScreen(),
      );
    },
    AccountRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountScreen(),
      );
    },
    AdvertisementRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AdvertisementScreen(),
      );
    },
    BotanicRegisterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const BotanicRegisterScreen(),
      );
    },
    CameraRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CameraScreen(),
      );
    },
    CameraWrapperRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(child: const CameraWrapperScreen()),
      );
    },
    HistoryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HistoryScreen(),
      );
    },
    HistoryWrapperRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(child: const HistoryWrapperScreen()),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    HomeWrapperRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(child: const HomeWrapperScreen()),
      );
    },
    NavBarAdminRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(child: const NavBarAdminScreen()),
      );
    },
    NavBarAuthUserRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(child: const NavBarAuthUserScreen()),
      );
    },
    NavBarBotanicRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(child: const NavBarBotanicScreen()),
      );
    },
    NavBarDefaultRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(child: const NavBarDefaultScreen()),
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
    PlantIdentDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<PlantIdentDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PlantIdentDetailsScreen(
          key: args.key,
          plant: args.plant,
          imageUrl: args.imageUrl,
        ),
      );
    },
    PlantIdentFormRoute.name: (routeData) {
      final args = routeData.argsAs<PlantIdentFormRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PlantIdentFormScreen(
          key: args.key,
          plant: args.plant,
        ),
      );
    },
    PlantPublicRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PlantPublicScreen(),
      );
    },
    PlantPublicWrapperRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(child: const PlantPublicWrapperScreen()),
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
    StatisticRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const StatisticScreen(),
      );
    },
    TrackRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TrackScreen(),
      );
    },
    TrackWrapperRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(child: const TrackWrapperScreen()),
      );
    },
    UnknownPlantsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UnknownPlantsScreen(),
      );
    },
    UnknownPlantsWrapperRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(child: const UnknownPlantsWrapperScreen()),
      );
    },
  };
}

/// generated route for
/// [AccountListScreen]
class AccountListRoute extends PageRouteInfo<void> {
  const AccountListRoute({List<PageRouteInfo>? children})
      : super(
          AccountListRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AccountScreen]
class AccountRoute extends PageRouteInfo<void> {
  const AccountRoute({List<PageRouteInfo>? children})
      : super(
          AccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AdvertisementScreen]
class AdvertisementRoute extends PageRouteInfo<void> {
  const AdvertisementRoute({List<PageRouteInfo>? children})
      : super(
          AdvertisementRoute.name,
          initialChildren: children,
        );

  static const String name = 'AdvertisementRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [BotanicRegisterScreen]
class BotanicRegisterRoute extends PageRouteInfo<void> {
  const BotanicRegisterRoute({List<PageRouteInfo>? children})
      : super(
          BotanicRegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'BotanicRegisterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
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
/// [CameraWrapperScreen]
class CameraWrapperRoute extends PageRouteInfo<void> {
  const CameraWrapperRoute({List<PageRouteInfo>? children})
      : super(
          CameraWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'CameraWrapperRoute';

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
/// [HistoryWrapperScreen]
class HistoryWrapperRoute extends PageRouteInfo<void> {
  const HistoryWrapperRoute({List<PageRouteInfo>? children})
      : super(
          HistoryWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'HistoryWrapperRoute';

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
/// [HomeWrapperScreen]
class HomeWrapperRoute extends PageRouteInfo<void> {
  const HomeWrapperRoute({List<PageRouteInfo>? children})
      : super(
          HomeWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeWrapperRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NavBarAdminScreen]
class NavBarAdminRoute extends PageRouteInfo<void> {
  const NavBarAdminRoute({List<PageRouteInfo>? children})
      : super(
          NavBarAdminRoute.name,
          initialChildren: children,
        );

  static const String name = 'NavBarAdminRoute';

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
/// [NavBarBotanicScreen]
class NavBarBotanicRoute extends PageRouteInfo<void> {
  const NavBarBotanicRoute({List<PageRouteInfo>? children})
      : super(
          NavBarBotanicRoute.name,
          initialChildren: children,
        );

  static const String name = 'NavBarBotanicRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NavBarDefaultScreen]
class NavBarDefaultRoute extends PageRouteInfo<void> {
  const NavBarDefaultRoute({List<PageRouteInfo>? children})
      : super(
          NavBarDefaultRoute.name,
          initialChildren: children,
        );

  static const String name = 'NavBarDefaultRoute';

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
/// [PlantIdentDetailsScreen]
class PlantIdentDetailsRoute extends PageRouteInfo<PlantIdentDetailsRouteArgs> {
  PlantIdentDetailsRoute({
    Key? key,
    required Plant plant,
    required String imageUrl,
    List<PageRouteInfo>? children,
  }) : super(
          PlantIdentDetailsRoute.name,
          args: PlantIdentDetailsRouteArgs(
            key: key,
            plant: plant,
            imageUrl: imageUrl,
          ),
          initialChildren: children,
        );

  static const String name = 'PlantIdentDetailsRoute';

  static const PageInfo<PlantIdentDetailsRouteArgs> page =
      PageInfo<PlantIdentDetailsRouteArgs>(name);
}

class PlantIdentDetailsRouteArgs {
  const PlantIdentDetailsRouteArgs({
    this.key,
    required this.plant,
    required this.imageUrl,
  });

  final Key? key;

  final Plant plant;

  final String imageUrl;

  @override
  String toString() {
    return 'PlantIdentDetailsRouteArgs{key: $key, plant: $plant, imageUrl: $imageUrl}';
  }
}

/// generated route for
/// [PlantIdentFormScreen]
class PlantIdentFormRoute extends PageRouteInfo<PlantIdentFormRouteArgs> {
  PlantIdentFormRoute({
    Key? key,
    required Plant plant,
    List<PageRouteInfo>? children,
  }) : super(
          PlantIdentFormRoute.name,
          args: PlantIdentFormRouteArgs(
            key: key,
            plant: plant,
          ),
          initialChildren: children,
        );

  static const String name = 'PlantIdentFormRoute';

  static const PageInfo<PlantIdentFormRouteArgs> page =
      PageInfo<PlantIdentFormRouteArgs>(name);
}

class PlantIdentFormRouteArgs {
  const PlantIdentFormRouteArgs({
    this.key,
    required this.plant,
  });

  final Key? key;

  final Plant plant;

  @override
  String toString() {
    return 'PlantIdentFormRouteArgs{key: $key, plant: $plant}';
  }
}

/// generated route for
/// [PlantPublicScreen]
class PlantPublicRoute extends PageRouteInfo<void> {
  const PlantPublicRoute({List<PageRouteInfo>? children})
      : super(
          PlantPublicRoute.name,
          initialChildren: children,
        );

  static const String name = 'PlantPublicRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PlantPublicWrapperScreen]
class PlantPublicWrapperRoute extends PageRouteInfo<void> {
  const PlantPublicWrapperRoute({List<PageRouteInfo>? children})
      : super(
          PlantPublicWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'PlantPublicWrapperRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
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
/// [StatisticScreen]
class StatisticRoute extends PageRouteInfo<void> {
  const StatisticRoute({List<PageRouteInfo>? children})
      : super(
          StatisticRoute.name,
          initialChildren: children,
        );

  static const String name = 'StatisticRoute';

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

/// generated route for
/// [TrackWrapperScreen]
class TrackWrapperRoute extends PageRouteInfo<void> {
  const TrackWrapperRoute({List<PageRouteInfo>? children})
      : super(
          TrackWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'TrackWrapperRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UnknownPlantsScreen]
class UnknownPlantsRoute extends PageRouteInfo<void> {
  const UnknownPlantsRoute({List<PageRouteInfo>? children})
      : super(
          UnknownPlantsRoute.name,
          initialChildren: children,
        );

  static const String name = 'UnknownPlantsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UnknownPlantsWrapperScreen]
class UnknownPlantsWrapperRoute extends PageRouteInfo<void> {
  const UnknownPlantsWrapperRoute({List<PageRouteInfo>? children})
      : super(
          UnknownPlantsWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'UnknownPlantsWrapperRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
