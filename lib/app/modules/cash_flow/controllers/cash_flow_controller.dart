import "package:cash_flow/app/widgets/dialog/cc_dialog.dart";
import "package:cash_flow/app/widgets/snack_bar/cc_snack_bar.dart";
import "package:cash_flow/core/utils/color_utils.dart";
import "package:cash_flow/core/utils/date_manager_utils.dart";
import "package:cash_flow/data/enum/cash_flow_movement_type.dart";
import "package:cash_flow/data/enum/status_cash_flow.dart";
import "package:cash_flow/data/model/cash_flow_model.dart";
import "package:cash_flow/data/services/cash_flow_services.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:syncfusion_flutter_datepicker/datepicker.dart";

class CashFlowController extends GetxController {
  // enum
  Rx<StatusCashFlow> statusCashFlow = StatusCashFlow.settled.obs;
  Rx<CashFlowMovementType> categoryCashFlow = CashFlowMovementType.income.obs;

  // controller
  final DateRangePickerController dateRangePickerController =
      DateRangePickerController();

  // Utils
  final DateManagerUtils _dateManagerUtils = DateManagerUtils();
  final ColorUtils colorUtils = ColorUtils();

  // List
  final RxList<CashFlowModel> cashFlowList = <CashFlowModel>[].obs;

  // conditionals
  RxBool isLoading = false.obs;
  RxBool dateRangeIsValid = true.obs;
  RxBool expansionChanged = false.obs;
  RxBool isCalculatingCurrentBalance = false.obs;

  // Variables
  RxString startDateConvert = "".obs;
  DateTime? startDate;
  RxString endDateConvert = "".obs;
  DateTime? endDate;
  RxString typeFilter = "receitas e despesas liquidados".obs;
  RxDouble currentBalance = 0.0.obs;
  RxDouble partialBalance = 0.0.obs;

  // widgets
  final CCDialog ccDialog = CCDialog();

  @override
  void onInit() {
    initializeVariable();
    initializeCashFlow();

    super.onInit();
  }

  void initializeVariable() {
    startDate = _dateManagerUtils.getFirstDayMonth();
    startDateConvert.value = _dateManagerUtils
        .formatDate(_dateManagerUtils.getFirstDayMonth().toString());
    endDate = _dateManagerUtils.getLastDayMonth();
    endDateConvert.value = _dateManagerUtils
        .formatDate(_dateManagerUtils.getLastDayMonth().toString());
  }

  void initializeCashFlow() {
    isLoading.value = false;
    Future.wait([
      getCurrentBalance(),
      getAllSettledCashFlowItems(
        startDate!.toIso8601String(),
        endDate!.toIso8601String(),
        "",
      ),
    ]).whenComplete(() {
      isLoading.value = true;
    });
  }

  Future<void> getAllCashFlowItems(
    String startDate,
    String endDate,
    String type,
  ) async {
    cashFlowList.clear();
    final CashFlowServices cashFlowServices = CashFlowServices();
    await cashFlowServices
        .getAllInRangeCashFlowItems(
      startDate,
      endDate,
      type,
    )
        .then((value) {
      cashFlowList.value = value;
      getPartialBalance();
    });
  }

  Future<void> getAllSettledCashFlowItems(
    String startDate,
    String endDate,
    String type,
  ) async {
    cashFlowList.clear();
    final CashFlowServices cashFlowServices = CashFlowServices();
    await cashFlowServices
        .getAllSettledInRangeCashFlowItems(
      startDate,
      endDate,
      type,
    )
        .then((value) {
      cashFlowList.value = value;
      getPartialBalance();
    });
  }

  Future<void> getAllUnsettledCashFlowItems(
    String startDate,
    String endDate,
    String type,
  ) async {
    cashFlowList.clear();
    final CashFlowServices cashFlowServices = CashFlowServices();
    await cashFlowServices
        .getAllUnsettledInRangeCashFlowItems(
      startDate,
      endDate,
      type,
    )
        .then((value) {
      cashFlowList.value = value;
      getPartialBalance();
    });
  }

  Future<int> deleteCashFlowItem(int id) async {
    final CashFlowServices cashFlowServices = CashFlowServices();
    final result = await cashFlowServices.deleteCashFlowItem(id);
    return result;
  }

  // Future<void> deleteAllCashFlow() async {
  //   final CashFlowServices cashFlowServices = CashFlowServices();
  //   final result = await cashFlowServices.deleteCashFlowTab();
  // }

  Future<void> getCurrentBalance() async {
    currentBalance.value = 0;
    isCalculatingCurrentBalance.value = true;

    final CashFlowServices cashFlowServices = CashFlowServices();

    await cashFlowServices
        .getAllCashFlowItemsByStatus("Liquidado")
        .then((value) {
      for (final element in value) {
        if (element.type.compareTo("Receita") == 0) {
          currentBalance.value += element.value;
        } else {
          currentBalance.value -= element.value;
        }
      }
    }).whenComplete(() => isCalculatingCurrentBalance.value = false);
  }

  void getPartialBalance() {
    partialBalance.value = 0;
    for (final element in cashFlowList) {
      if (element.type.compareTo("Receita") == 0) {
        partialBalance.value += element.value;
      } else {
        partialBalance.value -= element.value;
      }
    }
  }

  void rangeOfSelectedDates(
    DateRangePickerSelectionChangedArgs args,
  ) {
    dateRangeIsValid.value = false;
    if (args.value.startDate != null && args.value.endDate != null) {
      startDate = args.value.startDate as DateTime;
      endDate = args.value.endDate as DateTime;
      dateRangeIsValid.value = true;
    }
  }

