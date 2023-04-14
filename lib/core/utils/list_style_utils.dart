import "package:cash_flow/core/values/colors.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class ListStyleUtils {
  Widget? getCashFlowItemIcon(
    String type,
  ) {
    if (type.compareTo("Despesa") == 0) {
      return const Icon(
        expenseIcon,
        color: error,
      );
    } else if (type.compareTo("Receita") == 0) {
      return const Icon(
        incomeIcon,
        color: success,
      );
    }
    return null;
  }

  Rx<Color> getCashFlowItemStyle(
    String type,
  ) {
    if (type.compareTo("Despesa") == 0) {
      return errorContainer.obs;
    } else if (type.compareTo("Receita") == 0) {
      return successContainer.obs;
    }
    return surface.obs;
  }

  Rx<Color> getCashFlowItemTextColor(
    String type,
  ) {
    if (type.compareTo("Despesa") == 0) {
      return onErrorContainer.obs;
    } else if (type.compareTo("Receita") == 0) {
      return onSuccessContainer.obs;
    }
    return onSurface.obs;
  }
}
