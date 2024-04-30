import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:me_and_flora/core/app_router/app_router.dart';

import '../../../../core/theme/strings.dart';
import '../../../../core/theme/theme.dart';

class Advertisement extends StatelessWidget {
  const Advertisement({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      title: Text(
        notification,
        style: Theme.of(context).textTheme.labelLarge,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              identLimitReached,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              AppMetrica.reportEvent(
                  'Запрос на просмотр рекламы');
              AutoRouter.of(context).pop();
              AutoRouter.of(context).push(const AdvertisementRoute());
            },
            child: Text(
              watchAdd,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.lightGreen,
              ),
            )),
        TextButton(
            onPressed: () {
              AutoRouter.of(context).pop();
            },
            child: Text(
              cancel,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.lightGreen,
              ),
            )),
      ],
    );
  }
}
