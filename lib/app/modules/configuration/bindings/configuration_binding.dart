import "package:cash_flow/app/modules/configuration/controllers/configuration_controller.dart";
import "package:get/get.dart";

class ConfigurationBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ConfigurationController());
  }
}
