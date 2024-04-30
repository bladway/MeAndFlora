import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/app_router/app_router.dart';
import 'package:me_and_flora/core/presentation/widgets/background.dart';
import 'package:me_and_flora/core/presentation/widgets/notifications/unauth_notification.dart';
import 'package:me_and_flora/core/theme/theme.dart';
import 'package:me_and_flora/feature/sign_up/presentation/widgets/agreement.dart';

import '../../../core/domain/models/models.dart';
import '../../../core/presentation/bloc/auth/auth.dart';
import '../../../core/theme/strings.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _copyPasswordController = TextEditingController();

  bool isChecked = false;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _copyPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return BlocListener<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state is AuthSuccessState) {
          if (state.account.accessLevel == AccessLevel.admin) {
            AutoRouter.of(context).push(const NavBarAdminRoute());
          } else if (state.account.accessLevel == AccessLevel.botanic) {
            AutoRouter.of(context).push(const NavBarBotanicRoute());
          } else if (state.account.accessLevel == AccessLevel.user) {
            AutoRouter.of(context).push(const NavBarAuthUserRoute());
            AppMetrica.reportEvent('Вход с регистрацией');
          } else if (state.account.accessLevel == AccessLevel.unauth_user) {
            AutoRouter.of(context).push(const NavBarDefaultRoute());
            AppMetrica.reportEvent('Вход без регистрации');
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            const Background(),
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: width * 0.05,
                  top: height * 0.05,
                  right: width * 0.05,
                  bottom: height * 0.1,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        registration,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        enterLogin,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _loginController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1.5, color: colors.grayGreen),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          counterStyle: Theme.of(context).textTheme.bodySmall,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return value != null && value.length < 6
                              ? enterMin6
                              : null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        enterPassword,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1.5, color: colors.grayGreen),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return value != null && value.length < 6
                              ? enterMin6
                              : null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        enterConfirmPassword,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _copyPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1.5, color: colors.grayGreen),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return value != null &&
                                  value != _passwordController.text
                              ? passwordsDontMatch
                              : null;
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            activeColor: colors.lightGreen,
                            //checkColor: colors.lightGreen,
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = !isChecked;
                              });
                            },
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                bool val = await _showAgreement() ?? false;
                                setState(() {
                                  isChecked = val;
                                });
                              },
                              child: Text(
                                userAgreement,
                                style: Theme.of(context).textTheme.titleSmall,
                                maxLines: 2,
                                softWrap: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                colors.lightGreen,
                                colors.blueGreen
                              ])),
                          child: TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate() &&
                                  isChecked) {
                                BlocProvider.of<AuthBloc>(context).add(
                                    SignUpRequested(_loginController.value.text,
                                        _passwordController.value.text));
                                _formKey.currentState!.reset();
                              }
                            },
                            child: Text(
                              register,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: const Divider(
                                  color: Colors.white,
                                )),
                          ),
                          Text(
                            or,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: const Divider(
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showNotification();
                            },
                            child: Text(
                              enterWithoutAuth,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    alreadyHaveAccount,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  GestureDetector(
                    onTap: () {
                      AutoRouter.of(context).push(const SignInRoute());
                    },
                    child: Text(
                      authorize,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colors.lightGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showNotification() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const UnauthNotification(),
    );
  }

  Future<bool?> _showAgreement() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Agreement(),
    );
  }
}
