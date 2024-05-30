import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/app_router/app_router.dart';
import 'package:me_and_flora/core/presentation/bloc/account/account.dart';
import 'package:me_and_flora/core/presentation/widgets/notifications/app_notification.dart';
import 'package:me_and_flora/core/theme/strings.dart';
import 'package:me_and_flora/feature/account/presentation/widgets/edit_dialog.dart';

import '../../../core/domain/models/models.dart';
import '../../../core/presentation/bloc/auth/auth.dart';
import '../../../core/theme/theme.dart';
import 'widgets/profile_info.dart';
import 'widgets/profile_settings_list.dart';

@RoutePage()
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountBloc>(
      create: (_) => AccountBloc(),
      child: BlocListener<AccountBloc, AccountState>(
        listener: (BuildContext context, AccountState state) {
          if (state is ChangeSavedState) {
            _showChangeNotification(context, changesSuccess);
            BlocProvider.of<AuthBloc>(context)
                .add(UpdateRequest(account: state.account));
          }
          if (state is ChangeErrorState) {
            _showChangeNotification(context, changesFail);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                return ProfileInfo(
                    account: state is AuthenticatedState
                        ? state.account
                        : Account());
              }),
              ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    account,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                    return ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: Text(
                        editProfile,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      trailing: Icon(
                        Icons.edit,
                        size: 24,
                        color: colors.lightGray,
                      ),
                      onTap: () async {
                        if (state is AuthenticatedState &&
                            (state.account.role == AccessLevel.user ||
                                state.account.role ==
                                    AccessLevel.botanist)) {
                          final result = await _showEditDialog(context);
                          BlocProvider.of<AccountBloc>(context).add(
                              ChangeRequested(
                                  prevLogin: state.account.login,
                                  login: result[0] ?? state.account.login,
                                  password: result[1] ?? state.account.password,
                                  passwordConfirm: result[2]));
                        }
                      },
                    );
                  }),
                  const ProfileSettingsList(
                    title: support,
                    elementList: [rules, connectSupport, userAgreement],
                    notificationTitles: [rules, support, userAgreement],
                    notificationTexts: [rulesText, supportEmail, userAgreementText],
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
                            BlocProvider.of<AuthBloc>(context)
                                .add(LogOutRequested());
                            AutoRouter.of(context).push(const SignInRoute());
                            AutoRouter.of(context)
                                .replaceAll([const SignInRoute()]);
                          },
                          child: BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                            return Text(
                              state is AuthenticatedState &&
                                      state.account.role ==
                                          AccessLevel.unauth_user
                                  ? register
                                  : logOut,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: colors.lightGreen,
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _showEditDialog(context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const EditDialog();
      },
    );
  }

  Future<void> _showChangeNotification(context, String text) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AppNotification(text: text);
      },
    );
  }
}
