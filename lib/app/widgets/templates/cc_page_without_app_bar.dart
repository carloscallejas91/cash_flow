import "package:cash_flow/core/values/colors.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:flutter/material.dart";

class CCPageWithoutAppBar extends StatelessWidget {
  final bool? hasScroll;
  final Alignment? containerAlignment;
  final CrossAxisAlignment? horizontalAlignment;
  final MainAxisAlignment? verticalAlignment;
  final MainAxisSize mainAxisSize;
  final String? backgroundImage;
  final Color? backgroundColor;
  final List<Widget> widgets;

  const CCPageWithoutAppBar({
    Key? key,
    this.hasScroll = true,
    this.containerAlignment = Alignment.topLeft,
    this.horizontalAlignment = CrossAxisAlignment.start,
    this.verticalAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.backgroundImage,
    this.backgroundColor = Colors.transparent,
    required this.widgets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: defaultPaddingBody,
        alignment: containerAlignment,
        decoration: BoxDecoration(
          color: backgroundColor,
          image: backgroundImage != null
              ? DecorationImage(
                  image: AssetImage(backgroundImage!),
                  fit: BoxFit.cover,
                  colorFilter: const ColorFilter.mode(
                    primaryContainer,
                    BlendMode.colorBurn,
                  ),
                )
              : null,
        ),
        child: SafeArea(
          child: hasScroll!
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: horizontalAlignment!,
                    mainAxisAlignment: verticalAlignment!,
                    mainAxisSize: mainAxisSize,
                    children: widgets,
                  ),
                )
              : widgets.length > 1
                  ? Column(
                      crossAxisAlignment: horizontalAlignment!,
                      mainAxisAlignment: verticalAlignment!,
                      mainAxisSize: mainAxisSize,
                      children: widgets,
                    )
                  : widgets[0],
        ),
      ),
    );
  }
}
