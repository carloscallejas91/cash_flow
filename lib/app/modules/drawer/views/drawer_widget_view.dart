import "package:cash_flow/app/modules/drawer/controllers/drawer_controller.dart";
import "package:cash_flow/app/modules/drawer/widgets/cc_list_tile.dart";
import "package:cash_flow/app/modules/drawer/widgets/cc_list_tile_secondary.dart";
import "package:cash_flow/app/modules/drawer/widgets/cc_session_divider.dart";
import "package:cash_flow/core/values/colors.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:cash_flow/core/values/strings.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class DrawerWidgetView extends StatelessWidget {
  final DrawerWidgetController _controller = Get.put(DrawerWidgetController());

  final String title;

  DrawerWidgetView({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: primaryContainer,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Image.asset(
                    logotipo,
                    height: 150,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Olá!",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Text(
                    "Carlos Callejas",
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  const Divider(),
                ],
              ),
            ),
            CCListTile.onPrimaryContainer(
              title: "Início",
              icon: homeIcon,
              isSelected: title == "Início",
              onPressed: () {},
            ),
            const SizedBox(height: 8),
            CCListTile.onPrimaryContainer(
              icon: cashFlowIcon,
              title: "Fluxo de caixa",
              isSelected: title == "Fluxo de caixa",
              onPressed: () => _controller.goToCashFlow(),
            ),
            const SizedBox(height: 8),
            CCListTile.onPrimaryContainer(
              icon: orderIcon,
              title: "Meus pedidos",
              isSelected: title == "Meus pedidos",
              onPressed: () {},
            ),
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 32),
                initiallyExpanded:
                    title == "Categorias" || title == "Descrições",
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      registerIcon,
                      color: primary,
                      size: 16,
                    ),
                  ],
                ),
                title: const Text(
                  "Cadastros",
                  style: TextStyle(fontWeight: FontWeight.bold, color: primary),
                ),
                // childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: outline.withOpacity(.2),
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Column(
                      children: [
                        CCListTileSecondary.onPrimaryContainer(
                          icon: categoryIcon,
                          iconColor: secondary,
                          title: "Categorias",
                          isSelected: title == "Categorias",
                          onPressed: _controller.goToCategory,
                        ),
                        CCListTileSecondary.onPrimaryContainer(
                          icon: descriptionIcon,
                          iconColor: secondary,
                          title: "Descrições",
                          isSelected: title == "Descrições",
                          onPressed: _controller.goToDescription,
                        ),
                        CCListTileSecondary.onPrimaryContainer(
                          icon: clientIcon,
                          iconColor: secondary,
                          title: "Clientes",
                          onPressed: () {},
                        ),
                        CCListTileSecondary.onPrimaryContainer(
                          icon: supplierIcon,
                          iconColor: secondary,
                          title: "Fornecedores",
                          onPressed: () {},
                        ),
                        CCListTileSecondary.onPrimaryContainer(
                          icon: productIcon,
                          iconColor: secondary,
                          title: "produtos",
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const CCSessionDivider(),
            CCListTile.onPrimaryContainer(
              icon: configIcon,
              iconColor: tertiary,
              title: "Configurações",
              isSelected: title == "Configurações",
              onPressed: _controller.goToConfiguration,
            ),
            const CCSessionDivider(),
            CCListTile.onPrimaryContainer(
              icon: logoutIcon,
              iconColor: tertiary,
              title: "Sair",
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
