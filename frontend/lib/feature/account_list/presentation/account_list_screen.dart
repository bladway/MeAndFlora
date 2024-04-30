import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/app_router/app_router.dart';
import 'package:me_and_flora/core/presentation/widgets/app_bar.dart';
import 'package:me_and_flora/core/presentation/widgets/background.dart';
import 'package:me_and_flora/core/theme/theme.dart';
import 'package:me_and_flora/feature/account_list/presentation/widgets/account_tile.dart';

import '../../../core/presentation/bloc/account/account.dart';
import 'bloc/account_list.dart';

@RoutePage()
class AccountListScreen extends StatelessWidget {
  const AccountListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return MultiBlocProvider(
        providers: [
          BlocProvider<AccountListBloc>(
            lazy: false,
            create: (context) => AccountListBloc()..add(AccountListRequested()),
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
          body: BlocBuilder<AccountListBloc, AccountListState>(
              builder: (context, state) {
            if (state is AccountListLoadSuccess) {
              if (state.accounts.isEmpty) {
                return const Center();
              } else {
                return ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: state.accounts.length,
                  separatorBuilder: (BuildContext context, _) => SizedBox(
                    height: height * 0.03,
                  ),
                  itemBuilder: (context, i) {
                    return AccountTile(
                      account: state.accounts[i],
                    );
                  },
                );
              }
            }
            if (state is AccountListLoadFailure) {
              return const Center();
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
          floatingActionButton: FloatingActionButton(
            backgroundColor: colors.lightGreen,
            onPressed: () {
              AutoRouter.of(context).push(const BotanicRegisterRoute());
            },
            child: Icon(
              Icons.add,
              color: colors.white,
            ),
          ),
        ));
  }
}
