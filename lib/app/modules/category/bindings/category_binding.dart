import "package:cash_flow/app/modules/category/controllers/category_controller.dart";
import "package:cash_flow/core/utils/keyboard_controller_utils.dart";
import "package:get/get.dart";

class CategoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(KeyboardController());
    Get.put(CategoryController());
  }
}
