import "package:cash_flow/app/widgets/button/cc_icon_button.dart";
import "package:cash_flow/core/values/colors.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:flutter/material.dart";

class CCRowLabelButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final Function onPressed;

  const CCRowLabelButton({
    Key? key,
    required this.label,
    this.icon = arrowRightIcon,
    this.iconColor = primary,
    this.iconSize = 16,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        CCIconButton(
          icon: icon,
          iconColor: iconColor,
          iconSize: iconSize,
          onPressed: () => onPressed,
        ),
      ],
    );
  }
}
