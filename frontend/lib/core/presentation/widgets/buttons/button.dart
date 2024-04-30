import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class Button extends StatelessWidget {
  const Button({super.key, required this.text, this.callback});
  final String text;
  final AsyncCallback? callback;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [colors.lightGreen, colors.blueGreen])),
        child: TextButton(
          onPressed: () {
            callback;
          },
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}
