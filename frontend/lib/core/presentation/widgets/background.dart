import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Stack(
      children: [
        Image.asset(
          "assets/images/homeBackground.png",
          height: height * 0.5,
          width: width,
          fit: BoxFit.cover,
        ),
        Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [Colors.transparent, Colors.black])),
        ),
      ],
    );
  }
}
