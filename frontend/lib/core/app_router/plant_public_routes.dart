import 'package:auto_route/auto_route.dart';

import 'app_router.dart';

abstract class PlantPublicRoutes {
  static final routes = AutoRoute(
    page: PlantPublicWrapperRoute.page,
    children: [
      AutoRoute(page: PlantPublicRoute.page, initial: true),
      AutoRoute(page: PlantDetailsRoute.page),
    ],
  );
}