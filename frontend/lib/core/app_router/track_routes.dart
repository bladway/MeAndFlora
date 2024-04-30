import 'package:auto_route/auto_route.dart';

import 'app_router.dart';

abstract class TrackRoutes {
  static final routes = AutoRoute(
    page: TrackWrapperRoute.page,
    children: [
      AutoRoute(page: TrackRoute.page, initial: true),
      AutoRoute(page: PlantDetailsRoute.page),
    ],
  );
}
