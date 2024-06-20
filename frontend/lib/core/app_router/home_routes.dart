import 'package:auto_route/auto_route.dart';

import 'app_router.dart';

abstract class HomeRoutes {
  static final routes = AutoRoute(
    page: HomeWrapperRoute.page,
    children: [
      AutoRoute(page: HomeRoute.page, initial: true),
      AutoRoute(page: PlantDetailsRoute.page),
    ],
  );
}
