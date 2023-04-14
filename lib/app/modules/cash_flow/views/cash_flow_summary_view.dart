import "package:cash_flow/app/modules/cash_flow/controllers/cash_flow_summary_controller.dart";
import "package:cash_flow/app/widgets/card/cc_card.dart";
import "package:cash_flow/app/widgets/dropdown/cc_dropdown_with_search.dart";
import "package:cash_flow/app/widgets/expansion_tile/cc_expansion_tile.dart";
import "package:cash_flow/app/widgets/page_indicator/cc_page_indicator.dart";
import "package:cash_flow/app/widgets/templates/cc_page_with_app_bar.dart";
import "package:cash_flow/core/values/colors.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:intl/intl.dart";

class CashFlowSummaryView extends GetView<CashFlowSummaryController> {
  const CashFlowSummaryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CCPageWithAppBar(
      title: const Text("Resumo"),
      isSearch: false.obs,
      isScrollEnabled: false,
      onPressedBackButton: Get.back,
      body: [
        const SizedBox(height: 8),
        CCCard.surface(
          widgets: [
            CCDropdownWithSearch(
              label: "Selecione o ano de busca",
              icon: calendarIcon,
              messageNotFound: "Ano não encontrado.",
              onChanged: controller.changedFilterYear,
              selectedItem: "2023",
              items: const [
                "2018",
                "2019",
                "2020",
                "2021",
                "2022",
                "2023",
                "2024",
                "2025",
                "2026"
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(
          () => Visibility(
            visible: true,
            replacement: const CircularProgressIndicator(),
            child: Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildCard(
                      index: 0,
                      title: "Janeiro",
                      onExpansionChanged: controller.onExpansionChangedJanuary,
                    ),
                    buildCard(
                      index: 1,
                      title: "Fevereiro",
                      onExpansionChanged: controller.onExpansionChangedFebruary,
                    ),
                    buildCard(
                      index: 2,
                      title: "Março",
                      onExpansionChanged: controller.onExpansionChangedMarch,
                    ),
                    buildCard(
                      index: 3,
                      title: "Abril",
                      onExpansionChanged: controller.onExpansionChangedApril,
                    ),
                    buildCard(
                      index: 4,
                      title: "Maio",
                      onExpansionChanged: controller.onExpansionChangedMay,
                    ),
                    buildCard(
                      index: 5,
                      title: "Junho",
                      onExpansionChanged: controller.onExpansionChangedJune,
                    ),
                    buildCard(
                      index: 6,
                      title: "Julho",
                      onExpansionChanged: controller.onExpansionChangedJuly,
                    ),
                    buildCard(
                      index: 7,
                      title: "Agosto",
                      onExpansionChanged: controller.onExpansionChangedAugust,
                    ),
                    buildCard(
                      index: 8,
                      title: "Setembro",
                      onExpansionChanged:
                          controller.onExpansionChangedSeptember,
                    ),
                    buildCard(
                      index: 9,
                      title: "Outubro",
                      onExpansionChanged: controller.onExpansionChangedOctober,
                    ),
                    buildCard(
                      index: 10,
                      title: "November",
                      onExpansionChanged: controller.onExpansionChangedNovember,
                    ),
                    buildCard(
                      index: 11,
                      title: "Dezembro",
                      onExpansionChanged: controller.onExpansionChangedDecember,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        CCCard.surface(
          widgets: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Saldo total do ano:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => Text(
                    NumberFormat.simpleCurrency(locale: "pt-br").format(
                      controller.generalBalanceYear.value,
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: controller.colorUtils
                          .isRedValue(controller.generalBalanceYear.value),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Saldo total geral:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => Text(
                    NumberFormat.simpleCurrency(locale: "pt-br").format(
                      controller.generalBalance.value,
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: controller.colorUtils
                          .isRedValue(controller.generalBalance.value),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  CCCard buildCard({
    required int index,
    required String title,
    required Function onExpansionChanged,
  }) {
    return CCCard.secondaryContainer(
      widgets: [
        CCExpansionTile(
          globalKey: GlobalKey(),
          title: title,
          initiallyExpanded:
              index == controller.currentIndexExpansionTile.value,
          onExpansionChanged: onExpansionChanged,
          widgets: [
            SizedBox(
              height: 250,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: PageView(
                      controller: controller.pageController,
                      onPageChanged: (int index) {
                        controller.currentPage.value = index;
                      },
                      children: <Widget>[
                        pageIncome(),
                        pageExpense(),
                        pageDetail(),
                      ],
                    ),
                  ),
                  Obx(
                    () => CCPageIndicator(
                      pageLenght: 3,
                      currentPage: controller.currentPage.value,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget pageIncome() {
    return Column(
      children: [
        detailedLine(
          "Receitas liquidadas",
          controller.settledIncome.value,
          surfaceVariant,
        ),
        detailedLine(
          "Receitas não liquidadas",
          controller.unsettledIncome.value,
          surface,
        ),
        detailedLine(
          "total",
          controller.settledUnsettledIncome.value,
          successContainer,
        ),
      ],
    );
  }

  Widget pageExpense() {
    return Column(
      children: [
        detailedLine(
          "Despesas liquidadas",
          controller.expenseSettled.value,
          surfaceVariant,
        ),
        detailedLine(
          "Despesas não liquidadas",
          controller.unpaidExpense.value,
          surface,
        ),
        detailedLine(
          "total",
          controller.paidUnpaidExpense.value,
          errorContainer,
        ),
      ],
    );
  }

  Widget pageDetail() {
    return Column(
      children: [
        detailedLine(
          "Receitas e despesas liquidadas",
          controller.netIncomeExpense.value,
          surfaceVariant,
        ),
        detailedLine(
          "Receitas e despesas não liquidadas",
          controller.unpaidIncomeExpense.value,
          surface,
        ),
        detailedLine(
          "Saldo do mês",
          controller.balanceMonth.value,
          controller.balanceMonth.value < 0
              ? errorContainer
              : successContainer,
        ),
      ],
    );
  }

  Widget detailedLine(
    String label,
    double value,
    Color background,
  ) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 70,
      ),
      padding: const EdgeInsets.all(8),
      color: background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
            ),
          ),
          const SizedBox(width: 32),
          Text(
            NumberFormat.simpleCurrency(locale: "pt-br").format(
              value,
            ),
          ),
        ],
      ),
    );
  }
}
