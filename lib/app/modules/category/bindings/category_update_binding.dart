import "package:cash_flow/app/modules/category/controllers/category_update_controller.dart";
import "package:get/get.dart";

class CategoryUpdateBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(CategoryUpdateController());
  }
}
