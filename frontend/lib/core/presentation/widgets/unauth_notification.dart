import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../app_router/app_router.dart';
import '../../theme/theme.dart';

class UnauthNotification extends StatelessWidget {
  const UnauthNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      title: Text(
        'Уведомление',
        style: Theme.of(context).textTheme.labelLarge,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'Незарегистрированные пользователи не могут '
                  'использовать некоторые функции приложения. Для расширения'
                  ' функциональных возможностей необходима регистрация.',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Отмена",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.lightGreen,
              ),
            )),
        TextButton(
            onPressed: () {
              AutoRouter.of(context).push(const HomeRoute());
            },
            child: Text(
              "Ок",
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
