import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/app_router/app_router.dart';
import 'package:me_and_flora/core/domain/models/access_level.dart';
import 'package:me_and_flora/core/presentation/bloc/auth/auth.dart';
import 'package:me_and_flora/core/presentation/widgets/background.dart';
import 'package:me_and_flora/core/presentation/widgets/notifications/app_notification.dart';
import 'package:me_and_flora/core/theme/strings.dart';
import 'package:me_and_flora/core/theme/theme.dart';

import '../../../core/presentation/widgets/notifications/unauth_notification.dart';

@RoutePage()
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _copyPasswordController = TextEditingController();

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
          if (state.account.role == AccessLevel.admin) {
            AutoRouter.of(context).push(const NavBarAdminRoute());
          } else if (state.account.role == AccessLevel.botanist) {
            AutoRouter.of(context).push(const NavBarBotanicRoute());
          } else if (state.account.role == AccessLevel.user) {
            AutoRouter.of(context).push(const NavBarAuthUserRoute());
            AppMetrica.reportEvent('Вход авторизированного пользавателя');
          } else if (state.account.role == AccessLevel.unauth_user) {
            AutoRouter.of(context).push(const NavBarDefaultRoute());
            AppMetrica.reportEvent('Вход без регистрации');
          }
        } else if (state is AuthErrorState) {
          _showNotFoundNotification();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            const Background(),
            BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
              if (state is AuthLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return SafeArea(
                  minimum: EdgeInsets.only(
                    left: width * 0.05,
                    top: height * 0.1,
                    right: width * 0.05,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authorization,
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
                              borderSide: BorderSide(
                                  width: 1.5, color: colors.grayGreen),
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
                              borderSide: BorderSide(
                                  width: 1.5, color: colors.grayGreen),
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
                                if (_formKey.currentState!.validate()) {
                                  BlocProvider.of<AuthBloc>(context).add(
                                      SignInRequested(
                                          _loginController.value.text,
                                          _passwordController.value.text));
                                  _formKey.currentState!.reset();
                                }
                              },
                              child: Text(
                                authorize,
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
                                _showUnauthNotification();
                              },
                              child: Text(
                                enterWithoutAuth,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          alignment: Alignment.bottomCenter,
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                haveAccountQuestion,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              GestureDetector(
                                onTap: () {
                                  AutoRouter.of(context)
                                      .push(const SignUpRoute());
                                },
                                child: Text(
                                  register,
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
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _showNotFoundNotification() async => showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AppNotification(text: authErrorNotification);
        },
      );

  Future<void> _showUnauthNotification() async => showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const UnauthNotification();
        },
      );
}
