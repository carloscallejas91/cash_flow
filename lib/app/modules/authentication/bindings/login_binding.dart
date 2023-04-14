import "package:cash_flow/app/modules/authentication/controllers/login_controller.dart";
import "package:get/get.dart";

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
  }
}
