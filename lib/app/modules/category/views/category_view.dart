import "package:cash_flow/app/modules/category/controllers/category_controller.dart";
import "package:cash_flow/app/modules/drawer/views/drawer_widget_view.dart";
import "package:cash_flow/app/widgets/button/cc_button.dart";
import "package:cash_flow/app/widgets/card/cc_card.dart";
import "package:cash_flow/app/widgets/expansion_tile/cc_expansion_tile.dart";
import "package:cash_flow/app/widgets/input/cc_search_field.dart";
import "package:cash_flow/app/widgets/model/cc_single_list_item_model.dart";
import "package:cash_flow/app/widgets/replacement/cc_result_not_found.dart";
import "package:cash_flow/app/widgets/templates/cc_page_with_app_bar.dart";
import "package:cash_flow/core/values/colors.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:cash_flow/data/enum/cash_flow_movement_type.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class CategoryView extends GetView<CategoryController> {
  const CategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CCPageWithAppBar(
      title: const Text("Categorias"),
      isScrollEnabled: false,
      isSearch: controller.isSearch,
      searchWidget: SizedBox(
        height: 50,
        child: CCSearchField(
          focusNode: controller.focusNode,
          onChanged: controller.filterList,
        ),
      ),
      actions: [
        Obx(
          () => IconButton(
            onPressed: () {
              controller.searchChanged();
              controller.equalizeLists();
            },
            icon: Icon(
              controller.isSearch.value ? closeIcon : searchIcon,
              size: 24,
            ),
          ),
        ),
      ],
      drawer: DrawerWidgetView(
        title: "Categorias",
      ),
      body: [
        Expanded(
          flex: 0,
          child: CCCard.surface(
            widgets: [
              Obx(
                () => CCExpansionTile(
                  globalKey: GlobalKey(),
                  title:
                      "Insira o nome da categoria e o tipo em que está categoria se encaixa.",
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
                              groupValue: controller.categoryCashFlow.value,
                              onChanged: (value) {
                                controller.categoryCashFlow(
                                    value! as CashFlowMovementType);
                                controller.getTypeSelected();
                              },
                              dense: true,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              title: const Text("Despesa"),
                              value: CashFlowMovementType.expense,
                              groupValue: controller.categoryCashFlow.value,
                              onChanged: (value) {
                                controller.categoryCashFlow(
                                    value! as CashFlowMovementType);
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
                      textButton: "Adicionar",
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
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          child: Text(
            "Categorias:",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Expanded(
          flex: 1,
          child: Obx(
            () => Visibility(
              visible: controller.isLoading.value,
              replacement: const Center(child: CircularProgressIndicator()),
              child: controller.filteredItems.isNotEmpty
                  ? ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        final item = controller.filteredItems[index];
                        return item.type == "Receita"
                            ? CCSingleListItemModel.success(
                                context: context,
                                title: item.category,
                                subtitle: item.type,
                                onTap: () {
                                  controller.getToCategoryUpdate(
                                    item,
                                  );
                                },
                              )
                            : CCSingleListItemModel.error(
                                context: context,
                                title: item.category,
                                subtitle: item.type,
                                onTap: () {
                                  controller.getToCategoryUpdate(
                                    item,
                                  );
                                },
                              );
                      },
                      itemCount: controller.filteredItems.length,
                    )
                  : const CCResultNotFound(),
            ),
          ),
        ),
      ],
    );
  }
}
