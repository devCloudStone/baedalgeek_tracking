import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xff0f1838);
  static const Color pointColor = Color(0xfff5cc1f);
  static const Color headFontColor = Color(0xff131313);
  static const Color fontColor = Color(0xff505050);
  static const Color subTextColor = Color(0xffa0a0a0);
  static const Color whiteColor = Color(0xffffffff);
  static const Color redColor = Color(0xfff00000);
}

class AppFontSize {
  static const double bigTitleFontSize = 16.0;
  static const double mediumTitleFontSize = 14.0;
}

class AppTheme {
  static AppBarTheme appBarTheme = const AppBarTheme(
    titleTextStyle: TextStyle(
      fontSize: AppFontSize.bigTitleFontSize,
      fontWeight: FontWeight.bold,
    ),
    centerTitle: true,
    elevation: 0,
    backgroundColor: AppColors.primaryColor,
  );

  static ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: const TextStyle(
        fontSize: AppFontSize.mediumTitleFontSize,
      ),
      onPrimary: AppColors.whiteColor,
      primary: AppColors.primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
    ),
  );
}
