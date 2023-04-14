import "package:cash_flow/app/modules/description/controllers/description_update_controller.dart";
import "package:get/get.dart";

class DescriptionUpdateBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(DescriptionUpdateController());
  }
}
