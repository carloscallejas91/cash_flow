import "package:cash_flow/app/widgets/dialog/cc_dialog.dart";
import "package:cash_flow/core/utils/date_manager_utils.dart";
import "package:cash_flow/core/utils/validate_entry_utils.dart";
import "package:cash_flow/data/model/cash_flow_model.dart";
import "package:cash_flow/data/model/category_model.dart";
import "package:cash_flow/data/model/description_model.dart";
import "package:cash_flow/data/services/cash_flow_services.dart";
import "package:cash_flow/data/services/category_services.dart";
import "package:cash_flow/data/services/description_services.dart";
import "package:cash_flow/routes/app_routes.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:syncfusion_flutter_datepicker/datepicker.dart";

class CashFlowHandlingController extends GetxController {
  // Keys
  final GlobalKey<FormState> stepOneFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> stepTwoFormKey = GlobalKey<FormState>();

  // Utils
  final ValidateEntryUtils validateEntryUtils = ValidateEntryUtils();
  final DateManagerUtils dateManagerUtils = DateManagerUtils();

  // Controller
  final DateRangePickerController dateRangeDueDateController =
      DateRangePickerController();
  final DateRangePickerController dateRangeSettlementDateController =
      DateRangePickerController();
  final TextEditingController valueController = TextEditingController();
  final TextEditingController observationController = TextEditingController();
  final TextEditingController settlementDateController =
      TextEditingController();
  final TextEditingController dueDateController = TextEditingController();

  // imported widget
  final CCDialog dialog = CCDialog();

  // Model
  late CashFlowModel cashFlowItem;
  Rx<CategoryModel> selectedCategory = CategoryModel(
    category: "",
    type: "",
  ).obs;
  Rx<DescriptionModel> selectedDescription = DescriptionModel(
    description: "",
    categoryId: -1,
  ).obs;

  // Lists
  final List<String> dropdownTypeMovement = ["Despesa", "Receita"];
  RxList<CategoryModel> listCategories = <CategoryModel>[].obs;
  RxList<DescriptionModel> listDescriptions = <DescriptionModel>[].obs;

  // Conditionals
  RxBool categoryLoaded = false.obs;
  RxBool descriptionLoaded = false.obs;
  RxBool isExpense = true.obs;
  RxBool isIncome = false.obs;
  RxBool wasLiquidated = false.obs;

  // Stepper variables
  RxInt stepIndex = 0.obs;

  // Date variables
  RxString dueDateConvert = "--/--/--".obs;
  DateTime? dueDate;
  RxString settlementDateConvert = "--/--/--".obs;
  DateTime? settlementDate;

  // Others variables
  final RxString typeMovement = "Despesa".obs;
  RxString selectedTypePayment = "Outro".obs;

  @override
  void onInit() {
    getCategoryByType("Despesa");
    super.onInit();
  }

