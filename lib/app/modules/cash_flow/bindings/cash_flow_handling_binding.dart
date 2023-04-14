import "package:cash_flow/app/modules/cash_flow/controllers/cash_flow_handling_controller.dart";
import "package:get/get.dart";

class CashFlowHandlingBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(CashFlowHandlingController());
  }
}
