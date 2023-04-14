import "package:cash_flow/app/modules/authentication/bindings/login_binding.dart";
import "package:cash_flow/app/modules/authentication/bindings/recover_password_binding.dart";
import "package:cash_flow/app/modules/authentication/views/login_view.dart";
import "package:cash_flow/app/modules/authentication/views/recover_password_view.dart";
import "package:cash_flow/app/modules/cash_flow/bindings/cash_flow_binding.dart";
import "package:cash_flow/app/modules/cash_flow/bindings/cash_flow_handling_binding.dart";
import "package:cash_flow/app/modules/cash_flow/bindings/cash_flow_summary_binding.dart";
import "package:cash_flow/app/modules/cash_flow/bindings/cash_flow_update_binding.dart";
import "package:cash_flow/app/modules/cash_flow/views/cash_flow_handling_view.dart";
import "package:cash_flow/app/modules/cash_flow/views/cash_flow_summary_view.dart";
import "package:cash_flow/app/modules/cash_flow/views/cash_flow_update_view.dart";
import "package:cash_flow/app/modules/cash_flow/views/cash_flow_view.dart";
import "package:cash_flow/app/modules/category/bindings/category_binding.dart";
import "package:cash_flow/app/modules/category/bindings/category_update_binding.dart";
import "package:cash_flow/app/modules/category/views/category_update_view.dart";
import "package:cash_flow/app/modules/category/views/category_view.dart";
import "package:cash_flow/app/modules/color_palette/bindings/color_palette_binding.dart";
import "package:cash_flow/app/modules/color_palette/views/color_palette_view.dart";
import "package:cash_flow/app/modules/configuration/bindings/configuration_binding.dart";
import "package:cash_flow/app/modules/configuration/views/configuration_view.dart";
import "package:cash_flow/app/modules/description/bindings/description_binding.dart";
import "package:cash_flow/app/modules/description/bindings/description_update_binding.dart";
import "package:cash_flow/app/modules/description/views/description_update_view.dart";
import "package:cash_flow/app/modules/description/views/description_view.dart";
import "package:cash_flow/app/modules/home/bindings/home_binding.dart";
import "package:cash_flow/app/modules/home/views/home_view.dart";
import "package:cash_flow/routes/app_routes.dart";
import "package:get/get.dart";

class AppPage {
  AppPage._();

  static final List<GetPage> routes = <GetPage>[
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.RECOVER_PASSWORD,
      page: () => const RecoverPasswordView(),
      binding: RecoverPasswordBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.CASH_FLOW,
      page: () => const CashFlowView(),
      binding: CashFlowBinding(),
    ),
    GetPage(
      name: Routes.CASH_FLOW_HANDLING,
      page: () => const CashFlowHandlingView(),
      binding: CashFlowHandlingBinding(),
    ),
    GetPage(
      name: Routes.CASH_FLOW_UPDATE,
      page: () => const CashFlowUpdateView(),
      binding: CashFlowUpdateBinding(),
    ),
    GetPage(
      name: Routes.CASH_FLOW_SUMMARY,
      page: () => const CashFlowSummaryView(),
      binding: CashFlowSummaryBinding(),
    ),
    GetPage(
      name: Routes.CATEGORY,
      page: () => const CategoryView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: Routes.CATEGORY_UPDATE,
      page: () => const CategoryUpdateView(),
      binding: CategoryUpdateBinding(),
    ),
    GetPage(
      name: Routes.DESCRIPTION,
      page: () => const DescriptionView(),
      binding: DescriptionBinding(),
    ),
    GetPage(
      name: Routes.DESCRIPTION_UPDATE,
      page: () => const DescriptionUpdateView(),
      binding: DescriptionUpdateBinding(),
    ),
    GetPage(
      name: Routes.CONFIGURATION,
      page: () => const ConfigurationView(),
      binding: ConfigurationBinding(),
    ),
    GetPage(
      name: Routes.COLOR_PALETTE,
      page: () => const ColorPaletteView(),
      binding: ColorPaletteBinding(),
    ),
  ];
}
