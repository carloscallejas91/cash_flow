import "package:cash_flow/app/modules/cash_flow/controllers/cash_flow_controller.dart";
import "package:get/get.dart";

class CashFlowBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(CashFlowController());
  }
}
