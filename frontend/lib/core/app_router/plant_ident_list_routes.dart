import 'package:auto_route/auto_route.dart';
import 'package:me_and_flora/core/app_router/app_router.dart';

abstract class PlantIdentListRoutes {
  static final routes = AutoRoute(
    page: UnknownPlantsWrapperRoute.page,
    children: [
      AutoRoute(page: UnknownPlantsRoute.page, initial: true),
      AutoRoute(page: PlantIdentFormRoute.page),
    ],
  );
}