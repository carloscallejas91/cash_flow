import "package:cash_flow/app/modules/cash_flow/controllers/cash_flow_handling_controller.dart";
import "package:cash_flow/app/widgets/text/cc_category_session.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class CashHandlingStepThree extends GetView<CashFlowHandlingController> {
  const CashHandlingStepThree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Antes de continuar revise as informações:",
          ),
          const SizedBox(height: 16),
          CCCategorySession(
            label: "Tipo de movimentação",
            value: "${controller.typeMovement.toLowerCase().capitalizeFirst}",
            icon: cashFlowIcon,
          ),
          const SizedBox(height: 16),
          CCCategorySession(
            label: "Categoria",
            value: controller.selectedCategory.value.category,
            icon: categoryIcon,
          ),
          const SizedBox(height: 16),
          CCCategorySession(
            label: "Descrição",
            value: controller.selectedDescription.value.description,
            // controller.selectedClient
            icon: descriptionIcon,
          ),
          const SizedBox(height: 16),
          CCCategorySession(
            label: "Valor",
            value: controller.valueController.text,
            icon: coinsIcon,
          ),
          const SizedBox(height: 16),
          CCCategorySession(
            label: "Método de pagamento",
            value: controller.selectedTypePayment.value,
            icon: typeOfPaymentIcon,
          ),
          const SizedBox(height: 16),
          CCCategorySession(
            label: "Data de vencimento",
            value: controller.dueDateConvert.value,
            icon: dueDateIcon,
          ),
          Visibility(
            visible: controller.wasLiquidated.value,
            child: Column(
              children: [
                const SizedBox(height: 16),
                CCCategorySession(
                  label: "Liquidado em",
                  value: controller.settlementDateConvert.value,
                  icon: settlementDateIcon,
                ),
              ],
            ),
          ),
          Visibility(
            visible: controller.observationController.text.isNotEmpty,
            child: Column(
              children: [
                const SizedBox(height: 16),
                CCCategorySession(
                  label: "Observação",
                  value: controller.observationController.text,
                  icon: observationIcon,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          CCCategorySession(
            label: "Status",
            value: controller.getStatus(),
            icon: statusIcon,
          ),
        ],
      ),
    );
  }
}
