import "package:cash_flow/core/values/colors.dart";
import "package:flutter/material.dart";

class CCListTileSecondary extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final IconData? icon;
  final Color? iconColor;
  final Color? selectedContainerColor;
  final Color? titleSelectedColor;
  final Color? iconSelectedColor;
  final bool? isSelected;
  final Function() onPressed;

  const CCListTileSecondary.onPrimaryContainer({
    Key? key,
    required this.title,
    this.titleColor = onPrimaryContainer,
    this.icon,
    this.iconColor = primary,
    this.selectedContainerColor = primary,
    this.titleSelectedColor = onPrimary,
    this.iconSelectedColor = tertiary,
    this.isSelected = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // contentPadding: const EdgeInsets.symmetric(horizontal: 32),
      dense: true,
      leading: icon != null
          ? Icon(
              icon,
              size: 16,
              color: isSelected! ? iconSelectedColor : iconColor,
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          color: isSelected! ? titleSelectedColor : titleColor,
        ),
      ),
      selected: isSelected!,
      selectedTileColor: selectedContainerColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      visualDensity: VisualDensity.compact,
      onTap: onPressed,
    );
  }
}
