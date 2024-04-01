import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:me_and_flora/core/app_router/app_router.dart';
import 'package:me_and_flora/core/theme/theme.dart';

import '../../sign_up/presentation/sign_up_screen.dart';

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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Image.asset(
            "assets/images/unsplash.png",
            height: height * 0.5,
            width: width,
            fit: BoxFit.cover,
          ),
          Container(
            height: height * 0.5,
            width: width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.1), Colors.black])
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(
              left: width * 0.05,
              top: height * 0.1,
              right: width * 0.05,
              bottom: height * 0.1,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Авторизация',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20,),
                  Text('Введите логин',
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
                            width: 1.5,
                            color: colors.grayGreen
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      counterStyle:
                      Theme.of(context).textTheme.bodySmall,
                    ),
                    autovalidateMode:
                    AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return value != null && value.length < 6
                          ? 'Введите минимум 6 символов'
                          : null;
                    },
                  ),
                  const SizedBox(height: 10,),
                  Text('Введите пароль',
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
                            width: 1.5,
                            color: colors.grayGreen
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    autovalidateMode:
                    AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return value != null && value.length < 6
                          ? "Введите минимум 6 символов"
                          : null;
                    },
                  ),
                  const SizedBox(height: 20,),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [colors.lightGreen, colors.blueGreen])
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _authenticateWithEmailAndPassword(context);
                          }
                        },
                        child: Text('Авторизоваться',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: const Divider(color: Colors.white,)
                        ),
                      ),
                      Text("или",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: const Divider(color: Colors.white,)
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          AutoRouter.of(context).push(const HomeRoute());
                        },
                        child: Text("Войти без регистрации",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                ],
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
                Text("Ещё нет аккаунта? ",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                GestureDetector(
                  onTap: () {
                    AutoRouter.of(context).push(const SignUpRoute());
                  },
                  child: Text("Зарегистрироваться",
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
    );
  }

  void _authenticateWithEmailAndPassword(context) {
  }
}
