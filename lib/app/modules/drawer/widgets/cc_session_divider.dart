import "package:cash_flow/core/values/colors.dart";
import "package:flutter/material.dart";

class CCSessionDivider extends StatelessWidget {
  final Color? dividerColor;

  const CCSessionDivider({
    Key? key,
    this.dividerColor = outline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(color: dividerColor),
        const SizedBox(height: 8),
      ],
    );
  }
}
