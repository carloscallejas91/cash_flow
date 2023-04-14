import "package:cash_flow/app/widgets/dialog/cc_dialog.dart";
import "package:cash_flow/core/utils/validate_entry_utils.dart";
import "package:cash_flow/routes/app_routes.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class RecoverPasswordController extends GetxController {
  // keys
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // utils
  ValidateEntryUtils validateEntry = ValidateEntryUtils();

  // widgets
  final CCDialog ccDialog = CCDialog();

  void validateForm() {
    if (formKey.currentState!.validate()) {
      ccDialog.dialogPositiveButton(
        title: "Recuperar conta",
        contentText:
            "Você receberá em seu e-mail instruções de como redefinir sua senha.",
        onPressedPositiveButton: goToLogin,
      );
    }
  }

  void goToLogin() {
    Get.offAllNamed(Routes.LOGIN);
  }
}
