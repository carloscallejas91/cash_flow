import "package:cash_flow/core/values/colors.dart";
import "package:flutter/material.dart";

class CCCategorySession extends StatelessWidget {
  final String label;
  final Color labelColor;
  final String value;
  final Color valueColor;
  final IconData icon;
  final Color iconColor;

  const CCCategorySession({
    Key? key,
    required this.label,
    this.labelColor = onSurface,
    required this.value,
    this.valueColor = onSurface,
    required this.icon,
    this.iconColor = primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: labelColor),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(color: valueColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
