import 'package:auto_route/auto_route.dart';

import 'app_router.dart';

abstract class CameraRoutes {
  static final routes = AutoRoute(
    page: CameraWrapperRoute.page,
    children: [
      AutoRoute(page: CameraRoute.page, initial: true),
      AutoRoute(page: PlantIdentDetailsRoute.page),
      //AutoRoute(page: PlantDetailsRoute.page),
    ],
  );
}
