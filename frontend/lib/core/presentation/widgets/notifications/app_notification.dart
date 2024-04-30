import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../theme/strings.dart';
import '../../../theme/theme.dart';

class AppNotification extends StatelessWidget {
  const AppNotification({super.key, required this.text, this.title = notification});
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      title: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              text,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              AutoRouter.of(context).pop();
            },
            child: Text(
              ok,
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
