import 'package:baedalgeek_driver/config/app_routes.dart';
import 'package:baedalgeek_driver/config/constants.dart';
import 'package:baedalgeek_driver/screen/authentication/init_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  runApp(const BaedalGeekDriver());

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColors.primaryColor,
  ));
}

class BaedalGeekDriver extends StatelessWidget {
  const BaedalGeekDriver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: AppRoutes.generateRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xff0f1838),
        ),
      ),
      home: const InItScreen(),
    );
  }
}
