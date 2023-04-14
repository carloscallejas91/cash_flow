import "package:cash_flow/app/modules/cash_flow/controllers/cash_flow_summary_controller.dart";
import "package:get/get.dart";

class CashFlowSummaryBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(CashFlowSummaryController());
  }
}
