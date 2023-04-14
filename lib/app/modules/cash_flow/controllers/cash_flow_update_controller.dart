import "package:cash_flow/app/widgets/dialog/cc_dialog.dart";
import "package:cash_flow/app/widgets/dropdown/complement/cc_category_dropdown.dart";
import "package:cash_flow/app/widgets/dropdown/complement/cc_description_dropdown.dart";
import "package:cash_flow/core/utils/date_manager_utils.dart";
import "package:cash_flow/core/utils/validate_entry_utils.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:cash_flow/core/values/strings.dart";
import "package:cash_flow/data/model/cash_flow_model.dart";
import "package:cash_flow/data/model/category_model.dart";
import "package:cash_flow/data/model/description_model.dart";
import "package:cash_flow/data/services/cash_flow_services.dart";
import "package:cash_flow/data/services/category_services.dart";
import "package:cash_flow/data/services/description_services.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:intl/intl.dart";
import "package:syncfusion_flutter_datepicker/datepicker.dart";

class CashFlowUpdateController extends GetxController {
  // Utils
  final DateManagerUtils dateManagerUtils = DateManagerUtils();
  final ValidateEntryUtils validateEntryUtils = ValidateEntryUtils();

  // Controller
  final DateRangePickerController dateRangeDueDateController =
      DateRangePickerController();
  final DateRangePickerController dateRangeSettlementDateController =
      DateRangePickerController();

  // Model
  late CashFlowModel cashFlow;
  late CashFlowModel cashFlowUpdated;
  final Rx<CategoryModel> selectedCategory = CategoryModel(
    category: "",
    type: "",
  ).obs;
  final Rx<DescriptionModel> selectedDescription = DescriptionModel(
    description: "",
    categoryId: -1,
  ).obs;

  // Imported widgets
  final CCDialog dialog = CCDialog();

  // List
  RxList<CategoryModel> listCategories = <CategoryModel>[].obs;
  RxList<DescriptionModel> listDescriptions = <DescriptionModel>[].obs;

  // Conditionals
  RxBool categoryLoaded = false.obs;
  RxBool descriptionLoaded = false.obs;
  RxBool categoryIsEmpty = false.obs;
  RxBool wasLiquidated = false.obs;

  // Date variables
  RxString dueDateConvert = "--/--/--".obs;
  DateTime? dueDate;
  RxString settlementDateConvert = "--/--/--".obs;
  DateTime? settlementDate;

  // Dropdown variables
  final RxString dropdownMovementType = "Despesa".obs;

  // Others variables
  RxString type = "".obs;
  RxString category = "".obs;
  RxString description = "".obs;
  RxString value = "".obs;
  RxString typeOfPayment = "".obs;
  RxString? observation = "".obs;

  @override
  void onInit() {
    cashFlow = Get.arguments as CashFlowModel;
    initializeVariables();
    super.onInit();
  }

  void editTypeMoveButton() {
    dialog.dialogDropDown(
      title: "Tipo de movimentação",
      initialValue: type.value,
      list: const ["Despesa", "Receita"],
      nameNeutralButton: "Cancelar",
      namePositiveButton: "Confirmar",
      onPressedNeutralButton: Get.back,
      onPressedPositiveButton: changeTypeMove,
    );
  }

  void changeTypeMove(String newType) {
    type.value = newType;
    getCategoryByType(type.value);
    category.value = "";
    description.value = "";
    categoryIsEmpty.value = true;
  }

  void editCategoryAndDescription() {
    getCategoryByType(type.value);
    dialog.dialogCategoryAndDescription(
      title: "Descrição",
      categoryDropDown: CCCategoryDropdown(
        categoryLoaded: categoryLoaded,
        selectedCategory: selectedCategory,
        typeOfMovement: type.value,
        getCategoryByType: getCategoryByType,
        changedCategory: changedCategory,
        addNewCategory: addNewCategory,
      ),
      descriptionDropdown: CCDescriptionDropdown(
        descriptionLoaded: descriptionLoaded,
        selectedDescription: selectedDescription,
        getDescriptionByCategoryId: getDescriptionByCategoryId,
        changedDescription: changedDescription,
        addNewDescription: addNewDescription,
        selectedCategory: selectedCategory,
      ),
      nameNeutralButton: "Cancelar",
      onPressedNeutralButton: () {
        category.value = "";
        description.value = "";
        categoryIsEmpty.value = true;
        Get.back();
      },
      namePositiveButton: "Confirmar",
      onPressedPositiveButton: () {
        categoryIsEmpty.value = false;
        Get.back();
      },
    );
  }

