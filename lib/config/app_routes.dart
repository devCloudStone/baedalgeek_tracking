import 'package:baedalgeek_driver/main.dart';
import 'package:baedalgeek_driver/screen/tracking/tracking_screen.dart';

import 'package:get/get.dart';

class AppRoutes {
  static List<GetPage<dynamic>> generateRoute = [
    GetPage(name: '/', page: () => const BaedalGeekDriver()),
    GetPage(name: '/tracking-location', page: () => const TrackingScreen()),
  ];
}
