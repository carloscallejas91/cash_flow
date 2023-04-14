import "package:cash_flow/app/modules/drawer/views/drawer_widget_view.dart";
import "package:cash_flow/app/modules/home/controllers/home_controller.dart";
import "package:cash_flow/app/widgets/templates/cc_page_with_app_bar.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CCPageWithAppBar(
      title: const Text("Olá, Carlos"),
      isSearch: false.obs,
      drawer: DrawerWidgetView(title: "Início"),
      isScrollEnabled: false,
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(
            optionIcon,
          ),
          onSelected: controller.handleClick,
          itemBuilder: (BuildContext context) {
            return {"Logout", "Settings"}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
      body: [
        Container(),
      ],
    );
  }
}