  Future<List<CategoryModel>> getCategoryByType(
    String type,
  ) async {
    debugPrint(type);
    listCategories.clear();
    categoryLoaded.value = false;

    final CategoryServices categoryServices = CategoryServices();

    await categoryServices.getCategoryByType(type).then((value) {
      listCategories.value = value;
      selectedCategory.value = CategoryModel(
        category: "",
        type: type,
      );
      getDescriptionByCategoryId(selectedCategory.value.id ?? -1);
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
            getCategoryByType(type);
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

  Future<List<DescriptionModel>> getDescriptionByCategoryId(
    int categoryId,
  ) async {
    listDescriptions.clear();
    descriptionLoaded.value = false;

    final DescriptionServices descriptionServices = DescriptionServices();

    await descriptionServices
        .getDescriptionByCategoryId(categoryId)
        .then((value) {
      listDescriptions.value = value;
      selectedDescription.value = listDescriptions.isNotEmpty
          ? listDescriptions.first
          : DescriptionModel(description: "", categoryId: -1);
    }).whenComplete(() => descriptionLoaded.value = true);

    return listDescriptions;
  }

  Future<void> addNewDescription(
    String name,
    int categoryId,
  ) async {
    Get.back();
    dialog.loadingWithText(message: "Salvando descrição...");
    final DescriptionModel description = DescriptionModel(
      description: name,
      categoryId: categoryId,
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

  void dueDateDialog(BuildContext context) {
    dialog.dialogSingleCalendar(
      context: context,
      controller: dateRangeDueDateController,
      maxDate: DateTime.now().add(const Duration(days: 365)),
      negativeButtonOnPressed: Get.back,
      positiveButtonOnPressed: (Object date) {
        dueDate = date as DateTime;
        dueDateConvert.value = dateManagerUtils.formatDate(date.toString());
        dueDateController.text = dueDateConvert.value;
      },
    );
  }

  void settlementDateDialog(BuildContext context) {
    dialog.dialogSingleCalendar(
      context: context,
      controller: dateRangeSettlementDateController,
      maxDate: DateTime.now(),
      negativeButtonOnPressed: Get.back,
      positiveButtonOnPressed: (Object date) {
        settlementDate = date as DateTime;
        settlementDateConvert.value =
            dateManagerUtils.formatDate(date.toString());
        settlementDateController.text = settlementDateConvert.value;
      },
    );
  }

  void changedCategory(CategoryModel category) {
    selectedCategory.value = category;
    // selectedDescription = DescriptionModel(description: "", categoryId: -1);
    getDescriptionByCategoryId(selectedCategory.value.id!);
  }

  void changedDescription(DescriptionModel description) {
    selectedDescription.value = description;
  }

  void changedTypePayment(String typePayment) {
    selectedTypePayment.value = typePayment;
  }

  String getStatus() {
    if (wasLiquidated.value == true) {
      return "Liquidado";
    } else {
      return "Não liquidado";
    }
  }

  bool validateStepOne() {
    if (stepOneFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  void onStepContinue() {
    if (stepIndex.value == 0 && validateStepOne() == true) {
      stepIndex.value += 1;
    } else if (stepIndex.value == 1 && validateStepTwo() == true) {
      stepIndex.value += 1;
    } else if (stepIndex.value == 2) {
      addCashFlowMovement();
    }
  }

  bool validateStepTwo() {
    if (wasLiquidated.isTrue && stepTwoFormKey.currentState!.validate()) {
      return true;
    } else if (wasLiquidated.isFalse) {
      return true;
    } else {
      return false;
    }
  }

  void onStepCancel() {
    if (stepIndex.value > 0) {
      stepIndex.value -= 1;
    } else if (stepIndex.value == 0) {
      Get.back();
    }
  }

  double convertStringToDouble(String value) {
    return double.parse(
      value.replaceAll("R\$", "").replaceAll(".", "").replaceAll(",", "."),
    );
  }

  Future<void> addCashFlowMovement() async {
    dialog.loadingWithText(message: "Salvando movimentação...");
    final CashFlowModel cashFlow = CashFlowModel(
      type: typeMovement.value,
      category: selectedCategory.value.category,
      description: selectedDescription.value.description,
      value: convertStringToDouble(valueController.text),
      typeOfPayment: selectedTypePayment.value,
      observation: observationController.text,
      status: wasLiquidated.value ? "Liquidado" : "Não liquidado",
      dueDate: dueDate!,
      settledIn: wasLiquidated.value ? settlementDate : null,
      createIn: DateTime.now(),
    );

    final CashFlowServices cashFlowServices = CashFlowServices();

    await cashFlowServices.addCashFlowItem(cashFlow).whenComplete(() {
      Get.back();
      dialog.dialogNeutralAndPositiveButton(
        title: "Sucesso",
        contentText: "Seu item foi adicionado ao fluxo de caixa.",
        nameNeutralButton: "Sair",
        namePositiveButton: "Nova movimentação",
        onPressedNeutralButton: () {
          Get.back();
          Get.offAndToNamed(Routes.CASH_FLOW);
        },
        onPressedPositiveButton: () {
          cleanField();
          getCategoryByType("Despesa");
          Get.back();
        },
      );
    });
  }

  void cleanField() {
    typeMovement.value = "Despesa";
    stepIndex.value = 0;
    dueDateConvert.value = "--/--/--";
    dueDate = null;
    settlementDateConvert.value = "--/--/--";
    settlementDate = null;

    dueDateController.text = "";
    settlementDateController.text = "";
    valueController.text = "";
    observationController.text = "";

    isExpense.value = true;
    isIncome.value = false;
    wasLiquidated.value = false;

    selectedTypePayment.value = "Outro";
  }

  void goToCashFlow() {
    Get.offNamed("/cash_flow");
  }
}
