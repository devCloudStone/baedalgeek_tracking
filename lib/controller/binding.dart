import 'package:baedalgeek_driver/controller/locate_controller.dart';
import 'package:get/get.dart';

class Bind extends Bindings {
  @override
  void dependencies() {
    Get.put(LocateController(), permanent: true);
  }
}