  void onSubmitRangeDateButton(BuildContext context) {
    // customTileExpanded.value = false;
    startDateConvert.value = _dateManagerUtils.formatDate(
      startDate.toString(),
    );
    endDateConvert.value = _dateManagerUtils.formatDate(
      endDate.toString(),
    );
    getAllSettledCashFlowItems(
      DateTime(startDate!.year, startDate!.month, startDate!.day, 0, 0, 0)
          .toIso8601String(),
      DateTime(endDate!.year, endDate!.month, endDate!.day, 23, 59, 59)
          .toIso8601String(),
      "",
    ).whenComplete(() {
      typeFilter.value = "receitas e despesas liquidados";
      showSnackBar(context);
    });
  }

  void useFilter() {
    if (statusCashFlow.value == StatusCashFlow.settled &&
        categoryCashFlow.value == CashFlowMovementType.income) {
      typeFilter.value = "receitas liquidados";
      getAllSettledCashFlowItems(
        startDate!.toIso8601String(),
        endDate!.toIso8601String(),
        "Receita",
      );
    } else if (statusCashFlow.value == StatusCashFlow.unsettled &&
        categoryCashFlow.value == CashFlowMovementType.income) {
      typeFilter.value = "receitas não liquidados";
      getAllUnsettledCashFlowItems(
        startDate!.toIso8601String(),
        endDate!.toIso8601String(),
        "Receita",
      );
    } else if (statusCashFlow.value == StatusCashFlow.all &&
        categoryCashFlow.value == CashFlowMovementType.income) {
      typeFilter.value = "receitas liquidados e não liquidados";
      getAllCashFlowItems(
        startDate!.toIso8601String(),
        endDate!.toIso8601String(),
        "Receita",
      );
    } else if (statusCashFlow.value == StatusCashFlow.settled &&
        categoryCashFlow.value == CashFlowMovementType.expense) {
      typeFilter.value = "despesas liquidados";
      getAllSettledCashFlowItems(
        startDate!.toIso8601String(),
        endDate!.toIso8601String(),
        "Despesa",
      );
    } else if (statusCashFlow.value == StatusCashFlow.unsettled &&
        categoryCashFlow.value == CashFlowMovementType.expense) {
      typeFilter.value = "despesas não liquidados";
      getAllUnsettledCashFlowItems(
        startDate!.toIso8601String(),
        endDate!.toIso8601String(),
        "Despesa",
      );
    } else if (statusCashFlow.value == StatusCashFlow.all &&
        categoryCashFlow.value == CashFlowMovementType.expense) {
      typeFilter.value = "despesas liquidados e não liquidados";
      getAllCashFlowItems(
        startDate!.toIso8601String(),
        endDate!.toIso8601String(),
        "Despesa",
      );
    } else if (statusCashFlow.value == StatusCashFlow.settled &&
        categoryCashFlow.value == CashFlowMovementType.all) {
      typeFilter.value = "receitas e despesas liquidados";
      getAllSettledCashFlowItems(
        startDate!.toIso8601String(),
        endDate!.toIso8601String(),
        "",
      );
    } else if (statusCashFlow.value == StatusCashFlow.unsettled &&
        categoryCashFlow.value == CashFlowMovementType.all) {
      typeFilter.value = "receitas e despesas não liquidados";
      getAllUnsettledCashFlowItems(
        startDate!.toIso8601String(),
        endDate!.toIso8601String(),
        "",
      );
    } else if (statusCashFlow.value == StatusCashFlow.all &&
        categoryCashFlow.value == CashFlowMovementType.all) {
      typeFilter.value = "receitas e despesas liquidados e não liquidados";
      getAllCashFlowItems(
        startDate!.toIso8601String(),
        endDate!.toIso8601String(),
        "",
      );
    }
  }

  void showSnackBar(
    BuildContext context,
  ) {
    if (dateRangeIsValid.value) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        CCSnackBar.success(
          message:
              "Resultado encontrado entre: $startDateConvert até $endDateConvert.",
        ).show(),
      );
      // customTileExpanded.value = !customTileExpanded.value;
    } else {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        CCSnackBar.error(
          message: "Datas não definidas.",
        ).show(),
      );
    }
  }

  void deleteIconButtonPressed(int id) {
    int result = -1;
    Get.back();
    ccDialog.loadingWithText(message: "Apagando item...");
    deleteCashFlowItem(id).then((value) {
      result = value;
    }).whenComplete(() {
      Get.back();
      if (result == 1) {
        ccDialog.dialogPositiveButton(
          title: "Sucesso",
          contentText: "Item excluído do fluxo de caixa.",
          onPressedPositiveButton: () {
            Get.back();
            initializeCashFlow();
          },
        );
      } else {
        ccDialog.dialogPositiveButton(
          title: "Falhou",
          contentText:
              "Houve um erro ao tentar excluir o item do fluxo de caixa.",
          onPressedPositiveButton: () {
            Get.back();
            initializeCashFlow();
          },
        );
      }
    });
  }

  void updateIconButtonPressed(CashFlowModel item) {
    Get.back();
    goToCashUpdate(
      item,
    );
  }

  void onExpansionChanged(bool value) {
    expansionChanged.value = value;
  }

  void goToCashHandling() {
    Get.toNamed("/cash_flow_handling");
  }

  void goToCashUpdate(CashFlowModel args) {
    Get.toNamed("/cash_flow_update", arguments: args);
  }

  void goToCashFlowSummary() {
    Get.toNamed("/cash_flow_summary");
  }
}
