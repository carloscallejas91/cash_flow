import "package:cash_flow/app/widgets/button/cc_button.dart";
import "package:cash_flow/core/values/colors.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:cash_flow/data/model/category_model.dart";
import "package:dropdown_search2/dropdown_search2.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class CCCategoryDropdown extends StatelessWidget {
  final RxBool categoryLoaded;
  final Rx<CategoryModel> selectedCategory;
  final String typeOfMovement;
  final Future<List<CategoryModel>> Function(String) getCategoryByType;
  final Function(CategoryModel) changedCategory;
  final Function addNewCategory;

  const CCCategoryDropdown({
    Key? key,
    required this.categoryLoaded,
    required this.selectedCategory,
    required this.typeOfMovement,
    required this.getCategoryByType,
    required this.changedCategory,
    required this.addNewCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DropdownSearch<CategoryModel>(
        showSearchBox: true,
        mode: Mode.BOTTOM_SHEET,
        enabled: categoryLoaded.value == true,
        selectedItem: categoryLoaded.value == true
            ? selectedCategory.value
            : CategoryModel(
                category: "",
                type: "",
              ),
        itemAsString: (item) => item!.category,
        filterFn: (item, filter) =>
            item!.category.toLowerCase().contains(filter!.toLowerCase()),
        onFind: (String? filter) => getCategoryByType(typeOfMovement),
        validator: (value) =>
            value!.category.isEmpty ? "Escolha uma categoria." : null,
        onChanged: (value) {
          changedCategory(value!);
        },
        dropdownBuilder: (context, selectedItem) => categorySelectedItem(
          context: context,
          item: selectedItem,
        ),
        popupItemBuilder: (context, item, isSelected) =>
            categoryPopupItemBuilder(
          context: context,
          item: item,
          isSelected: isSelected,
        ),
        dropdownSearchDecoration: const InputDecoration(
          label: Text("Categoria"),
          iconColor: primary,
          icon: Icon(categoryIcon),
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
                          text: "em sua lista de categorias?",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  CCButton.primaryContainer(
                    textButton: "Adicionar",
                    onPressed: () =>
                        addNewCategory(typeOfMovement, searchEntry),
                  ),
                ],
              ),
            ),
          ),
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
