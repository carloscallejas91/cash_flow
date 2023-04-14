import "package:get/get.dart";

class DrawerWidgetController extends GetxController {
  void goToCashFlow() {
    Get.offAllNamed("/cash_flow");
  }

  void goToCategory() {
    Get.offAllNamed("/category");
  }

  void goToDescription() {
    Get.offAllNamed("/description");
  }

  void goToConfiguration() {
    Get.offAllNamed("/configuration");
  }
}
