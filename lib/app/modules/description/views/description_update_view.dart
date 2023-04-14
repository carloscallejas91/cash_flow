import "package:cash_flow/app/modules/description/controllers/description_update_controller.dart";
import "package:cash_flow/app/widgets/button/cc_button.dart";
import "package:cash_flow/app/widgets/button/cc_icon_button.dart";
import "package:cash_flow/app/widgets/card/cc_card.dart";
import "package:cash_flow/app/widgets/dropdown/complement/cc_category_dropdown.dart";
import "package:cash_flow/app/widgets/expansion_tile/cc_expansion_tile.dart";
import "package:cash_flow/app/widgets/templates/cc_page_with_app_bar.dart";
import "package:cash_flow/core/values/colors.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class DescriptionUpdateView extends GetView<DescriptionUpdateController> {
  const DescriptionUpdateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CCPageWithAppBar(
      title: const Text("Alterar"),
      isSearch: false.obs,
      isScrollEnabled: false,
      onPressedBackButton: controller.goToDescription,
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
                      "Use os campos abaixo para editar a descrição selecionada.",
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
                      textButton: "Atualizar",
                      onPressed: controller.validateForm,
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
