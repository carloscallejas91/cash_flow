import "package:cash_flow/app/modules/configuration/controllers/configuration_controller.dart";
import "package:cash_flow/app/modules/drawer/views/drawer_widget_view.dart";
import "package:cash_flow/app/widgets/card/cc_card.dart";
import "package:cash_flow/app/widgets/model/cc_row_label_button.dart";
import "package:cash_flow/app/widgets/model/cc_row_label_switch.dart";
import "package:cash_flow/app/widgets/templates/cc_page_with_app_bar.dart";
import "package:cash_flow/core/values/colors.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class ConfigurationView extends GetView<ConfigurationController> {
  const ConfigurationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CCPageWithAppBar(
      title: const Text("Configurações"),
      drawer: DrawerWidgetView(
        title: "Configurações",
      ),
      isSearch: false.obs,
      body: [
        CCCard.surface(
          widgets: [
            Row(
              children: [
                const Icon(
                  userIcon,
                  color: primary,
                ),
                const SizedBox(width: 16),
                Text(
                  "Informações pessoais",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            CCRowLabelButton(
              label: "Editar perfil",
              onPressed: () {},
            ),
            CCRowLabelButton(
              label: "Alterar senha",
              onPressed: () {},
            ),
            CCRowLabelButton(
              label: "Suas preferências",
              onPressed: () {},
            ),
          ],
        ),
        CCCard.surface(
          widgets: [
            Row(
              children: [
                const Icon(
                  themeIcon,
                  color: primary,
                ),
                const SizedBox(width: 16),
                Text(
                  "Preferências de tema",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            CCRowLabelSwitch(
              label: "Ativar tema escuro",
              value: true,
              onChanged: (value) {},
            ),
            CCRowLabelButton(
              label: "Visualizar cores do tema",
              onPressed: () {},
            ),
          ],
        ),
        CCCard.surface(
          widgets: [
            Row(
              children: [
                const Icon(
                  bellIcon,
                  color: primary,
                ),
                const SizedBox(width: 16),
                Text(
                  "Notificações",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            CCRowLabelSwitch(
              label: "Ativar notificações",
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
        CCCard.surface(
          widgets: [
            Row(
              children: [
                const Icon(
                  databaseIcon,
                  color: primary,
                ),
                const SizedBox(width: 16),
                Text(
                  "Banco de dados",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            CCRowLabelButton(
              label: "Criar dados ficticios",
              onPressed: () {},
            ),
            CCRowLabelButton(
              label: "Limpar banco de dados",
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
