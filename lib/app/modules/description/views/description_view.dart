import "package:cash_flow/app/modules/description/controllers/description_controller.dart";
import "package:cash_flow/app/modules/drawer/views/drawer_widget_view.dart";
import "package:cash_flow/app/widgets/button/cc_button.dart";
import "package:cash_flow/app/widgets/card/cc_card.dart";
import "package:cash_flow/app/widgets/dropdown/complement/cc_category_dropdown.dart";
import "package:cash_flow/app/widgets/expansion_tile/cc_expansion_tile.dart";
import "package:cash_flow/app/widgets/input/cc_search_field.dart";
import "package:cash_flow/app/widgets/model/cc_single_list_item_model.dart";
import "package:cash_flow/app/widgets/replacement/cc_result_not_found.dart";
import "package:cash_flow/app/widgets/templates/cc_page_with_app_bar.dart";
import "package:cash_flow/core/values/colors.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class DescriptionView extends GetView<DescriptionController> {
  const DescriptionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CCPageWithAppBar(
      title: const Text("Descrições"),
      isSearch: controller.isSearch,
      isScrollEnabled: false,
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
        title: "Descrições",
      ),
      body: [
        Expanded(
          flex: 0,
          child: CCCard.surface(
            widgets: [
              Obx(
                () => CCExpansionTile(
                  globalKey: GlobalKey(),
                  title: "Toda descrição deve estar associada a uma categoria.",
                  initiallyExpanded: controller.expansionChanged.value,
                  onExpansionChanged: controller.onExpansionChanged,
                  widgets: [
                    Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: controller.descriptionController,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.start,
                            decoration: const InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              label: Text("Descrição"),
                              icon: Icon(descriptionIcon),
                              iconColor: primary,
                            ),
                            validator: (value) => controller.validateEntry
                                .validateIsEmpty(value!),
                          ),
                          const SizedBox(height: 16),
                          CCCategoryDropdown(
                            categoryLoaded: controller.categoryLoaded,
                            selectedCategory: controller.selectedCategory,
                            typeOfMovement: "",
                            getCategoryByType: controller.getCategoryByName,
                            changedCategory: controller.changedCategory,
                            addNewCategory: controller.addNewCategory,
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text(
            "Resultado:",
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
              child: controller.filteredItems.isNotEmpty
                  ? ListView.builder(
                      itemCount: controller.filteredItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = controller.filteredItems[index];
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