  Future<List<CategoryModel>> getCategoryByType(
    String type,
  ) async {
    listCategories.clear();
    categoryLoaded.value = false;

    final CategoryServices categoryServices = CategoryServices();

    await categoryServices.getCategoryByType(type).then((value) {
      listCategories.value = value;
      selectedCategory.value = CategoryModel(
        category: "",
        type: type,
      );
      getDescriptionByCategoryId(-1);
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

  void changedCategory(CategoryModel item) {
    selectedCategory.value = item;
    category.value = item.category;
    getDescriptionByCategoryId(item.id!);
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
      description.value =
          listDescriptions.isNotEmpty ? listDescriptions.first.description : "";
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
            getDescriptionByCategoryId(categoryId);
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

  void changedDescription(DescriptionModel item) {
    description.value = item.description;
  }

  void editMonetaryValueButton() {
    dialog.dialogInputMonetaryValue(
      title: "Valor",
      initialValue: NumberFormat.simpleCurrency(locale: "pt-br").format(
        cashFlow.value,
      ),
      prefixIcon: coinsIcon,
      hint: "R\$ 200,00",
      validator: validateEntryUtils.validatePositiveValue,
      nameNeutralButton: "Cancelar",
      namePositiveButton: "Confirmar",
      onPressedNeutralButton: Get.back,
      onPressedPositiveButton: changeMonetaryValue,
    );
  }

  void changeMonetaryValue(String newValue) {
    value.value = newValue;
  }

  void editTypePaymentButton() {
    dialog.dialogDropDown(
      title: "Método de pagamento",
      initialValue: typeOfPayment.value,
      list: listTypeOfPayment,
      nameNeutralButton: "Cancelar",
      namePositiveButton: "Confirmar",
      onPressedNeutralButton: Get.back,
      onPressedPositiveButton: changeTypeOfPayment,
    );
  }

  void changeTypeOfPayment(String newTypeOfPayment) {
    typeOfPayment.value = newTypeOfPayment;
  }

  void editDueDateButton(BuildContext context) {
    dialog.dialogSingleCalendar(
      context: context,
      controller: dateRangeDueDateController,
      maxDate: DateTime.now().add(const Duration(days: 365)),
      negativeButtonOnPressed: Get.back,
      positiveButtonOnPressed: (Object date) {
        dueDate = date as DateTime;
        dueDateConvert.value = dateManagerUtils.formatDate(date.toString());
        debugPrint(dueDateConvert.value);
      },
    );
  }

  void editSettlementDateButton(BuildContext context) {
    dialog.dialogSingleCalendar(
      context: context,
      controller: dateRangeSettlementDateController,
      maxDate: DateTime.now(),
      negativeButtonOnPressed: Get.back,
      positiveButtonOnPressed: (Object date) {
        settlementDate = date as DateTime;
        settlementDateConvert.value =
            dateManagerUtils.formatDate(date.toString());
      },
    );
  }

  void changeSwitchWasLiquidated(BuildContext context, bool newValue) {
    settlementDate = null;
    settlementDateConvert.value = "--/--/--";
    wasLiquidated.value = newValue;
    if (wasLiquidated.value) {
      editSettlementDateButton(context);
    }
  }

  void editObservationButton() {
    dialog.dialogInputText(
      title: "Observação",
      initialValue: observation?.value ?? "",
      prefixIcon: observationIcon,
      hint: "Anotação...",
      maxLine: 2,
      validator: validateEntryUtils.validateIsEmpty,
      nameNeutralButton: "Cancelar",
      namePositiveButton: "Confirmar",
      onPressedNeutralButton: Get.back,
      onPressedPositiveButton: changeObservation,
    );
  }

  void changeObservation(String newObservation) {
    observation!.value = newObservation;
  }

  void restoreButton() {
    initializeVariables();
    dialog.dialogPositiveButton(
      title: "Sucesso",
      contentText: "Campos redefinidos com sucesso!",
      onPressedPositiveButton: Get.back,
    );
  }

  void updateButton() {
    dialog.dialogNeutralAndPositiveButton(
      title: "Atualizar",
      contentText: "Tem certeza que deseja atualizar as informações alteradas?",
      onPressedNeutralButton: Get.back,
      onPressedPositiveButton: () {
        Get.back();
        updateCashFlowItem();
      },
    );
  }

  bool validateForm() {
    if (categoryIsEmpty.isTrue ||
        (wasLiquidated.isTrue && settlementDateConvert.value == "--/--/--")) {
      return false;
    }

    return true;
  }

  Future<void> updateCashFlowItem() async {
    createRequest();

    final CashFlowServices cashFlowServices = CashFlowServices();

    dialog.loadingWithText(message: "Alterando item de fluxo de caixa.");
    await cashFlowServices
        .updateCashFlowItem(cashFlowUpdated, cashFlow.id!)
        .then((value) {
      Get.back();
      if (value == 1) {
        dialog.dialogPositiveButton(
          title: "Sucesso",
          contentText: "Movimentação atualizada com sucesso!",
          onPressedPositiveButton: goToCashFlow,
        );
      } else {
        dialog.dialogPositiveButton(
          title: "Falhou",
          contentText: "Houve um erro ao tentar atualizar a movimentação!",
          onPressedPositiveButton: Get.back,
        );
      }
    });
  }

  double convertStringToDouble(String value) {
    return double.parse(
      value.replaceAll("R\$", "").replaceAll(".", "").replaceAll(",", "."),
    );
  }

  void createRequest() {
    cashFlowUpdated = CashFlowModel(
      id: cashFlow.id,
      type: type.value,
      category: category.value,
      description: description.value,
      value: convertStringToDouble(value.value),
      typeOfPayment: typeOfPayment.value,
      status: wasLiquidated.value ? "Liquidado" : "Não liquidado",
      dueDate: dueDate!,
      settledIn: wasLiquidated.value ? settlementDate : null,
      observation: observation?.value,
      createIn: cashFlow.createIn,
    );
  }

  void initializeVariables() {
    type.value = cashFlow.type;

    category.value = cashFlow.category;

    description.value = cashFlow.description;

    value.value = NumberFormat.simpleCurrency(locale: "pt-br").format(
      cashFlow.value,
    );

    typeOfPayment.value = cashFlow.typeOfPayment;

    dueDate = cashFlow.dueDate;
    dueDateConvert.value =
        dateManagerUtils.formatDate(cashFlow.dueDate.toString());

    if (cashFlow.status == "Liquidado") {
      settlementDate = cashFlow.settledIn;
      settlementDateConvert.value =
          dateManagerUtils.formatDate(cashFlow.settledIn.toString());
      wasLiquidated.value = true;
    } else {
      wasLiquidated.value = false;
    }

    observation?.value = cashFlow.observation!;
  }

  void goToCashFlow() {
    Get.offNamed("/cash_flow");
  }
}
