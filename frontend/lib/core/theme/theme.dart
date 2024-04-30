import 'package:flutter/material.dart';

import 'colors.dart';

const colors = AppColors();

//.merge(TextStyle(color: Colors.red)
final mainTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: colors.black),
  useMaterial3: true,
  fontFamily: 'ReemKufi',
  textTheme: TextTheme(
    bodyLarge: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600, //SemiBold
        color: Colors.white
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500, //medium
      color: colors.white,
    ),
    bodySmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700, // Bold
      color: colors.white,
    ),
    titleLarge: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w700, // Bold
      color: colors.white,
    ),
    titleMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600, // SemiBold
      color: colors.white,
    ),
    titleSmall: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w400, //Regular
      color: colors.white,
    ),
    labelLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600, // SemiBold
        color: colors.white,
    ),
    labelMedium: TextStyle(
      fontWeight: FontWeight.w500, //Medium
      fontSize: 14,
      color: colors.white,
    ),
    labelSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400, //Regular
      color: colors.white,
    ),
  ),
);