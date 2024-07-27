
import 'package:flutter/material.dart';

class GhostButton extends StatelessWidget {
  /// Default values:
  ///
  /// radius = 30
  ///
  /// elevation = 0
  ///
  /// backgroundColor = context.colors.ghostButtonBackground
  ///
  /// hoverColor = context.colors.ghostButtonHoverBackground
  ///
  /// style = context.textTheme.labelMedium?.copyWith(
  ///   fontSize: 16,
  ///   color: context.colors.ghostButtonText,
  ///  ),
  ///
  /// hoverElevation = 0
  ///
  /// highlightElevation = 0
  ///
  /// splashColor = context.colors.ghostButtonSplashBackground
  ///
  /// pressedColor = context.colors.ghostButtonClickedBackground
  ///
  /// horizontalPadding = 24
  ///
  /// verticalPadding = 16

  const GhostButton({
    required this.onPressed,
    required this.text,
    this.radius = 30,
    this.style,
    this.elevation = 0,
    this.backgroundColor,
    this.hoverColor,
    this.highlightElevation = 0,
    this.hoverElevation = 0,
    this.splashColor,
    this.pressedColor,
    this.horizontalPadding = 24,
    this.verticalPadding = 16,
    this.width,
    this.isStretched,
    super.key,
  });

  final VoidCallback? onPressed;
  final String text;
  final double? radius;
  final TextStyle? style;
  final double? elevation;
  final Color? backgroundColor;
  final Color? hoverColor;
  final double? highlightElevation;
  final double? hoverElevation;
  final Color? splashColor;
  final Color? pressedColor;
  final double horizontalPadding;
  final double verticalPadding;
  final double? width;
  final bool? isStretched;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      highlightElevation: highlightElevation,
      hoverElevation: hoverElevation,
      hoverColor: hoverColor ,
      color: backgroundColor ,
      highlightColor:
      pressedColor,
      splashColor: splashColor,
      onPressed: onPressed,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius!),
      ),
      minWidth: isStretched ?? false ? double.infinity : width,
      elevation: elevation,
      child: Text(
        text,
        style: style??const TextStyle(color: Colors.black)
      ),
    );
  }
}
