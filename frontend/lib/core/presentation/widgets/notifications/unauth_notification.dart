import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/theme/strings.dart';

import '../../../app_router/app_router.dart';
import '../../../theme/theme.dart';
import '../../bloc/auth/auth.dart';

class UnauthNotification extends StatelessWidget {
  const UnauthNotification({super.key});

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
              unauthNotification,
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
              cancel,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.lightGreen,
              ),
            )),
        TextButton(
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(UnauthRequested());
              AutoRouter.of(context).pop();
              //AutoRouter.of(context).push(const HomeRoute());
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
