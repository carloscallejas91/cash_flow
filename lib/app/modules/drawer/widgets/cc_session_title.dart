import "package:cash_flow/core/values/colors.dart";
import "package:flutter/material.dart";

class CCSessionTitle extends StatelessWidget {
  final String title;
  final Color? titleColor;

  const CCSessionTitle.primary({
    Key? key,
    required this.title,
    this.titleColor = primary,
  }) : super(key: key);

  const CCSessionTitle.onPrimary({
    Key? key,
    required this.title,
    this.titleColor = onPrimary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          color: titleColor,
        ),
      ),
    );
  }
}
