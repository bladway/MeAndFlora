import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final IconData icon;

  const CircleButton({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Center(
        child: Icon(
          icon,
          color: Colors.black54,
        ),
      ),
    );
  }
}
