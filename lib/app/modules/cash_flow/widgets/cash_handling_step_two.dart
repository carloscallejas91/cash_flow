import "package:cash_flow/app/modules/cash_flow/controllers/cash_flow_handling_controller.dart";
import "package:cash_flow/core/values/colors.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class CashHandlingStepTwo extends GetView<CashFlowHandlingController> {
  const CashHandlingStepTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Informe se essa movimentação foi liquidada:",
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Obx(
            () => Switch(
              value: controller.wasLiquidated.value,
              onChanged: (value) {
                controller.settlementDateController.text = "";
                controller.wasLiquidated.value = value;
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        Form(
          key: controller.stepTwoFormKey,
          child: Obx(
            () => TextFormField(
              controller: controller.settlementDateController,
              readOnly: true,
              enabled: controller.wasLiquidated.value,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                label: const Text("Data de liquidação"),
                icon: const Icon(settlementDateIcon),
                iconColor: primary,
                suffixIcon: IconButton(
                  icon: const Icon(calendarIcon),
                  onPressed: () => controller.settlementDateDialog(context),
                ),
              ),
              validator: (value) =>
                  controller.validateEntryUtils.validateIsEmpty(value!),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Caso o item não tenha sido liquidado, o mesmo entrará na categoria de previsão de fluxo de caixa.",
        ),
      ],
    );
  }
}
