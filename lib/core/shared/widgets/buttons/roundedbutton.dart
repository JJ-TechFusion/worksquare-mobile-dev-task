import 'package:flutter/material.dart';
import 'package:dreamdwell/core/shared/widgets/custom_text.dart';
import 'package:dreamdwell/core/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final double? size;
  final Function()? onTap;
  final Color? color, textColor;
  final Color? borderColor;
  final double? borderRadius;
  final IconData? icon;
  final double? iconSize;

  const CustomButton({
    super.key,
    required this.title,
    this.onTap,
    this.size,
    this.color,
    this.borderColor,
    this.textColor,
    this.borderRadius,
    this.icon,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 11),
          color: color ?? AppColor.primary,
          border:
              borderColor != null
                  ? Border.all(width: 1, color: borderColor!)
                  : null,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 7,
            children: [
              ResponsiveText(
                title,
                textAlign: TextAlign.center,
                color: textColor ?? Colors.white,
                fontWeight: FontWeight.w500,
                baseSize: size ?? 18,
              ),
              if (icon != null)
                Icon(
                  icon,
                  color: textColor ?? Colors.white,
                  size: iconSize ?? 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
