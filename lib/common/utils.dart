import 'package:flutter/material.dart';


class Utils {

  static const List countries = [
    {"code": '+90', "country": "Turkey"},
    {"code": '+961', "country": "Lebanon"},
    {"code": '+963', "country": "Syria"},
  ];
  static final ThemeData theme = ThemeData(
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          color: AppColors.black, fontSize: 26, letterSpacing: -0.5),
      headlineMedium: TextStyle(
          color: AppColors.black, fontSize: 20, letterSpacing: -0.5),
      headlineSmall: TextStyle(
          color: AppColors.black, fontSize: 17, letterSpacing: -0.5),
      titleLarge: TextStyle(
          color: AppColors.black, fontSize: 17, letterSpacing: -0.5),
      titleMedium: TextStyle(
          color: AppColors.black, fontSize: 15, letterSpacing: -0.5),
      titleSmall: TextStyle(
          color: AppColors.black, fontSize: 13, letterSpacing: -0.5),
      labelLarge: TextStyle(
          color: AppColors.grey, fontSize: 17, letterSpacing: -0.5),
      labelMedium: TextStyle(
          color: AppColors.grey, fontSize: 15, letterSpacing: -0.5),
      labelSmall: TextStyle(
          color: AppColors.grey, fontSize: 13, letterSpacing: -0.5),
    ),
  );
}

class AppColors {
  static const Color greyLight = Color(0xffE8E8E8);
  static const Color grey = Color(0xffBBBBBB);
  static const Color red = Color(0xffFF103E);
  static const Color orange = Color(0xffffbb10);
  static const Color greyDark = Color(0xff707070);
  static const Color black = Color(0xff121314);
  static const Color white = Colors.white;
  static const Color backgroundGrey = Color(0xffFAFAFA);
}
