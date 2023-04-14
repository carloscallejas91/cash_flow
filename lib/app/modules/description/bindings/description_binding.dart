import "package:cash_flow/app/modules/description/controllers/description_controller.dart";
import "package:get/get.dart";

class DescriptionBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(DescriptionController());
  }
}
