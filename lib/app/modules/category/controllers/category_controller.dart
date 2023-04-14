import "package:cash_flow/app/widgets/dialog/cc_dialog.dart";
import "package:cash_flow/core/utils/validate_entry_utils.dart";
import "package:cash_flow/data/enum/cash_flow_movement_type.dart";
import "package:cash_flow/data/model/category_model.dart";
import "package:cash_flow/data/services/category_services.dart";
import "package:flutter/cupertino.dart";
import "package:get/get.dart";

class CategoryController extends GetxController {
  // Keys
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Enum
  Rx<CashFlowMovementType> categoryCashFlow = CashFlowMovementType.income.obs;

  // Utils
  final ValidateEntryUtils validateEntry = ValidateEntryUtils();

  // imported widget
  final CCDialog dialog = CCDialog();

  // Controller
  final TextEditingController searchController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  // List
  RxList<CategoryModel> listCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> filteredItems = <CategoryModel>[].obs;

  // Conditionals
  RxBool isLoading = false.obs;
  RxBool isSearch = false.obs;
  RxBool expansionChanged = true.obs;

  // Variables
  String selectedTypeMovement = "Receita";
  final FocusNode focusNode = FocusNode();

  @override
  void onInit() {
    getAllCategory();
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    categoryController.dispose();
    super.onClose();
  }

  Future<void> getAllCategory() async {
    isLoading.value = false;
    final CategoryServices categoryServices = CategoryServices();

    await categoryServices.getCategoryByType("").then((value) {
      listCategories.value = value;
      equalizeLists();
    }).whenComplete(() => isLoading.value = true);
  }

  void filterList(String searchQuery) {
    filteredItems.clear();
    for (final item in listCategories) {
      if (item.category.toLowerCase().contains(searchQuery.toLowerCase())) {
        filteredItems.add(item);
      }
    }
  }

  void equalizeLists() {
    filteredItems.clear();
    filteredItems.addAll(listCategories);
  }

  void getTypeSelected() {
    if (categoryCashFlow.value == CashFlowMovementType.income) {
      selectedTypeMovement = "Receita";
    } else {
      selectedTypeMovement = "Despesa";
    }
  }

  void validateForm() {
    if (formKey.currentState!.validate()) {
      addNewCategory();
    }
  }

  Future<void> addNewCategory() async {
    dialog.loadingWithText(message: "Adicionando uma nova categoria...");
    final CategoryModel category = CategoryModel(
      type: selectedTypeMovement,
      category: categoryController.text,
    );

    final CategoryServices categoryServices = CategoryServices();
    await categoryServices.addCategory(category).then((value) {
      if (value > -1) {
        cleanField();
        Get.back();
        dialog.dialogPositiveButton(
          title: "Sucesso",
          contentText: "Uma nova categoria foi adicionada.",
          onPressedPositiveButton: () {
            Get.back();
            getAllCategory();
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
    categoryController.text = "";
    categoryCashFlow.value = CashFlowMovementType.income;
  }

  void getToCategoryUpdate(CategoryModel category) {
    Get.toNamed("/category_update", arguments: category);
  }
}
