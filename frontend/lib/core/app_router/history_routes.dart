import 'package:auto_route/auto_route.dart';

import 'app_router.dart';

abstract class HistoryRoutes {
  static final routes = AutoRoute(
    page: HistoryWrapperRoute.page,
    children: [
      AutoRoute(page: HistoryRoute.page, initial: true),
      AutoRoute(page: PlantDetailsRoute.page),
    ],
  );
}
