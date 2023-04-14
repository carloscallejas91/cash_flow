import "package:cash_flow/app/modules/cash_flow/controllers/cash_flow_controller.dart";
import "package:cash_flow/app/modules/drawer/views/drawer_widget_view.dart";
import "package:cash_flow/app/widgets/button/cc_text_button.dart";
import "package:cash_flow/app/widgets/button/cc_text_button_icon.dart";
import "package:cash_flow/app/widgets/calendar/cc_calendar.dart";
import "package:cash_flow/app/widgets/floating_action_button/cc_floating_action_button.dart";
import "package:cash_flow/app/widgets/floating_action_button/cc_floating_action_button_extend.dart";
import "package:cash_flow/app/widgets/model/cc_expandable_list_item_model.dart";
import "package:cash_flow/app/widgets/replacement/cc_result_not_found.dart";
import "package:cash_flow/app/widgets/templates/cc_page_with_app_bar.dart";
import "package:cash_flow/core/values/colors.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:cash_flow/data/enum/cash_flow_movement_type.dart";
import "package:cash_flow/data/enum/status_cash_flow.dart";
import "package:cash_flow/data/model/cash_flow_model.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:intl/intl.dart";

class CashFlowView extends GetView<CashFlowController> {
  const CashFlowView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CCPageWithAppBar(
      title: const Text("Fluxo de caixa"),
      onPressedBackButton: Get.back,
      isSearch: false.obs,
      drawer: DrawerWidgetView(title: "Fluxo de caixa"),
      isScrollEnabled: false,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CCFloatingActionButtonExtend.primaryContainer(
            heroTag: "fbFiltrar",
            label: "Filtrar",
            icon: filterIcon,
            onPressed: () => showFilterModal(context),
          ),
          const SizedBox(width: 16),
          CCFloatingActionButton.primary(
            heroTag: "fbAdicionar",
            icon: addIcon,
            onPressed: () => controller.goToCashHandling(),
          ),
        ],
      ),
      body: [
        Expanded(
          flex: 0,
          child: CCCalendar(
            controller: controller.dateRangePickerController,
            startDate: controller.startDateConvert,
            endDate: controller.endDateConvert,
            isCalculatingCurrentBalance: controller.isCalculatingCurrentBalance,
            currentBalance: controller.currentBalance,
            isExpanded: controller.expansionChanged,
            onExpansionChanged: controller.onExpansionChanged,
            onSelectionChanged: controller.rangeOfSelectedDates,
            onSubmit: controller.onSubmitRangeDateButton,
          ),
        ),
        CCTextButtonIcon.primary(
          alignment: Alignment.centerRight,
          text: "Mais informações",
          icon: arrowRightIcon,
          onPressed: controller.goToCashFlowSummary,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 6, top: 16, right: 0, bottom: 8),
          child: Obx(
            () => RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  const TextSpan(text: "Saldo de "),
                  textSpanStyleBodyMedium(
                    context,
                    "${controller.typeFilter.value} ",
                  ),
                  const TextSpan(text: "entre "),
                  textSpanStyleBodyMedium(
                    context,
                    "${controller.startDateConvert} ",
                  ),
                  const TextSpan(text: "até "),
                  textSpanStyleBodyMedium(
                    context,
                    "${controller.endDateConvert}",
                  ),
                  const TextSpan(text: ": "),
                  TextSpan(
                    text: NumberFormat.simpleCurrency(locale: "pt-br").format(
                      controller.partialBalance.value,
                    ),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: controller.colorUtils
                              .isRedValue(controller.partialBalance.value),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Obx(
            () => Visibility(
              visible: controller.isLoading.value,
              replacement: const Center(child: CircularProgressIndicator()),
              child: controller.cashFlowList.isNotEmpty
                  ? ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        final CashFlowModel item =
                            controller.cashFlowList[index];
                        return item.type == "Receita"
                            ? CCExpandableListItemModel.income(
                                cashFlowItem: item,
                                deleteIconOnPressed:
                                    controller.deleteIconButtonPressed,
                                updateIconOnPressed:
                                    controller.updateIconButtonPressed,
                              )
                            : CCExpandableListItemModel.expense(
                                cashFlowItem: item,
                                deleteIconOnPressed:
                                    controller.deleteIconButtonPressed,
                                updateIconOnPressed:
                                    controller.updateIconButtonPressed,
                              );
                      },
                      itemCount: controller.cashFlowList.length,
                    )
                  : const CCResultNotFound(),
            ),
          ),
        )
      ],
    );
  }

  TextSpan textSpanStyleBodyMedium(BuildContext context, String text) {
    return TextSpan(
      text: text,
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(fontWeight: FontWeight.bold),
    );
  }

  void showFilterModal(BuildContext context) {
    showModalBottomSheet<void>(
      enableDrag: true,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Filtrar por",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Obx(
                () => RadioListTile(
                  title: const Text("Liquidado"),
                  value: StatusCashFlow.settled,
                  groupValue: controller.statusCashFlow.value,
                  onChanged: (value) {
                    controller.statusCashFlow(value! as StatusCashFlow);
                  },
                  dense: true,
                ),
              ),
              Obx(
                () => RadioListTile(
                  title: const Text("Não liquidado"),
                  value: StatusCashFlow.unsettled,
                  groupValue: controller.statusCashFlow.value,
                  onChanged: (value) {
                    controller.statusCashFlow(value! as StatusCashFlow);
                  },
                  dense: true,
                ),
              ),
              Obx(
                () => RadioListTile(
                  title: const Text("Todos"),
                  value: StatusCashFlow.all,
                  groupValue: controller.statusCashFlow.value,
                  onChanged: (value) {
                    controller.statusCashFlow(value! as StatusCashFlow);
                  },
                  dense: true,
                ),
              ),
              Text(
                "Categoria",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Obx(
                () => RadioListTile(
                  title: const Text("Receita"),
                  value: CashFlowMovementType.income,
                  groupValue: controller.categoryCashFlow.value,
                  onChanged: (value) {
                    controller.categoryCashFlow(value! as CashFlowMovementType);
                  },
                  dense: true,
                ),
              ),
              Obx(
                () => RadioListTile(
                  title: const Text("Despesa"),
                  value: CashFlowMovementType.expense,
                  groupValue: controller.categoryCashFlow.value,
                  onChanged: (value) {
                    controller.categoryCashFlow(value! as CashFlowMovementType);
                  },
                  dense: true,
                ),
              ),
              Obx(
                () => RadioListTile(
                  title: const Text("Todos"),
                  value: CashFlowMovementType.all,
                  groupValue: controller.categoryCashFlow.value,
                  onChanged: (value) {
                    controller.categoryCashFlow(value! as CashFlowMovementType);
                  },
                  dense: true,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 0,
                    child: CCTextButton.neutral(
                      text: "Cancelar".toUpperCase(),
                      onPressed: Get.back,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 0,
                    child: CCTextButton.primary(
                      text: "Filtrar".toUpperCase(),
                      onPressed: () {
                        Get.back();
                        controller.useFilter();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
