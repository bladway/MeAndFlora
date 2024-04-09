import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../feature/account/presentation/account_screen.dart';
import '../../feature/camera/presentation/camera_screen.dart';
import '../../feature/history/presentation/history_screen.dart';
import '../../feature/home/presentation/home_screen.dart';
import '../../feature/plant_details/presentation/plant_details_screen.dart';
import '../../feature/sign_in/presentation/sign_in_screen.dart';
import '../../feature/sign_up/presentation/sign_up_screen.dart';
import '../../feature/track/presentation/track_screen.dart';
import '../domain/models/models.dart';
import '../presentation/widgets/navigation/nav_bar_auth_user/nav_bar_auth_user_screen.dart';
import '../presentation/widgets/navigation/nav_bar_default/nav_bar_default_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: PlantDetailsRoute.page),
    AutoRoute(page: SignInRoute.page, path: "/"),
    AutoRoute(page: SignUpRoute.page),
    AutoRoute(page: NavigationBarDefaultRoute.page, children: [
      AutoRoute(page: HomeRoute.page),
      AutoRoute(page: CameraRoute.page),
      AutoRoute(page: AccountRoute.page)
    ]),
    AutoRoute(page: NavBarAuthUserRoute.page, children: [
      AutoRoute(page: HomeRoute.page),
      AutoRoute(page: CameraRoute.page),
      AutoRoute(page: HistoryRoute.page),
      AutoRoute(page: TrackRoute.page),
      AutoRoute(page: AccountRoute.page)
    ])
  ];
}