import 'package:flutter/material.dart';
import 'package:flutter_live_shopping/config/theme_config.dart';

enum BadgeType { orange, blue, teal, gray, red, outlined }

class AppBadge extends StatelessWidget {
  final String text;
  final BadgeType type;
  final Widget? icon;

  const AppBadge({
    super.key,
    required this.text,
    this.type = BadgeType.gray,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    Border? border;

    switch (type) {
      case BadgeType.orange:
        backgroundColor = AppColors.primary;
        textColor = AppColors.white;
        break;
      case BadgeType.blue:
        backgroundColor = AppColors.secondary;
        textColor = AppColors.white;
        break;
      case BadgeType.teal:
        backgroundColor = AppColors.accent;
        textColor = AppColors.white;
        break;
      case BadgeType.gray:
        backgroundColor = AppColors.gray100;
        textColor = AppColors.gray800;
        break;
      case BadgeType.red:
        backgroundColor = AppColors.error;
        textColor = AppColors.white;
        break;
      case BadgeType.outlined:
        backgroundColor = Colors.transparent;
        textColor = AppColors.gray600;
        border = Border.all(color: AppColors.gray300);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: border,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 4)],
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 11,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
