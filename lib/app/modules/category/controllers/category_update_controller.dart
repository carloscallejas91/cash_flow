import "package:cash_flow/app/widgets/dialog/cc_dialog.dart";
import "package:cash_flow/core/utils/validate_entry_utils.dart";
import "package:cash_flow/core/values/colors.dart";
import "package:cash_flow/data/enum/cash_flow_movement_type.dart";
import "package:cash_flow/data/model/category_model.dart";
import "package:cash_flow/data/model/description_model.dart";
import "package:cash_flow/data/services/category_services.dart";
import "package:cash_flow/data/services/description_services.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class CategoryUpdateController extends GetxController {
  // Keys
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Enum
  Rx<CashFlowMovementType> cashFlowMovementType = CashFlowMovementType.none.obs;

  // Model
  CategoryModel category = CategoryModel(
    category: "",
    type: "",
  );
  CategoryModel categoryUpdated = CategoryModel(
    category: "",
    type: "",
  );

  // Utils
  final ValidateEntryUtils validateEntry = ValidateEntryUtils();

  // Widgets
  final CCDialog dialog = CCDialog();

  // Controllers
  final TextEditingController categoryController = TextEditingController();

  // List
  RxList<DescriptionModel> listDescriptions = <DescriptionModel>[].obs;

  // Conditionals
  RxBool expansionChanged = true.obs;
  RxBool categoryLoaded = false.obs;

  // Variables
  late String selectedTypeMovement;

  @override
  void onInit() {
    getArguments();
    initializeVariables();
    getDescriptionByCategoryId(category.id!);
    super.onInit();
  }

  void getArguments() {
    category = Get.arguments as CategoryModel;
  }

  void initializeVariables() {
    categoryController.text = category.category;
    if (category.type == "Receita") {
      cashFlowMovementType.value = CashFlowMovementType.income;
      selectedTypeMovement = "Receita";
    } else {
      cashFlowMovementType.value = CashFlowMovementType.expense;
      selectedTypeMovement = "Despesa";
    }
  }

  void onExpansionChanged(bool value) {
    expansionChanged.value = value;
  }

  void getTypeSelected() {
    if (cashFlowMovementType.value == CashFlowMovementType.income) {
      selectedTypeMovement = "Receita";
    } else {
      selectedTypeMovement = "Despesa";
    }
  }

  void validateForm() {
    if (formKey.currentState!.validate()) {
      updateButton();
    }
  }

  Future<void> getDescriptionByCategoryId(int categoryId) async {
    categoryLoaded.value = false;
    final DescriptionServices descriptionServices = DescriptionServices();

    await descriptionServices
        .getDescriptionByCategoryId(categoryId)
        .then((value) {
      listDescriptions.value = value;
    }).whenComplete(() => categoryLoaded.value = true);
  }

  Future<void> updateCategory() async {
    createCategoryRequest();

    final CategoryServices categoryServices = CategoryServices();

    dialog.loadingWithText(message: "Alterando categoria...");
    await categoryServices
        .updateCategory(categoryUpdated, category.id!)
        .then((value) {
      Get.back();
      if (value == 1) {
        dialog.dialogPositiveButton(
          title: "Sucesso",
          contentText: "Categoria atualizada com sucesso!",
          onPressedPositiveButton: Get.back,
        );
      } else {
        dialog.dialogPositiveButton(
          title: "Falhou",
          contentText: "Houve um erro ao tentar atualizar a categoria!",
          onPressedPositiveButton: Get.back,
        );
      }
    });
  }

  void createCategoryRequest() {
    categoryUpdated = CategoryModel(
      id: category.id,
      category: categoryController.text,
      type: selectedTypeMovement,
    );
  }

  Future<void> deleteCategory(int id) async {
    dialog.loadingWithText(message: "Deletando categoria...");

    final result = await deleteDescriptionByCategoryId(id);

    if (result) {
      final CategoryServices categoryServices = CategoryServices();
      await categoryServices.deleteCategory(id).then((value) {
        Get.back();
        if (value == 1) {
          dialog.dialogPositiveButton(
            title: "Sucesso",
            contentText: "Categoria deletada com sucesso!",
            onPressedPositiveButton: () {
              Get.back();
              goToCategory();
            },
          );
        } else {
          dialog.dialogPositiveButton(
            title: "Falhou",
            contentText: "Houve um erro ao tentar deletar a categoria!",
            onPressedPositiveButton: Get.back,
          );
        }
      });
    } else {
      dialog.dialogPositiveButton(
        title: "Falhou",
        contentText:
            "Houve um erro ao tentar deletar a lista de descrições vinvuladas!",
        onPressedPositiveButton: Get.back,
      );
    }
  }

  Future<bool> deleteDescriptionByCategoryId(int id) async {
    bool result = false;
    final DescriptionServices descriptionServices = DescriptionServices();

    if (listDescriptions.isEmpty) {
      Get.back();
      result = true;
    } else {
      await descriptionServices.deleteDescriptionByCategoryId(id).then((value) {
        Get.back();
        if (value > 0) {
          result = true;
        } else {
          result = false;
        }
      });
    }
    return result;
  }

  void updateButton() {
    dialog.dialogNeutralAndPositiveButton(
      title: "Atualizar",
      contentText: "Tem certeza que deseja atualizar a categoria?"
          "\n\n"
          "A categoria atualizada ficará disponivel para novos lançamentos, "
          "porém itens do fluxo de caixa já registrados com está categoria não serão afetados.",
      onPressedNeutralButton: Get.back,
      namePositiveButton: "Continuar",
      onPressedPositiveButton: () {
        Get.back();
        updateCategory();
      },
    );
  }

  void deleteButton() {
    dialog.dialogNeutralAndPositiveButton(
      title: "Deletar",
      contentText: "Tem certeza que deseja deletar a categoria?"
          "\n\n"
          "Ao deletar a categoria todas as descrições vinculadas a este item também serão deletadas, "
          "porém itens do fluxo de caixa já registrados com está categoria não serão afetados.",
      onPressedNeutralButton: Get.back,
      namePositiveButton: "Deletar",
      colorPositiveButton: error,
      onPressedPositiveButton: () {
        Get.back();
        deleteCategory(category.id!);
      },
    );
  }

  void goToDescriptionUpdate(DescriptionModel descriptionModel){
    Get.toNamed("/description_update", arguments: descriptionModel);
  }

  void goToCategory() {
    Get.toNamed("/category");
  }
}
