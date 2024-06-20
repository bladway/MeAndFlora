import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/app_router/app_router.dart';
import 'package:me_and_flora/core/presentation/widgets/app_bar.dart';
import 'package:me_and_flora/core/theme/theme.dart';
import 'package:me_and_flora/feature/account_list/presentation/widgets/account_scroll_list.dart';

import '../../../core/presentation/bloc/account/account.dart';
import 'bloc/account_list.dart';

@RoutePage()
class AccountListScreen extends StatelessWidget {
  const AccountListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;

    return MultiBlocProvider(
      providers: [
        BlocProvider<AccountListBloc>(
          lazy: false,
          create: (context) =>
              AccountListBloc()..add(const AccountListRequested()),
        ),
        BlocProvider<AccountBloc>(
            lazy: false, create: (context) => AccountBloc()),
      ],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBarWidget(
          text: 'Пользователи',
          height: height * 0.06,
        ),
        body: const AccountScrollList(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: colors.lightGreen,
          onPressed: () {
            AutoRouter.of(context).push(const CreateUserRoute());
          },
          child: Icon(
            Icons.add,
            color: colors.white,
          ),
        ),
      ),
    );
  }
}
