import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:me_and_flora/core/theme/strings.dart';

import '../../../../core/theme/theme.dart';

class EditDialog extends StatefulWidget {
  const EditDialog({super.key});

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      title: Text(
        'Редактирование',
        style: Theme.of(context).textTheme.labelLarge,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'Логин',
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
                  borderSide: BorderSide(width: 1.5, color: colors.grayGreen),
                  borderRadius: BorderRadius.circular(8),
                ),
                counterStyle: Theme.of(context).textTheme.bodySmall,
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                return value != null && value.length < 6
                    ? 'Минимум 6 символов'
                    : null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Пароль',
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
                  borderSide: BorderSide(width: 1.5, color: colors.grayGreen),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                return value != null && value.length < 6
                    ? "Минимум 6 символов"
                    : null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Актуальный пароль',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _passwordConfirmController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1.5, color: colors.grayGreen),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                return value != null && value.length < 6
                    ? "Минимум 6 символов"
                    : null;
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              AutoRouter.of(context).pop([
                _loginController.value.text,
                _passwordController.value.text,
                _passwordConfirmController.value.text
              ]);
            },
            child: Text(
              saveChanges,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.lightGreen,
              ),
            )),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              cancelChanges,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.lightGreen,
              ),
            )),
      ],
    );
  }
}
