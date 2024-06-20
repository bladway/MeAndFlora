import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class NavBarElement extends StatelessWidget {
  final IconData icon;
  const NavBarElement({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return NavigationDestination(
      icon: Icon(
        icon,
        color: colors.white,
        size: 24,
      ),
      selectedIcon: ShaderMask(
        shaderCallback: (bounds) => RadialGradient(
          center: Alignment.center,
          radius: 0.5,
          colors: [colors.lightGreen, colors.blueGreen],
          tileMode: TileMode.mirror,
        ).createShader(bounds),
        child: Icon(icon, color: Colors.white, size: 24,),
      ),
      label: icon.toString(),
    );
  }
}
