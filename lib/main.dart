import 'package:baedalgeek_driver/config/app_routes.dart';
import 'package:baedalgeek_driver/config/constants.dart';
import 'package:baedalgeek_driver/controller/binding.dart';
import 'package:baedalgeek_driver/screen/authentication/init_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'global/global.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences = await SharedPreferences.getInstance();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColors.primaryColor,
  ));

  runApp(const BaedalGeekDriver());
}

class BaedalGeekDriver extends StatelessWidget {
  const BaedalGeekDriver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: Bind(),
      debugShowCheckedModeBanner: false,
      getPages: AppRoutes.generateRoute,
      theme: ThemeData(
        appBarTheme: AppTheme.appBarTheme,
        elevatedButtonTheme: AppTheme.elevatedButtonTheme,
      ),
      home: InItScreen(),
    );
  }
}
