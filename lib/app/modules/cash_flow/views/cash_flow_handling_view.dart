import "package:cash_flow/app/modules/cash_flow/controllers/cash_flow_handling_controller.dart";
import "package:cash_flow/app/modules/cash_flow/widgets/cash_handling_step_one.dart";
import "package:cash_flow/app/modules/cash_flow/widgets/cash_handling_step_three.dart";
import "package:cash_flow/app/modules/cash_flow/widgets/cash_handling_step_two.dart";
import "package:cash_flow/app/widgets/button/cc_button.dart";
import "package:cash_flow/app/widgets/button/cc_icon_button.dart";
import "package:cash_flow/app/widgets/card/cc_card.dart";
import "package:cash_flow/app/widgets/templates/cc_page_with_app_bar.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class CashFlowHandlingView extends GetView<CashFlowHandlingController> {
  const CashFlowHandlingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CCPageWithAppBar(
      title: const Text("Movimentação"),
      onPressedBackButton: controller.goToCashFlow,
      isSearch: false.obs,
      isScrollEnabled: false,
      body: [
        Expanded(
          flex: 0,
          child: CCCard.surface(
            widgets: [
              Text(
                "Utilize os campos abaixo para adicionar um item ao fluxo e caixa.",
                style: Theme.of(context).textTheme.bodyMedium,
              )
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: CCCard.surface(
            padding: EdgeInsets.zero,
            widgets: [
              Obx(
                () => Stepper(
                  currentStep: controller.stepIndex.value,
                  type: StepperType.vertical,
                  controlsBuilder: (context, _) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 0,
                            child: CCIconButton.neutral(
                              icon: arrowLeftLongIcon,
                              iconSize: 22,
                              onPressed: controller.onStepCancel,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: CCButton.primary(
                              textButton: "Continuar",
                              onPressed: controller.onStepContinue,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  steps: const [
                    Step(
                      title: Text("Movimentação"),
                      content: CashHandlingStepOne(),
                    ),
                    Step(
                      title: Text("Liquidar"),
                      content: CashHandlingStepTwo(),
                    ),
                    Step(
                      title: Text("Resumo"),
                      content: CashHandlingStepThree(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
