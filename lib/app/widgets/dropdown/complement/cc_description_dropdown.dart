import "package:cash_flow/app/widgets/button/cc_button.dart";
import "package:cash_flow/core/values/colors.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:cash_flow/data/model/category_model.dart";
import "package:cash_flow/data/model/description_model.dart";
import "package:dropdown_search2/dropdown_search2.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class CCDescriptionDropdown extends StatelessWidget {
  final RxBool descriptionLoaded;
  final Rx<DescriptionModel> selectedDescription;
  final Future<List<DescriptionModel>> Function(int) getDescriptionByCategoryId;
  final Function(DescriptionModel) changedDescription;
  final Function addNewDescription;
  final Rx<CategoryModel> selectedCategory;

  const CCDescriptionDropdown({
    Key? key,
    required this.descriptionLoaded,
    required this.selectedDescription,
    required this.getDescriptionByCategoryId,
    required this.changedDescription,
    required this.addNewDescription,
    required this.selectedCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DropdownSearch<DescriptionModel>(
        showSearchBox: true,
        mode: Mode.BOTTOM_SHEET,
        enabled: descriptionLoaded.value == true &&
            selectedCategory.value.category.isNotEmpty,
        selectedItem: descriptionLoaded.isTrue
            ? selectedDescription.value
            : DescriptionModel(
                description: "",
                categoryId: -1,
              ),
        itemAsString: (item) => item!.description,
        filterFn: (item, filter) =>
            item!.description.toLowerCase().contains(filter!.toLowerCase()),
        onFind: (String? filter) =>
            getDescriptionByCategoryId(selectedCategory.value.id!),
        validator: (value) =>
            value!.description.isEmpty ? "Escolha uma descrição." : null,
        onChanged: (value) {
          changedDescription(value!);
        },
        dropdownBuilder: (context, selectedItem) => descriptionSelectedItem(
          context: context,
          item: selectedItem,
        ),
        popupItemBuilder: (context, item, isSelected) =>
            descriptionPopupItemBuilder(
          context: context,
          item: item,
          isSelected: isSelected,
        ),
        dropdownSearchDecoration: const InputDecoration(
          label: Text("Descrição"),
          iconColor: primary,
          icon: Icon(descriptionIcon),
        ),
        searchFieldProps: TextFieldProps(
          decoration: const InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
            prefixIcon: Icon(searchIcon),
          ),
        ),
        emptyBuilder: (context, searchEntry) => Visibility(
          visible: searchEntry!.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        const TextSpan(
                          text: "Resultado não encontrado! Deseja adicionar ",
                        ),
                        textSpanStyleBodyMedium(
                          context,
                          "$searchEntry ",
                        ),
                        const TextSpan(
                          text: "em sua lista?",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  CCButton.primaryContainer(
                    textButton: "Adicionar",
                    onPressed: () => addNewDescription(
                      searchEntry,
                      selectedCategory.value.id,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
