import 'package:flutter/material.dart';
import 'package:flutter_live_shopping/config/theme_config.dart';

enum ButtonVariant { primary, secondary, ghost }

enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    // Size config
    final double height;
    final EdgeInsets padding;
    final double fontSize;
    final double iconSize;

    switch (size) {
      case ButtonSize.small:
        height = 36;
        padding = const EdgeInsets.symmetric(horizontal: 16);
        fontSize = 14;
        iconSize = 16;
        break;
      case ButtonSize.medium:
        height = 44;
        padding = const EdgeInsets.symmetric(horizontal: 24);
        fontSize = 16;
        iconSize = 20;
        break;
      case ButtonSize.large:
        height = 52;
        padding = const EdgeInsets.symmetric(horizontal: 32);
        fontSize = 18;
        iconSize = 24;
        break;
    }

    // specific styles handled manually to match design system exactly
    // vs relying completely on Theme defaults which might be too generic
    Color backgroundColor;
    Color foregroundColor;
    BorderSide borderSide = BorderSide.none;
    double? elevation;

    switch (variant) {
      case ButtonVariant.primary:
        backgroundColor = AppColors.primary;
        foregroundColor = AppColors.white;
        elevation =
            0; // Design system says small shadow, but implementing basic flat first
        break;
      case ButtonVariant.secondary:
        backgroundColor = Colors.transparent;
        foregroundColor = AppColors.primary;
        borderSide = const BorderSide(color: AppColors.primary, width: 2);
        elevation = 0;
        break;
      case ButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = AppColors.gray800;
        elevation = 0;
        break;
    }

    if (onPressed == null) {
      backgroundColor = AppColors.gray100;
      foregroundColor = AppColors.gray400;
      borderSide = BorderSide.none;
    }

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      padding: padding,
      minimumSize: Size(fullWidth ? double.infinity : 0, height),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: borderSide,
      ),
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
    );

    return SizedBox(
      height: height,
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: iconSize,
                width: iconSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: foregroundColor,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: iconSize),
                    const SizedBox(width: 8),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }
}

// Extension to help avoid duplicate "onPressed" parameter in constructor call if not careful,
// but here using standard ElevatedButton.
