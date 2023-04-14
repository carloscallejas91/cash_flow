import "package:cash_flow/app/modules/authentication/controllers/login_controller.dart";
import "package:cash_flow/app/widgets/button/cc_button.dart";
import "package:cash_flow/app/widgets/card/cc_card.dart";
import "package:cash_flow/app/widgets/templates/cc_page_without_app_bar.dart";
import "package:cash_flow/app/widgets/text/cc_interactive_text.dart";
import "package:cash_flow/core/values/colors.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:cash_flow/core/values/strings.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

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
                  "Realizar\nentrada",
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
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      label: Text("E-mail"),
                      icon: Icon(emailIcon),
                      iconColor: primary,
                    ),
                    validator: (value) =>
                        controller.validateEntryUtils.validateEmail(value!),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Obx(
                    () => TextFormField(
                      controller: controller.passwordController,
                      obscureText: controller.obscureText.value,
                      decoration: InputDecoration(
                        label: const Text("Senha"),
                        icon: const Icon(passwordIcon),
                        iconColor: primary,
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.togglePasswordVisibility();
                          },
                          icon: controller.obscureText.isTrue
                              ? const Icon(visibilityOffIcon)
                              : const Icon(
                                  visibilityIcon,
                                ),
                        ),
                        suffixIconColor: primary,
                      ),
                      validator: (value) => controller.validateEntryUtils
                          .validatePassword(value!),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Obx(
                        () => Checkbox(
                          value: controller.rememberEmail.value,
                          onChanged: (bool? value) {
                            controller.rememberEmail.value = value!;
                          },
                        ),
                      ),
                      const Text("Lembrar e-mail"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            CCButton.primary(
              textButton: "Entrar",
              onPressed: controller.validateForm,
            ),
            const SizedBox(
              height: 32,
            ),
            CCInteractiveText(
              text: "Esqueci minha senha!",
              interactiveText: "Recuperar.",
              interactiveOnPressed: controller.goToRecoverPassword,
            ),
          ],
        ),
      ],
    );
  }
}
