import "package:cash_flow/core/values/colors.dart";
import "package:flutter/material.dart";

class CCLabelValue extends StatelessWidget {
  final String label;
  final Color labelColor;
  final String value;
  final Color valueColor;

  const CCLabelValue({
    Key? key,
    required this.label,
    this.labelColor = onSurface,
    required this.value,
    this.valueColor = onSurface,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
