import "package:cash_flow/core/values/colors.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:flutter/material.dart";

class CCResultNotFound extends StatelessWidget {
  final String text;
  final Color textColor;
  final IconData icon;
  final Color iconColor;

  const CCResultNotFound({
    Key? key,
    this.text = "Nenhum resultado encontrado!",
    this.textColor = onSurface,
    this.icon = warningIcon,
    this.iconColor = onSurface,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: const BoxDecoration(
        color: surfaceVariant,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
          ),
          Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ],
      ),
    );
  }
}
