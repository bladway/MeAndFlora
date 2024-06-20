import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../core/presentation/widgets/buttons/circle_button.dart';

@RoutePage()
class AdvertisementScreen extends StatelessWidget {
  const AdvertisementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppMetrica.reportEvent('Просмотр рекламы');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    AutoRouter.of(context).pop();
                  },
                  child: const CircleButton(icon: Icons.close),
                ),
              )),
        ],
      ),
      body: Center(
          child: Text(
        'Место для вашей рекламы',
        style: Theme.of(context).textTheme.labelLarge,
      )),
    );
  }
}
