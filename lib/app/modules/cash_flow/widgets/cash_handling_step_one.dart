import "package:cash_flow/app/modules/cash_flow/controllers/cash_flow_handling_controller.dart";
import "package:cash_flow/app/widgets/dropdown/cc_dropdown_with_search.dart";
import "package:cash_flow/app/widgets/dropdown/complement/cc_category_dropdown.dart";
import "package:cash_flow/app/widgets/dropdown/complement/cc_description_dropdown.dart";
import "package:cash_flow/app/widgets/model/cc_custom_income_expense_dropdown_container.dart";
import "package:cash_flow/core/values/colors.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:cash_flow/data/model/category_model.dart";
import "package:cash_flow/data/model/description_model.dart";
import "package:currency_text_input_formatter/currency_text_input_formatter.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class CashHandlingStepOne extends GetView<CashFlowHandlingController> {
  const CashHandlingStepOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: controller.stepOneFormKey,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Text(
                    "Tipo de movimentação:",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                Flexible(
                  flex: 0,
                  child: CCCustomIncomeExpenseDropdownContainer(
                    dropdownValue: controller.typeMovement,
                    list: const ["Despesa", "Receita"],
                    onChanged: controller.getCategoryByType,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(
              () => CCCategoryDropdown(
                categoryLoaded: controller.categoryLoaded,
                selectedCategory: controller.selectedCategory,
                typeOfMovement: controller.typeMovement.value,
                getCategoryByType: controller.getCategoryByType,
                changedCategory: controller.changedCategory,
                addNewCategory: controller.addNewCategory,
              ),
            ),
            const SizedBox(height: 16),
            CCDescriptionDropdown(
              descriptionLoaded: controller.descriptionLoaded,
              selectedDescription: controller.selectedDescription,
              getDescriptionByCategoryId:
              controller.getDescriptionByCategoryId,
              changedDescription: controller.changedDescription,
              addNewDescription: controller.addNewDescription,
              selectedCategory: controller.selectedCategory,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.valueController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.end,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                CurrencyTextInputFormatter(
                  locale: "pt-BR",
                  symbol: "R\$",
                ),
              ],
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                label: const Text("Valor"),
                icon: const Icon(coinsIcon),
                iconColor: primary,
                hintText: "R\$ 105,67",
                hintStyle: TextStyle(color: neutral),
              ),
              validator: (value) =>
                  controller.validateEntryUtils.validatePositiveValue(value!),
            ),
            const SizedBox(height: 16),
            Obx(
              () => CCDropdownWithSearch(
                label: "Método de pagamento",
                icon: typeOfPaymentIcon,
                messageNotFound: "Método de pagamento não encontrado!",
                onChanged: controller.changedTypePayment,
                selectedItem: controller.selectedTypePayment.value,
                items: const [
                  "Outro",
                  "Boleto",
                  "Cartão de crédito",
                  "Cartão de débito",
                  "Cheque",
                  "Crediário",
                  "Criptomoedas",
                  "Dinheiro em espécie",
                  "Link de pagamento",
                  "Pagamento recorrente",
                  "PIX",
                  "Transferência bancária",
                  "Vales",
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.dueDateController,
              readOnly: true,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                label: const Text("Data de vencimento"),
                icon: const Icon(
                  dueDateIcon,
                ),
                iconColor: primary,
                suffixIcon: IconButton(
                  icon: const Icon(
                    calendarIcon,
                  ),
                  onPressed: () => controller.dueDateDialog(context),
                ),
              ),
              validator: (value) =>
                  controller.validateEntryUtils.validateIsEmpty(value!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.observationController,
              maxLines: 2,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                label: const Text("Observação"),
                icon: const Icon(observationIcon),
                iconColor: primary,
                hintText: "Use este espaço para anotações.",
                hintStyle: TextStyle(color: neutral),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categorySelectedItem({
    required BuildContext context,
    required CategoryModel? item,
  }) {
    if (item == null) {
      return const Text("");
    }
    return Text(item.category);
  }

  Widget categoryPopupItemBuilder({
    required BuildContext context,
    required CategoryModel? item,
    required bool isSelected,
  }) {
    return ListTile(
      selected: isSelected,
      title: Text(item!.category),
      subtitle: Text(item.type),
    );
  }

  Widget descriptionSelectedItem({
    required BuildContext context,
    required DescriptionModel? item,
  }) {
    if (item == null) {
      return const Text("");
    }
    return Text(item.description);
  }

  Widget descriptionPopupItemBuilder({
    required BuildContext context,
    required DescriptionModel? item,
    required bool isSelected,
  }) {
    return ListTile(
      selected: isSelected,
      title: Text(item!.description),
      subtitle: Text("${item.categoryId}"),
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
}
