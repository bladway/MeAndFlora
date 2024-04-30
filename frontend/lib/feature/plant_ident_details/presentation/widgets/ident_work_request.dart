import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/domain/models/models.dart';
import '../../../../core/theme/strings.dart';
import '../../../../core/theme/theme.dart';

class IdentWorkRequest extends StatelessWidget {
  const IdentWorkRequest({
    super.key,
    required this.plant,
  });

  final Plant plant;

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
              identWorkRequest,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              AppMetrica.reportEvent(
                  'Завершение идентификации растения');
              AutoRouter.of(context).pop(true);
            },
            child: Text(
              agree,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.lightGreen,
              ),
            )),
        TextButton(
            onPressed: () {
              AppMetrica.reportEvent(
                  'Отправка на дополнительную идентификацию ботаником');
              AutoRouter.of(context).pop(false);
            },
            child: Text(
              notAgree,
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
