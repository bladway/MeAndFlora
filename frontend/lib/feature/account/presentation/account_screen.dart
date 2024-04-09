import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:me_and_flora/feature/account/presentation/widgets/edit_dialog.dart';

import '../../../core/app_router/app_router.dart';
import '../../../core/domain/models/models.dart';
import '../../../core/theme/theme.dart';
import 'widgets/profile_info.dart';
import 'widgets/profile_settings_list.dart';

@RoutePage()
class AccountScreen extends StatelessWidget {
  final Account account;

  const AccountScreen({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ProfileInfo(account: account),
          ListView(
            shrinkWrap: true,
            children: [
              Text('Аккаунт', style: Theme.of(context).textTheme.labelLarge, ),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: Text('Редактировать профиль',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                trailing: Icon(Icons.edit,
                  size: 24,
                  color: colors.lightGray,
                ),
                onTap: () {
                  _showEditDialog(context);
                },
              ),
              const ProfileSettingsList(
                title: 'Аккаунт',
                elementList: ['Редактировать профиль'],
              ),
              const ProfileSettingsList(
                title: 'Поддержка',
                elementList: ['Связаться с поддержкой', 'Правила'],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Другое',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        AutoRouter.of(context).push(const SignUpRoute());
                      },
                      child: Text(account.accessLevel == AccessLevel.unauth_user
                          ? 'Войти'
                          : 'Выйти',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: colors.lightGreen,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const EditDialog();
      },
    );
  }
}
