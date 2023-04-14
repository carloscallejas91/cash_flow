import "package:cash_flow/data/model/cash_flow_model.dart";
import "package:cash_flow/data/providers/database/database_helper.dart";

class CashFlowServices {
  Future<int> addCashFlowItem(CashFlowModel cashFlow) async {
    final Map<String, dynamic> map = cashFlow.toMap();
    return DatabaseHelper.insertCashFlowItem(map);
  }

  Future<int> updateCashFlowItem(
    CashFlowModel cashFlowItem,
    int id,
  ) async {
    final Map<String, dynamic> map = cashFlowItem.toMap();
    final result = await DatabaseHelper.updateCashFlowItem(
      map,
      id,
    );
    return result;
  }

  Future<List<CashFlowModel>> getAllCashFlowItemsByStatus(
    String status,
  ) async {
    final List<Map<String, dynamic>> results =
        await DatabaseHelper.getAllCashFlowItemsByStatus(
      status,
    );
    return results.map((item) => CashFlowModel.fromJson(item)).toList();
  }

  Future<List<CashFlowModel>> getAllInRangeCashFlowItemsByStatus(
      String startDate,
      String endDate,
      String status,
      ) async {
    final List<Map<String, dynamic>> results =
    await DatabaseHelper.getAllInRangeCashFlowItemsByStatus(
      startDate,
      endDate,
      status,
    );
    return results.map((item) => CashFlowModel.fromJson(item)).toList();
  }

  Future<List<CashFlowModel>> getAllInRangeCashFlowItems(
    String startDate,
    String endDate,
    String type,
  ) async {
    final List<Map<String, dynamic>> results =
        await DatabaseHelper.getAllInRangeCashFlowItems(
      startDate,
      endDate,
      type,
    );
    return results.map((item) => CashFlowModel.fromJson(item)).toList();
  }

  Future<List<CashFlowModel>> getAllSettledInRangeCashFlowItems(
    String startDate,
    String endDate,
    String type,
  ) async {
    final List<Map<String, dynamic>> results =
        await DatabaseHelper.getAllSettledInRangeCashFlowItems(
      startDate,
      endDate,
      type,
    );
    return results.map((item) => CashFlowModel.fromJson(item)).toList();
  }

  Future<List<CashFlowModel>> getAllUnsettledInRangeCashFlowItems(
    String startDate,
    String endDate,
    String type,
  ) async {
    final List<Map<String, dynamic>> results =
        await DatabaseHelper.getAllUnsettledInRangeCashFlowItems(
      startDate,
      endDate,
      type,
    );
    return results.map((item) => CashFlowModel.fromJson(item)).toList();
  }

  Future<int> deleteCashFlowItem(int id) async {
    final int result = await DatabaseHelper.deleteCashFlowItem(id);
    return result;
  }

  Future<int> deleteCashFlowTab() async {
    final int result = await DatabaseHelper.deleteAllCashFlow();
    return result;
  }
}
