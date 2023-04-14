import "package:cash_flow/app/modules/authentication/controllers/recover_password_controller.dart";
import "package:cash_flow/app/widgets/button/cc_button.dart";
import "package:cash_flow/app/widgets/card/cc_card.dart";
import "package:cash_flow/app/widgets/templates/cc_page_without_app_bar.dart";
import "package:cash_flow/app/widgets/text/cc_interactive_text.dart";
import "package:cash_flow/core/values/colors.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:cash_flow/core/values/strings.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class RecoverPasswordView extends GetView<RecoverPasswordController> {
  const RecoverPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CCPageWithoutAppBar(
      containerAlignment: Alignment.centerLeft,
      horizontalAlignment: CrossAxisAlignment.start,
      backgroundImage: backgroundLogin,
      widgets: [
        CCCard.surface(
          widgets: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recuperar\nconta",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Image.asset(
                  logotipo,
                  height: 50,
                ),
              ],
            ),
            Form(
              key: controller.formKey,
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  label: Text("E-mail"),
                  icon: Icon(emailIcon),
                  iconColor: primary,
                ),
                validator: (value) =>
                    controller.validateEntry.validateEmail(value!),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            CCButton.primaryContainer(
              textButton: "Recuperar",
              onPressed: controller.validateForm,
            ),
            const SizedBox(
              height: 32,
            ),
            CCInteractiveText(
              text: "Tenho uma conta!",
              interactiveText: "Realizar entrada.",
              interactiveOnPressed: controller.goToLogin,
            ),
          ],
        ),
      ],
    );
  }
}
