import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/domain/models/models.dart';
import 'package:me_and_flora/core/presentation/bloc/account/account.dart';
import 'package:me_and_flora/core/presentation/widgets/widgets.dart';
import 'package:me_and_flora/feature/account_list/presentation/bloc/account_list.dart';
import 'package:me_and_flora/feature/account_list/presentation/widgets/account_tile.dart';

class AccountScrollList extends StatefulWidget {
  const AccountScrollList({super.key});

  @override
  State<AccountScrollList> createState() => _AccountScrollListState();
}

class _AccountScrollListState extends State<AccountScrollList> {
  bool _isLastPage = false;
  int _pageNumber = 0;
  final int _nextPageTrigger = 2;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    List<Account> accounts = [];
    return Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<AccountListBloc, AccountListState>(
            builder: (context, state) {
              if (state is AccountListLoadInProcess) {
                return const Center(child: CircularProgressIndicator(),);
              }
          if (state is AccountListLoadSuccess) {
            if (state.accounts.isNotEmpty) {
              _pageNumber++;
              accounts.addAll(state.accounts);
            } else if (accounts.isEmpty) {
              return const EmptyWidget();
            }
          }
          return BlocListener<AccountBloc, AccountState>(
            listener: (BuildContext context, AccountState state) {
              if (state is AccountAddSuccess || state is AccountRemoveSuccess) {
                accounts = [];
                BlocProvider.of<AccountListBloc>(context).add(const AccountListRequested());
              }
            },
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: accounts.length + (_isLastPage ? 0 : 1),
              separatorBuilder: (BuildContext context, _) => SizedBox(
                height: height * 0.03,
              ),
              itemBuilder: (context, index) {
                if (index == accounts.length - _nextPageTrigger && !_isLastPage) {
                  BlocProvider.of<AccountListBloc>(context)
                      .add(AccountListRequested(page: _pageNumber));
                }
                if (index == accounts.length) {
                  _isLastPage = true;
                  if (state is AccountListLoadInProcess) {
                    return const CircularProgressIndicator();
                  } else {
                    return const Center();
                  }
                }
                return AccountTile(
                  account: accounts[index],
                );
              },
            ),
          );
        }));
  }
}
