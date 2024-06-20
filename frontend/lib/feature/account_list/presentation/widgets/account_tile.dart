import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:me_and_flora/core/domain/models/models.dart';
import 'package:me_and_flora/feature/account_list/presentation/bloc/account_list.dart';

import '../../../../core/presentation/bloc/account/account.dart';
import '../../../../core/theme/theme.dart';

class AccountTile extends StatelessWidget {
  const AccountTile({super.key, required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Iconsax.user_copy,
        color: colors.white,
        size: 24,
      ),
      title: Text(
        account.login,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      subtitle: Text(account.role.displayTitle,
          style: Theme.of(context).textTheme.titleSmall),
      trailing: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [colors.lightGreen, colors.blueGreen])),
            child: TextButton(
              onPressed: () {
                BlocProvider.of<AccountBloc>(context)
                    .add(AccountRemoveRequested(login: account.login));
                // BlocProvider.of<AccountListBloc>(context)
                //     .add(const AccountListRequested());
              },
              child: Text(
                'Удалить',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
