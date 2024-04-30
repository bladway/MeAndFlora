import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/domain/models/models.dart';
import '../../../../core/theme/theme.dart';

class ProfileInfo extends StatelessWidget {
  final Account account;
  const ProfileInfo({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Iconsax.user_copy,
        color: colors.white,
        size: 24,
      ),
      title: Text(account.login,
        style: Theme.of(context).textTheme.bodyLarge,),
      subtitle: Text(account.accessLevel.displayTitle,
        style: Theme.of(context).textTheme.labelSmall,),
    );
  }
}
