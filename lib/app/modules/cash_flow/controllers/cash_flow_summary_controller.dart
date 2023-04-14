import "package:cash_flow/core/utils/color_utils.dart";
import "package:cash_flow/data/model/cash_flow_model.dart";
import "package:cash_flow/data/services/cash_flow_services.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class CashFlowSummaryController extends GetxController {
  // Utils
  ColorUtils colorUtils = ColorUtils();

  // Controller
  PageController pageController = PageController(initialPage: 0);

  // Summary
  RxDouble settledIncome = 0.0.obs;
  RxDouble unsettledIncome = 0.0.obs;
  RxDouble settledUnsettledIncome = 0.0.obs;
  RxDouble expenseSettled = 0.0.obs;
  RxDouble unpaidExpense = 0.0.obs;
  RxDouble paidUnpaidExpense = 0.0.obs;
  RxDouble netIncomeExpense = 0.0.obs;
  RxDouble unpaidIncomeExpense = 0.0.obs;
  RxDouble balanceMonth = 0.0.obs;
  RxDouble generalBalance = 0.0.obs;
  RxDouble generalBalanceYear = 0.0.obs;

  // Dates
  late DateTime startDate;
  late DateTime endDate;

  // Conditions
  RxBool summaryLoading = false.obs;
  RxBool expansionChanged = false.obs;
  RxBool isCalculatingCurrentBalance = false.obs;

  // Others variables
  RxInt selectedFilterYear = DateTime.now().year.obs;
  RxInt currentIndexExpansionTile = 100.obs;
  RxInt currentPage = 0.obs;

  @override
  void onInit() {
    getBalance();
    super.onInit();
  }

  void changedFilterYear(String year) {
    selectedFilterYear.value = int.parse(year);
    currentIndexExpansionTile.value = 100;
    getBalance();
  }

  void getSummary(int year) {
    summaryLoading.value = false;
    Future.wait([
      // Receitas liquidadas
      getAllSettledCashFlowItems(
        startDate.toIso8601String(),
        endDate.toIso8601String(),
        "Receita",
      ),
      // Receitas não liquidadas
      getAllUnsettledCashFlowItems(
        startDate.toIso8601String(),
        endDate.toIso8601String(),
        "Receita",
      ),
      // Receitas liquidados e não liquidados
      getAllCashFlowItems(
        startDate.toIso8601String(),
        endDate.toIso8601String(),
        "Receita",
      ),
      // Despesas liquidadas
      getAllSettledCashFlowItems(
        startDate.toIso8601String(),
        endDate.toIso8601String(),
        "Despesa",
      ),
      // Despesas não liquidadas
      getAllUnsettledCashFlowItems(
        startDate.toIso8601String(),
        endDate.toIso8601String(),
        "Despesa",
      ),
      // Despesas liquidados e não liquidados
      getAllCashFlowItems(
        startDate.toIso8601String(),
        endDate.toIso8601String(),
        "Despesa",
      ),
      // Receitas e despesas liquidados
      getAllSettledCashFlowItems(
        startDate.toIso8601String(),
        endDate.toIso8601String(),
        "",
      ),
      // Receitas e despesas não liquidados
      getAllUnsettledCashFlowItems(
        startDate.toIso8601String(),
        endDate.toIso8601String(),
        "",
      ),
    ]).whenComplete(() {
      summaryLoading.value = true;
    });
  }

  // Receitas liquidadas
  // Despesas liquidadas
  Future<void> getAllSettledCashFlowItems(
    String startDate,
    String endDate,
    String type,
  ) async {
    final CashFlowServices cashFlowServices = CashFlowServices();
    await cashFlowServices
        .getAllSettledInRangeCashFlowItems(
      startDate,
      endDate,
      type,
    )
        .then((value) {
      if (type == "Receita") {
        settledIncome.value = getPartialBalance(value);
      } else if (type == "Despesa") {
        expenseSettled.value = getPartialBalance(value);
      } else {
        netIncomeExpense.value = getPartialBalance(value);
      }
    });
  }

  // Receitas não liquidadas
  // Despesas não liquidadas
  Future<void> getAllUnsettledCashFlowItems(
    String startDate,
    String endDate,
    String type,
  ) async {
    final CashFlowServices cashFlowServices = CashFlowServices();
    await cashFlowServices
        .getAllUnsettledInRangeCashFlowItems(
      startDate,
      endDate,
      type,
    )
        .then((value) {
      if (type == "Receita") {
        unsettledIncome.value = getPartialBalance(value);
      } else if (type == "Despesa") {
        unpaidExpense.value = getPartialBalance(value);
      } else {
        unpaidIncomeExpense.value = getPartialBalance(value);
      }
    });
  }

  // Receitas liquidados e não liquidados
  // Despesas liquidados e não liquidados
  Future<void> getAllCashFlowItems(
    String startDate,
    String endDate,
    String type,
  ) async {
    final CashFlowServices cashFlowServices = CashFlowServices();
    await cashFlowServices
        .getAllInRangeCashFlowItems(
      startDate,
      endDate,
      type,
    )
        .then((value) {
      if (type == "Receita") {
        settledUnsettledIncome.value = getPartialBalance(value);
      } else {
        paidUnpaidExpense.value = getPartialBalance(value);
      }
    });
  }

  double getPartialBalance(List<CashFlowModel> list) {
    double result = 0;
    for (final element in list) {
      if (element.type.compareTo("Receita") == 0) {
        result += element.value;
      } else {
        result -= element.value;
      }
    }
    return result;
  }

  Future<void> getBalance() async {
    isCalculatingCurrentBalance.value = true;
    Future.wait([
      getGeneralBalance(),
      getGeneralBalanceWithRangeDate(),
    ]).whenComplete(() => isCalculatingCurrentBalance.value = false);
  }

  Future<void> getGeneralBalance() async {
    generalBalance.value = 0;
    final CashFlowServices cashFlowServices = CashFlowServices();

    await cashFlowServices
        .getAllCashFlowItemsByStatus("Liquidado")
        .then((value) {
      for (final element in value) {
        if (element.type.compareTo("Receita") == 0) {
          generalBalance.value += element.value;
        } else {
          generalBalance.value -= element.value;
        }
      }
    });
  }

  Future<void> getGeneralBalanceWithRangeDate() async {
    generalBalanceYear.value = 0;
    final CashFlowServices cashFlowServices = CashFlowServices();

    final String startDate =
        DateTime(selectedFilterYear.value, 01, 01).toIso8601String();
    final String endDate =
        DateTime(selectedFilterYear.value, 12, 31).toIso8601String();

    await cashFlowServices
        .getAllInRangeCashFlowItemsByStatus(
      startDate,
      endDate,
      "Liquidado",
    )
        .then((value) {
      for (final element in value) {
        if (element.type.compareTo("Receita") == 0) {
          generalBalanceYear.value += element.value;
        } else {
          generalBalanceYear.value -= element.value;
        }
      }
    });
  }

  void onExpansionChangedJanuary(bool value) {
    expansionChanged.value = value;
    currentIndexExpansionTile.value = 0;
    if (expansionChanged.value == true) {
      startDate = DateTime(selectedFilterYear.value, 01, 01);
      endDate = DateTime(selectedFilterYear.value, 02, 0);
      getSummary(selectedFilterYear.value);
    }
  }

  void onExpansionChangedFebruary(bool value) {
    expansionChanged.value = value;
    currentIndexExpansionTile.value = 1;
    if (expansionChanged.value == true) {
      startDate = DateTime.utc(selectedFilterYear.value, 02, 01);
      endDate = DateTime.utc(selectedFilterYear.value, 03, 0);
      getSummary(selectedFilterYear.value);
    }
  }

  void onExpansionChangedMarch(bool value) {
    expansionChanged.value = value;
    currentIndexExpansionTile.value = 2;
    if (expansionChanged.value == true) {
      startDate = DateTime.utc(selectedFilterYear.value, 03, 01);
      endDate = DateTime.utc(selectedFilterYear.value, 04, 0);
      getSummary(selectedFilterYear.value);
    }
  }

  void onExpansionChangedApril(bool value) {
    expansionChanged.value = value;
    currentIndexExpansionTile.value = 3;
    if (expansionChanged.value == true) {
      startDate = DateTime.utc(selectedFilterYear.value, 04, 01);
      endDate = DateTime.utc(selectedFilterYear.value, 05, 0);
      getSummary(selectedFilterYear.value);
    }
  }

  void onExpansionChangedMay(bool value) {
    expansionChanged.value = value;
    currentIndexExpansionTile.value = 4;
    if (expansionChanged.value == true) {
      startDate = DateTime.utc(selectedFilterYear.value, 05, 01);
      endDate = DateTime.utc(selectedFilterYear.value, 06, 0);
      getSummary(selectedFilterYear.value);
    }
  }

  void onExpansionChangedJune(bool value) {
    expansionChanged.value = value;
    currentIndexExpansionTile.value = 5;
    if (expansionChanged.value == true) {
      startDate = DateTime.utc(selectedFilterYear.value, 06, 01);
      endDate = DateTime.utc(selectedFilterYear.value, 07, 0);
      getSummary(selectedFilterYear.value);
    }
  }

  void onExpansionChangedJuly(bool value) {
    expansionChanged.value = value;
    currentIndexExpansionTile.value = 6;
    if (expansionChanged.value == true) {
      startDate = DateTime.utc(selectedFilterYear.value, 07, 01);
      endDate = DateTime.utc(selectedFilterYear.value, 08, 0);
      getSummary(selectedFilterYear.value);
    }
  }

  void onExpansionChangedAugust(bool value) {
    expansionChanged.value = value;
    currentIndexExpansionTile.value = 7;
    if (expansionChanged.value == true) {
      startDate = DateTime.utc(selectedFilterYear.value, 08, 01);
      endDate = DateTime.utc(selectedFilterYear.value, 09, 0);
      getSummary(selectedFilterYear.value);
    }
  }

  void onExpansionChangedSeptember(bool value) {
    expansionChanged.value = value;
    currentIndexExpansionTile.value = 8;
    if (expansionChanged.value == true) {
      startDate = DateTime.utc(selectedFilterYear.value, 09, 01);
      endDate = DateTime.utc(selectedFilterYear.value, 10, 0);
      getSummary(selectedFilterYear.value);
    }
  }

  void onExpansionChangedOctober(bool value) {
    expansionChanged.value = value;
    currentIndexExpansionTile.value = 9;
    if (expansionChanged.value == true) {
      startDate = DateTime.utc(selectedFilterYear.value, 10, 01);
      endDate = DateTime.utc(selectedFilterYear.value, 11, 0);
      getSummary(selectedFilterYear.value);
    }
  }

  void onExpansionChangedNovember(bool value) {
    expansionChanged.value = value;
    currentIndexExpansionTile.value = 10;
    if (expansionChanged.value == true) {
      startDate = DateTime.utc(selectedFilterYear.value, 11, 01);
      endDate = DateTime.utc(selectedFilterYear.value, 12, 0);
      getSummary(selectedFilterYear.value);
    }
  }

  void onExpansionChangedDecember(bool value) {
    expansionChanged.value = value;
    currentIndexExpansionTile.value = 11;
    if (expansionChanged.value == true) {
      startDate = DateTime.utc(selectedFilterYear.value, 12, 01);
      endDate = DateTime.utc(selectedFilterYear.value, 01, 0);
      getSummary(selectedFilterYear.value);
    }
  }
}
