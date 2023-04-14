import "package:cash_flow/app/widgets/dialog/cc_dialog.dart";
import "package:cash_flow/core/utils/validate_entry_utils.dart";
import "package:cash_flow/routes/app_routes.dart";
import "package:flutter/cupertino.dart";
import "package:get/get.dart";

class LoginController extends GetxController {
  // keys
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // utils
  ValidateEntryUtils validateEntryUtils = ValidateEntryUtils();

  // widgets
  final CCDialog _ccDialog = CCDialog();

  // controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // conditionals
  RxBool obscureText = true.obs;
  RxBool rememberEmail = false.obs;

  @override
  void onInit() {
    initializeVariable();
    super.onInit();
  }

  void initializeVariable() {
    emailController.text = "carlos@email.com";
    passwordController.text = "Ca@020392";
  }

  void togglePasswordVisibility() {
    if (obscureText.isTrue) {
      obscureText.value = false;
    } else if (obscureText.isFalse) {
      obscureText.value = true;
    }
  }

  void validateForm() {
    if (formKey.currentState!.validate()) goToHome();
  }

  void goToRecoverPassword() {
    Get.offAllNamed(Routes.RECOVER_PASSWORD);
  }

  void goToHome() {
    _ccDialog.loadingWithText(message: "Realizando entrada...");
    Future.delayed(
      const Duration(seconds: 3),
    ).whenComplete(
      () {
        Get.back();
        Get.offAllNamed(Routes.HOME);
      },
    );
  }
}
