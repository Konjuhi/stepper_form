import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  /// Default values:
  ///
  /// radius = 30
  ///
  /// height = 45.0
  ///
  /// elevation = 0
  ///
  /// backgroundColor = context.colors.buttonBackground
  ///
  /// hoverColor = context.colors.buttonHoverBackground
  ///
  /// disabledColor = context.colors.buttonBackground.withOpacity(0.2)
  ///
  /// splashColor = context.colors.buttonSplashBackground
  ///
  /// pressedColor = context.colors.buttonClickedBackground
  ///
  /// style = context.textTheme.displayMedium
  ///
  /// hoverElevation = 0
  ///
  /// highlightElevation = 0
  ///
  /// horizontalPadding = 24
  ///
  /// verticalPadding = 16

  const AppButton({
    required this.onPressed,
    required this.text,
    this.radius = 30,
    this.height = 45.0,
    this.width,
    this.style,
    this.elevation = 0,
    super.key,
    this.backgroundColor,
    this.hoverColor,
    this.disabledColor,
    this.pressedColor,
    this.splashColor,
    this.highlightElevation = 0,
    this.hoverElevation = 0,
    this.horizontalPadding = 24,
    this.verticalPadding = 16,
    this.isStretched,
  });

  final VoidCallback? onPressed;
  final String text;
  final double? radius;
  final TextStyle? style;
  final double? elevation;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final Color? hoverColor;
  final Color? disabledColor;
  final Color? pressedColor;
  final Color? splashColor;
  final double? highlightElevation;
  final double? hoverElevation;
  final double horizontalPadding;
  final double verticalPadding;
  final bool? isStretched;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      hoverElevation: hoverElevation,
      highlightElevation: highlightElevation,
      hoverColor: hoverColor ?? Colors.grey,
      color: backgroundColor ?? Colors.purple,
      disabledColor: disabledColor ?? Colors.purple.withOpacity(0.2),
      highlightColor: pressedColor ?? Colors.purple,
      splashColor: splashColor ?? Colors.transparent,
      onPressed: onPressed,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius!),
      ),
      elevation: elevation,
      minWidth: isStretched ?? false ? double.infinity : width,
      height: height,
      child: Text(text, style: style),
    );
  }
}
