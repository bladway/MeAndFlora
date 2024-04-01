import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../feature/home/presentation/home_screen.dart';
import '../../feature/plant_details/presentation/plant_details_screen.dart';
import '../../feature/sign_in/presentation/sign_in_screen.dart';
import '../../feature/sign_up/presentation/sign_up_screen.dart';
import '../domain/models/models.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: PlantDetailsRoute.page),
    AutoRoute(page: SignInRoute.page, path: "/"),
    AutoRoute(page: SignUpRoute.page),
  ];
}