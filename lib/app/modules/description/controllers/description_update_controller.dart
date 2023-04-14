import "package:cash_flow/app/widgets/dialog/cc_dialog.dart";
import "package:cash_flow/core/utils/validate_entry_utils.dart";
import "package:cash_flow/core/values/colors.dart";
import "package:cash_flow/data/model/category_model.dart";
import "package:cash_flow/data/model/description_model.dart";
import "package:cash_flow/data/services/category_services.dart";
import "package:cash_flow/data/services/description_services.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class DescriptionUpdateController extends GetxController {
  // Keys
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Utils
  final ValidateEntryUtils validateEntry = ValidateEntryUtils();

  // Widget
  final CCDialog dialog = CCDialog();

  // Controller
  final TextEditingController descriptionController = TextEditingController();

  // Model
  Rx<CategoryModel> selectedCategory =
      CategoryModel(category: "", type: "").obs;
  DescriptionModel description =
      DescriptionModel(description: "", categoryId: -1);
  DescriptionModel descriptionUpdated =
      DescriptionModel(description: "", categoryId: -1);

  // List
  RxList<CategoryModel> listCategories = <CategoryModel>[].obs;

  // Conditionals
  RxBool categoryLoaded = false.obs;
  RxBool expansionChanged = true.obs;

  @override
  void onInit() {
    getArguments();
    initializeVariables();
    getCategoryByName("");
    super.onInit();
  }

  void getArguments() {
    description = Get.arguments as DescriptionModel;
  }

  void initializeVariables() {
    descriptionController.text = description.description;
  }

  Future<List<CategoryModel>> getCategoryByName(String category) async {
    categoryLoaded.value = false;
    final CategoryServices categoryServices = CategoryServices();

    await categoryServices.getCategoryByName(category).then((value) {
      listCategories.value = value;
      for (final element in listCategories) {
        if (element.id == description.categoryId) {
          selectedCategory.value = element;
        }
      }
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
  }

  Future<void> updateDescription() async {
    createDescriptionRequest();

    final DescriptionServices descriptionServices = DescriptionServices();

    dialog.loadingWithText(message: "Alterando descrição...");
    await descriptionServices
        .updateDescription(descriptionUpdated, description.id!)
        .then((value) {
      Get.back();
      if (value == 1) {
        dialog.dialogPositiveButton(
          title: "Sucesso",
          contentText: "Descrição atualizada com sucesso!",
          onPressedPositiveButton: goToDescription,
        );
      } else {
        dialog.dialogPositiveButton(
          title: "Falhou",
          contentText: "Houve um erro ao tentar atualizar a descrição!",
          onPressedPositiveButton: Get.back,
        );
      }
    });
  }

  Future<void> deleteDescription(int id) async {
    dialog.loadingWithText(message: "Deletando descrição...");

    final DescriptionServices descriptionServices = DescriptionServices();

    await descriptionServices.deleteDescription(id).then((value) {
      Get.back();
      if (value == 1) {
        dialog.dialogPositiveButton(
          title: "Sucesso",
          contentText: "descrição deletada com sucesso!",
          onPressedPositiveButton: () {
            Get.back();
            goToDescription();
          },
        );
      } else {
        dialog.dialogPositiveButton(
          title: "Falhou",
          contentText: "Houve um erro ao tentar deletar a descrição!",
          onPressedPositiveButton: Get.back,
        );
      }
    });
  }

  void createDescriptionRequest() {
    descriptionUpdated = DescriptionModel(
      id: description.id,
      categoryId: selectedCategory.value.id!,
      description: descriptionController.text,
    );
  }

  void onExpansionChanged(bool value) {
    expansionChanged.value = value;
  }

  void validateForm() {
    if (formKey.currentState!.validate()) {
      updateButton();
    }
  }

  void updateButton() {
    dialog.dialogNeutralAndPositiveButton(
      title: "Atualizar",
      contentText: "Tem certeza que deseja atualizar a descrição?"
          "\n\n"
          "A descrição atualizada ficará disponivel para novos lançamentos, "
          "porém itens do fluxo de caixa já registrados com está descrição não serão afetados.",
      onPressedNeutralButton: Get.back,
      namePositiveButton: "Continuar",
      onPressedPositiveButton: () {
        Get.back();
        updateDescription();
      },
    );
  }

  void deleteButton() {
    dialog.dialogNeutralAndPositiveButton(
      title: "Deletar",
      contentText: "Tem certeza que deseja deletar a descrição?"
          "\n\n"
          "Ao deletar a descrição todas as descrições vinculadas a este item também serão deletadas, "
          "porém itens do fluxo de caixa já registrados com está descrição não serão afetados.",
      onPressedNeutralButton: Get.back,
      namePositiveButton: "Deletar",
      colorPositiveButton: error,
      onPressedPositiveButton: () {
        Get.back();
        deleteDescription(description.id!);
      },
    );
  }

  void goToDescription() {
    Get.back();
    // Get.offAllNamed("/description");
  }
}
