import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:me_and_flora/core/domain/models/account.dart';

import '../../../../app_router/app_router.dart';
import '../../../../domain/models/models.dart';
import '../../../../theme/theme.dart';
import '../nav_bar_element.dart';

@RoutePage()
class NavigationBarDefaultScreen extends StatelessWidget {
  const NavigationBarDefaultScreen({super.key});

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
        routes: [
          const HomeRoute(),
          const CameraRoute(),
          AccountRoute(
              account: const Account(
                  name: "Name",
                  surname: "Surname",
                  email: "email",
                  phone: "phone",
                  password: "pass",
                  accessLevel: AccessLevel.user)),
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
                  onDestinationSelected: (index) => {
                    _openPage(index, tabsRouter)
                  },
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
}
