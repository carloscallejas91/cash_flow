import "package:cash_flow/app/modules/cash_flow/controllers/cash_flow_update_controller.dart";
import "package:get/get.dart";

class CashFlowUpdateBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(CashFlowUpdateController());
  }
}
