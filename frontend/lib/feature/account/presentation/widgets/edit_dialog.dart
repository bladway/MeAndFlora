import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
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
                  borderSide:
                  BorderSide(width: 1.5, color: colors.grayGreen),
                  borderRadius: BorderRadius.circular(8),
                ),
                counterStyle: Theme.of(context).textTheme.bodySmall,
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                return value != null && value.length < 6
                    ? 'Введите минимум 6 символов'
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
                  borderSide:
                  BorderSide(width: 1.5, color: colors.grayGreen),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                return value != null && value.length < 6
                    ? "Введите минимум 6 символов"
                    : null;
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Отмена",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.lightGreen,
              ),
            )),
        TextButton(
            onPressed: () {

            },
            child: Text(
              "Ок",
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
