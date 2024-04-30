import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/presentation/bloc/account/account.dart';

import '../../core/domain/models/models.dart';
import '../../core/presentation/widgets/notifications/app_notification.dart';
import '../../core/presentation/widgets/widgets.dart';
import '../../core/theme/strings.dart';
import '../../core/theme/theme.dart';

@RoutePage()
class BotanicRegisterScreen extends StatefulWidget {
  const BotanicRegisterScreen({super.key});

  @override
  State<BotanicRegisterScreen> createState() => _BotanicRegisterScreenState();
}

class _BotanicRegisterScreenState extends State<BotanicRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return BlocProvider<AccountBloc>(
      lazy: false,
      create: (_) => AccountBloc(),
      child: BlocListener<AccountBloc, AccountState>(
        listener: (BuildContext context, AccountState state) {
          if (state is AccountAddSuccess) {
            _showChangeNotification(context, changesSuccess);
          }
          if (state is ChangeErrorState) {
            _showChangeNotification(context, changesFail);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: IconButton(
                color: Colors.white,
                icon: const Icon(Icons.arrow_back_ios),
                iconSize: 24,
                onPressed: () {
                  AutoRouter.of(context).pop();
                },
              ),
            ),
            title: Text(
              registration,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
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
                            child: BlocBuilder<AccountBloc, AccountState>(
                              builder: (context, state) {
                                return TextButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      BlocProvider.of<AccountBloc>(context)
                                          .add(AccountAddRequested(
                                              account: Account(
                                        login: _loginController.value.text,
                                        password: _passwordController.value.text,
                                        accessLevel: AccessLevel.botanic,
                                      )));
                                      _formKey.currentState!.reset();
                                    }
                                  },
                                  child: Text(
                                    registerBotanic,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                );
                              }
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showChangeNotification(context, String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AppNotification(text: text),
    );
  }
}
