import "package:cash_flow/app/modules/authentication/controllers/recover_password_controller.dart";
import "package:get/get.dart";

class RecoverPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(RecoverPasswordController());
  }
}
