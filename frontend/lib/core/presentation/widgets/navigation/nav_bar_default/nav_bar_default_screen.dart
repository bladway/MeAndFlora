import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../app_router/app_router.dart';
import '../../../../domain/models/models.dart';
import '../../../../theme/theme.dart';
import '../../../bloc/plant/plant.dart';
import '../../../bloc/plant_history/plant_history.dart';
import '../../../bloc/plant_ident/plant_ident.dart';
import '../../../bloc/plant_track/plant_track.dart';
import '../nav_bar_element.dart';

@RoutePage()
class NavBarDefaultScreen extends StatelessWidget implements AutoRouteWrapper {
  const NavBarDefaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        final router = context.router;
        if (router.canNavigateBack) {
          router.back();
        }
        return SynchronousFuture(!router.canNavigateBack);
      },
      child: AutoTabsRouter(
        routes: const [
          HomeWrapperRoute(),
          CameraWrapperRoute(),
          AccountRoute(),
        ],
        builder: (context, child) {
          final tabsRouter = AutoTabsRouter.of(context);
          return Scaffold(
            body: child,
            backgroundColor: Colors.transparent,
            bottomNavigationBar: Visibility(
              visible: tabsRouter.activeIndex != 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: NavigationBar(
                  height: 72,
                  elevation: 0,
                  backgroundColor: colors.gray,
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                  selectedIndex: tabsRouter.activeIndex,
                  indicatorColor: Colors.transparent,
                  onDestinationSelected: (index) =>
                      {_openPage(index, tabsRouter)},
                  destinations: const [
                    NavBarElement(icon: Iconsax.home_1_copy),
                    NavBarElement(icon: Iconsax.camera_copy),
                    NavBarElement(icon: Iconsax.user_copy),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openPage(int index, TabsRouter tabsRouter) {
    tabsRouter.setActiveIndex(index);
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlantBloc>(lazy: false, create: (_) => PlantBloc()),
        BlocProvider<PlantTrackBloc>(
            lazy: false, create: (_) => PlantTrackBloc()),
        BlocProvider<PlantHistoryBloc>(create: (_) => PlantHistoryBloc()),
        BlocProvider<PlantIdentBloc>(create: (_) => PlantIdentBloc()),
      ],
      child: this,
    );
  }
}
