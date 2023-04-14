import "package:cash_flow/app/modules/home/controllers/home_controller.dart";
import "package:get/get.dart";

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}
