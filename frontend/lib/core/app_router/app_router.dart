import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:me_and_flora/core/app_router/history_routes.dart';
import 'package:me_and_flora/core/app_router/home_routes.dart';
import 'package:me_and_flora/core/app_router/camera_routes.dart';
import 'package:me_and_flora/core/app_router/plant_ident_list_routes.dart';
import 'package:me_and_flora/core/app_router/plant_public_routes.dart';
import 'package:me_and_flora/core/app_router/track_routes.dart';
import 'package:me_and_flora/feature/create_user/create_user_screen.dart';

import '../../feature/account/presentation/account_screen.dart';
import '../../feature/account_list/presentation/account_list_screen.dart';
import '../../feature/advertisement/presentation/advertisement_screen.dart';
import '../../feature/camera/presentation/camera_screen.dart';
import '../../feature/camera/presentation/camera_wrapper_screen.dart';
import '../../feature/history/presentation/history_screen.dart';
import '../../feature/history/presentation/history_wrapper_screen.dart';
import '../../feature/home/presentation/home_screen.dart';
import '../../feature/home/presentation/home_wrapper_screen.dart';
import '../../feature/plant_details/presentation/plant_details_screen.dart';
import '../../feature/plant_ident_details/presentation/plant_ident_details_screen.dart';
import '../../feature/plant_ident_form/presentation/plant_ident_form_screen.dart';
import '../../feature/plant_public/presentation/plant_public_screen.dart';
import '../../feature/plant_public/presentation/plant_public_wrapper_screen.dart';
import '../../feature/sign_in/presentation/sign_in_screen.dart';
import '../../feature/sign_up/presentation/sign_up_screen.dart';
import '../../feature/statistic/presentation/statistic_screen.dart';
import '../../feature/track/presentation/track_screen.dart';
import '../../feature/track/presentation/track_wrapper_screen.dart';
import '../../feature/unknown_plants/presentation/unknown_plants_screen.dart';
import '../../feature/unknown_plants/presentation/unknown_plants_wrapper_screen.dart';
import '../domain/models/models.dart';
import '../presentation/widgets/navigation/nav_bar_admin/nav_bar_admin_screen.dart';
import '../presentation/widgets/navigation/nav_bar_auth_user/nav_bar_auth_user_screen.dart';
import '../presentation/widgets/navigation/nav_bar_botanic/nav_bar_botanic_screen.dart';
import '../presentation/widgets/navigation/nav_bar_default/nav_bar_default_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: PlantDetailsRoute.page),
    AutoRoute(page: SignInRoute.page, path: "/"),
    AutoRoute(page: SignUpRoute.page),
    AutoRoute(page: AdvertisementRoute.page),
    AutoRoute(page: NavBarDefaultRoute.page, children: [
      HomeRoutes.routes,
      CameraRoutes.routes,
      AutoRoute(page: AccountRoute.page)
    ]),
    AutoRoute(page: NavBarAuthUserRoute.page, children: [
      HomeRoutes.routes,
      CameraRoutes.routes,
      HistoryRoutes.routes,
      TrackRoutes.routes,
      AutoRoute(page: AccountRoute.page)
    ]),
    AutoRoute(page: NavBarBotanicRoute.page, children: [
      HomeRoutes.routes,
      CameraRoutes.routes,
      HistoryRoutes.routes,
      PlantIdentListRoutes.routes,
      AutoRoute(page: AccountRoute.page),
    ]),
    AutoRoute(page: CreateUserRoute.page),
    AutoRoute(page: NavBarAdminRoute.page, children: [
      AutoRoute(page: AccountListRoute.page),
      PlantPublicRoutes.routes,
      AutoRoute(page: StatisticRoute.page),
      AutoRoute(page: AccountRoute.page)
    ]),
  ];
}