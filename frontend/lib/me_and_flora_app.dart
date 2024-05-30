import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/theme/theme.dart';

import 'core/app_router/app_router.dart';
import 'core/presentation/bloc/auth/auth.dart';

class MeAndFloraApp extends StatefulWidget {
  const MeAndFloraApp({super.key});

  @override
  State<MeAndFloraApp> createState() => _MeAndFloraAppState();
}

class _MeAndFloraAppState extends State<MeAndFloraApp> {

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => AuthBloc()..add(const CheckIsLogInRequested()),
      child: MaterialApp.router(
        title: 'MeAndFlora',
        theme: mainTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
