import "package:cash_flow/app/modules/color_palette/controllers/color_palette_controller.dart";
import "package:get/get.dart";

class ColorPaletteBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ColorPaletteController());
  }
}
