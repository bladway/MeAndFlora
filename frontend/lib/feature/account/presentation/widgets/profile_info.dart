import 'package:flutter/material.dart';

import '../../../../core/domain/models/models.dart';

class ProfileInfo extends StatelessWidget {
  final Account account;
  const ProfileInfo({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${account.name} ${account.surname}',
        style: Theme.of(context).textTheme.bodyLarge,),
      subtitle: Text(account.accessLevel.displayTitle,
        style: Theme.of(context).textTheme.labelSmall,),
    );
  }
}
