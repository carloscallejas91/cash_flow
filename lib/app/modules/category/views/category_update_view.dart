import "package:cash_flow/app/modules/category/controllers/category_update_controller.dart";
import "package:cash_flow/app/widgets/button/cc_button.dart";
import "package:cash_flow/app/widgets/button/cc_icon_button.dart";
import "package:cash_flow/app/widgets/card/cc_card.dart";
import "package:cash_flow/app/widgets/expansion_tile/cc_expansion_tile.dart";
import "package:cash_flow/app/widgets/model/cc_single_list_item_model.dart";
import "package:cash_flow/app/widgets/replacement/cc_result_not_found.dart";
import "package:cash_flow/app/widgets/templates/cc_page_with_app_bar.dart";
import "package:cash_flow/core/values/colors.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:cash_flow/data/enum/cash_flow_movement_type.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class CategoryUpdateView extends GetView<CategoryUpdateController> {
  const CategoryUpdateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CCPageWithAppBar(
      title: const Text("Atualizar"),
      isScrollEnabled: false,
      isSearch: false.obs,
      onPressedBackButton: controller.goToCategory,
      actions: [
        CCIconButton.error(
          icon: trashIcon,
          iconSize: 20,
          onPressed: controller.deleteButton,
        ),
      ],
      body: [
        Expanded(
          flex: 0,
          child: CCCard.surface(
            widgets: [
              Obx(
                () => CCExpansionTile(
                  globalKey: GlobalKey(),
                  title:
                      "Use os campos abaixo para editar nome da categoria ou o tipo de movimentação da categoria selecionada.",
                  initiallyExpanded: controller.expansionChanged.value,
                  onExpansionChanged: controller.onExpansionChanged,
                  widgets: [
                    Form(
                      key: controller.formKey,
                      child: TextFormField(
                        controller: controller.categoryController,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: Text("Categoria"),
                          icon: Icon(categoryIcon),
                          iconColor: primary,
                        ),
                        validator: (value) =>
                            controller.validateEntry.validateIsEmpty(value!),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Tipo de movimentação:",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              title: const Text("Receita"),
                              value: CashFlowMovementType.income,
                              groupValue: controller.cashFlowMovementType.value,
                              onChanged: (value) {
                                controller.cashFlowMovementType(value! as CashFlowMovementType);
                                controller.getTypeSelected();
                              },
                              dense: true,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              title: const Text("Despesa"),
                              value: CashFlowMovementType.expense,
                              groupValue: controller.cashFlowMovementType.value,
                              onChanged: (value) {
                                controller.cashFlowMovementType(value! as CashFlowMovementType);
                                controller.getTypeSelected();
                              },
                              dense: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    CCButton.primary(
                      textButton: "Atualizar categoria",
                      onPressed: controller.validateForm,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text(
            "Descrições vinculadas a este item:",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Expanded(
          flex: 1,
          child: Obx(
            () => Visibility(
              visible: controller.categoryLoaded.value,
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
              child: controller.listDescriptions.isNotEmpty
                  ? ListView.builder(
                      itemCount: controller.listDescriptions.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = controller.listDescriptions[index];
                        return CCSingleListItemModel.secondaryContainer(
                          context: context,
                          title: item.description,
                          trailingIcon: chevronRightIcon,
                          onTap: () {
                            controller.goToDescriptionUpdate(item);
                          },
                        );
                      },
                    )
                  : const CCResultNotFound(),
            ),
          ),
        ),
      ],
    );
  }
}
