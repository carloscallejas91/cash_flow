import "package:cash_flow/app/modules/cash_flow/controllers/cash_flow_update_controller.dart";
import "package:cash_flow/app/modules/drawer/widgets/cc_session_divider.dart";
import "package:cash_flow/app/widgets/button/cc_button.dart";
import "package:cash_flow/app/widgets/button/cc_icon_button.dart";
import "package:cash_flow/app/widgets/button/cc_outline_button.dart";
import "package:cash_flow/app/widgets/card/cc_card.dart";
import "package:cash_flow/app/widgets/templates/cc_page_with_app_bar.dart";
import "package:cash_flow/app/widgets/text/cc_category_session.dart";
import "package:cash_flow/core/values/colors.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class CashFlowUpdateView extends GetView<CashFlowUpdateController> {
  const CashFlowUpdateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CCPageWithAppBar(
      title: const Text("Atualizar"),
      onPressedBackButton: controller.goToCashFlow,
      isSearch: false.obs,
      isScrollEnabled: false,
      body: [
        const Expanded(
          flex: 0,
          child: CCCard.surface(
            widgets: [
              Text(
                "Use o botão de editar para atualizar uma ou mais informação.",
              )
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: CCCard.surface(
              widgets: [
                Row(
                  children: [
                    Flexible(
                      child: Obx(
                        () => CCCategorySession(
                          label: "Tipo de movimentação",
                          value: controller.type.value,
                          icon: cashFlowIcon,
                        ),
                      ),
                    ),
                    CCIconButton.secondary(
                      icon: editIcon,
                      onPressed: () => controller.editTypeMoveButton(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const CCSessionDivider(),
                Row(
                  children: [
                    Flexible(
                      child: Column(
                        children: [
                          Obx(
                            () => CCCategorySession(
                              label: "Categoria",
                              value: controller.category.value,
                              icon: categoryIcon,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () => CCCategorySession(
                              label: "Descrição",
                              value: controller.description.value,
                              icon: descriptionIcon,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CCIconButton.secondary(
                      icon: editIcon,
                      onPressed: () => controller.editCategoryAndDescription(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Obx(
                  () => Visibility(
                    visible: controller.categoryIsEmpty.value,
                    child: const Text(
                      "Os campos categoria e descrição não podem ficar vazios.",
                      style: TextStyle(
                        color: error,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const CCSessionDivider(),
                Row(
                  children: [
                    Flexible(
                      child: Obx(
                        () => CCCategorySession(
                          label: "Valor",
                          value: controller.value.value,
                          icon: coinsIcon,
                        ),
                      ),
                    ),
                    CCIconButton.secondary(
                      icon: editIcon,
                      onPressed: () => controller.editMonetaryValueButton(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const CCSessionDivider(),
                Row(
                  children: [
                    Flexible(
                      child: Obx(
                        () => CCCategorySession(
                          label: "Método de pagamento",
                          value: controller.typeOfPayment.value,
                          icon: typeOfPaymentIcon,
                        ),
                      ),
                    ),
                    CCIconButton.secondary(
                      icon: editIcon,
                      onPressed: () => controller.editTypePaymentButton(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const CCSessionDivider(),
                Row(
                  children: [
                    Flexible(
                      child: Obx(
                        () => CCCategorySession(
                          label: "Data de vencimento",
                          value: controller.dueDateConvert.value,
                          icon: dueDateIcon,
                        ),
                      ),
                    ),
                    CCIconButton.secondary(
                      icon: editIcon,
                      onPressed: () => controller.editDueDateButton(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const CCSessionDivider(),
                Obx(
                  () => Row(
                    children: [
                      Flexible(
                        child: CCCategorySession(
                          label: "Liquidado em",
                          value: controller.settlementDateConvert.value,
                          icon: settlementDateIcon,
                        ),
                      ),
                      Visibility(
                        visible: controller.wasLiquidated.value,
                        child: CCIconButton.secondary(
                          icon: editIcon,
                          onPressed: () =>
                              controller.editSettlementDateButton(context),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    const Text(
                      "Informe se essa movimentação foi liquidada:",
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Obx(
                        () => Switch(
                          value: controller.wasLiquidated.value,
                          onChanged: (value) => controller
                              .changeSwitchWasLiquidated(context, value),
                        ),
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => Visibility(
                    visible: controller.wasLiquidated.value &&
                        controller.settlementDateConvert.value == "--/--/--",
                    child: const Text(
                      "Não foi escolhido uma data valida.",
                      style: TextStyle(
                        color: error,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const CCSessionDivider(),
                Row(
                  children: [
                    Flexible(
                      child: Obx(
                        () => CCCategorySession(
                          label: "Observação",
                          value: controller.observation!.isNotEmpty
                              ? controller.observation!.value
                              : "Nenhuma observação.",
                          icon: editIcon,
                        ),
                      ),
                    ),
                    CCIconButton.secondary(
                      icon: editIcon,
                      onPressed: () => controller.editObservationButton(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Flexible(
          flex: 0,
          child: Row(
            children: [
              Flexible(
                flex: 0,
                child: CCOutlineButton.neutral(
                  textButton: "Restaurar",
                  onPressed: () => controller.restoreButton(),
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                flex: 1,
                child: Obx(
                  () => CCButton.primary(
                    textButton: "Atualizar",
                    onPressed: controller.validateForm() == true
                        ? controller.updateButton
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
