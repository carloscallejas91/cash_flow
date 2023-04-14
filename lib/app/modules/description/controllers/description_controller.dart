import "package:cash_flow/app/widgets/dialog/cc_dialog.dart";
import "package:cash_flow/core/utils/validate_entry_utils.dart";
import "package:cash_flow/data/model/category_model.dart";
import "package:cash_flow/data/model/description_model.dart";
import "package:cash_flow/data/services/category_services.dart";
import "package:cash_flow/data/services/description_services.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class DescriptionController extends GetxController {
  // Keys
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Utils
  final ValidateEntryUtils validateEntry = ValidateEntryUtils();

  // Widget
  final CCDialog dialog = CCDialog();

  // Controller
  final TextEditingController searchController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // List
  RxList<CategoryModel> listCategories = <CategoryModel>[].obs;
  RxList<DescriptionModel> listDescriptions = <DescriptionModel>[].obs;
  RxList<DescriptionModel> filteredItems = <DescriptionModel>[].obs;

  // Model
  Rx<CategoryModel> selectedCategory =
      CategoryModel(category: "", type: "").obs;

  // Conditionals
  RxBool categoryLoaded = false.obs;
  RxBool isSearch = false.obs;
  RxBool expansionChanged = true.obs;

  // Variables
  final FocusNode focusNode = FocusNode();

  @override
  void onInit() {
    getCategoryByName("");
    super.onInit();
  }

  Future<List<CategoryModel>> getCategoryByName(String category) async {
    categoryLoaded.value = false;
    final CategoryServices categoryServices = CategoryServices();

    await categoryServices.getCategoryByName(category).then((value) {
      listCategories.value = value;
      selectedCategory.value = listCategories.first;
      getDescriptionByCategoryId(selectedCategory.value.id!);
    }).whenComplete(() => categoryLoaded.value = true);
    return listCategories;
  }

  Future<void> addNewCategory(
    String type,
    String name,
  ) async {
    Get.back();
    dialog.loadingWithText(message: "Salvando categoria...");
    final CategoryModel category = CategoryModel(
      type: type,
      category: name,
    );

    final CategoryServices categoryServices = CategoryServices();

    await categoryServices.addCategory(category).then((value) {
      if (value > -1) {
        Get.back();
        dialog.dialogPositiveButton(
          title: "Sucesso",
          contentText: "Uma nova categoria foi adicionada.",
          onPressedPositiveButton: () {
            Get.back();
            getCategoryByName("");
          },
        );
      } else {
        Get.back();
        dialog.dialogPositiveButton(
          title: "Falhou",
          contentText:
              "Houve um erro ao tentar adicionar uma nova categoria. Por favor tente novamente.",
          onPressedPositiveButton: () {
            Get.back();
          },
        );
      }
    });
  }

  void changedCategory(CategoryModel category) {
    selectedCategory.value = category;
    getDescriptionByCategoryId(selectedCategory.value.id!);
  }

  Future<void> getDescriptionByCategoryId(int categoryId) async {
    categoryLoaded.value = false;
    final DescriptionServices descriptionServices = DescriptionServices();

    await descriptionServices
        .getDescriptionByCategoryId(categoryId)
        .then((value) {
      listDescriptions.value = value;
      equalizeLists();
    }).whenComplete(() => categoryLoaded.value = true);
  }

  void validateForm() {
    if (formKey.currentState!.validate()) {
      addNewDescription();
    }
  }

  void filterList(String searchQuery) {
    filteredItems.clear();
    for (final item in listDescriptions) {
      if (item.description.toLowerCase().contains(searchQuery.toLowerCase())) {
        filteredItems.add(item);
      }
    }
  }

  void equalizeLists() {
    filteredItems.clear();
    filteredItems.addAll(listDescriptions);
  }

  Future<void> addNewDescription() async {
    dialog.loadingWithText(message: "Adicionando nova descrição...");
    final DescriptionModel description = DescriptionModel(
      description: descriptionController.text,
      categoryId: selectedCategory.value.id!,
    );

    final DescriptionServices categoryServices = DescriptionServices();

    await categoryServices.addDescription(description).then((value) {
      if (value > -1) {
        Get.back();
        dialog.dialogPositiveButton(
          title: "Sucesso",
          contentText:
              "Uma nova descrição foi adicionada e está vinculada com a categoria ${selectedCategory.value.category}.",
          onPressedPositiveButton: () {
            cleanField();
            Get.back();
            getDescriptionByCategoryId(selectedCategory.value.id!);
          },
        );
      } else {
        Get.back();
        dialog.dialogPositiveButton(
          title: "Falhou",
          contentText:
              "Houve um erro ao tentar adicionar uma nova descrição. Por favor tente novamente.",
          onPressedPositiveButton: () {
            Get.back();
          },
        );
      }
    });
  }

  void searchChanged() {
    isSearch.value = !isSearch.value;
    expansionChanged.value = !isSearch.value;
    focusNode.requestFocus();
  }

  void onExpansionChanged(bool value) {
    if (isSearch.isTrue) {
      isSearch.value = !isSearch.value;
    }
    expansionChanged.value = value;
  }

  void cleanField() {
    descriptionController.text = "";
  }

  void goToDescriptionUpdate(DescriptionModel description){
    Get.toNamed("/description_update", arguments: description);
  }
}
