import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:me_and_flora/core/presentation/widgets/background.dart';

import '../../../../app_router/app_router.dart';
import '../../../../theme/theme.dart';
import '../../../bloc/plant_track/plant_track.dart';
import '../nav_bar_element.dart';

@RoutePage()
class NavBarAdminScreen extends StatelessWidget implements AutoRouteWrapper {
  const NavBarAdminScreen({super.key});

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
          AccountListRoute(),
          PlantPublicWrapperRoute(),
          StatisticRoute(),
          AccountRoute(),
        ],
        builder: (context, child) {
          final tabsRouter = AutoTabsRouter.of(context);
          return Scaffold(
            body: Stack(
              children: [
                const Background(),
                child,
              ],
            ),
            backgroundColor: Colors.transparent,
            bottomNavigationBar: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: NavigationBar(
                height: 72,
                elevation: 0,
                backgroundColor: colors.gray,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                selectedIndex: tabsRouter.activeIndex,
                indicatorColor: Colors.transparent,
                onDestinationSelected: (index) => _openPage(index, tabsRouter),
                destinations: const [
                  NavBarElement(icon: Iconsax.user_copy),
                  NavBarElement(icon: Icons.public),
                  NavBarElement(icon: Icons.stacked_bar_chart),
                  NavBarElement(icon: Iconsax.user_copy),
                ],
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
        BlocProvider<PlantTrackBloc>(
            lazy: false, create: (context) => PlantTrackBloc()),
      ],
      child: this,
    );
  }
}
