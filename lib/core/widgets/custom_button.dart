import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum CustomButtonVariant { primary, success, secondary, outline, ghost }

class CustomButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isExpanded;
  final CustomButtonVariant variant;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? suffixWidget;
  final String? priceText;
  final TextStyle? priceTextStyle;
  final double? height;
  final double? borderRadius;

  const CustomButton({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.isLoading = false,
    this.isExpanded = true,
    this.variant = CustomButtonVariant.primary,
    this.backgroundColor,
    this.foregroundColor,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixWidget,
    this.priceText,
    this.priceTextStyle,
    this.height,
    this.borderRadius,
  }) : assert(
         text != null || child != null,
         'Provide either text or child widget',
       );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveHeight = height ?? (isExpanded ? 48 : 40);
    final effectiveRadius = borderRadius ?? 12;
    final colors = _resolveColors(isDark);
    final buttonStyle = _resolveButtonStyle(
      colors: colors,
      height: effectiveHeight,
      radius: effectiveRadius,
      isDark: isDark,
    );

    Widget buttonContent;
    if (isLoading) {
      buttonContent = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(colors.foreground),
        ),
      );
    } else {
      final baseStyle = TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
        color: colors.foreground,
      );

      final textWidget = text != null
          ? Text(text!, style: baseStyle, textAlign: TextAlign.center)
          : child!;

      if (prefixIcon != null || suffixIcon != null) {
        buttonContent = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if (prefixIcon != null) ...[
              Icon(prefixIcon, size: 20, color: colors.foreground),
              const SizedBox(width: 8),
            ],
            if (isExpanded) Expanded(child: textWidget) else textWidget,
            if (suffixIcon != null) ...[
              const SizedBox(width: 8),
              Icon(suffixIcon, size: 20, color: colors.foreground),
            ],
          ],
        );
      } else {
        buttonContent = textWidget;
      }
    }

    final button = TextButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: buttonContent,
    );

    if (!isExpanded) return button;

    if (suffixWidget != null || priceText != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          button,
          if (priceText != null) ...[
            const SizedBox(height: 8),
            Text(
              priceText!,
              textAlign: TextAlign.end,
              style:
                  priceTextStyle ??
                  TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.white : AppColors.ink,
                    letterSpacing: 0.5,
                  ),
            ),
          ],
          if (suffixWidget != null) ...[
            const SizedBox(height: 4),
            Align(alignment: Alignment.centerRight, child: suffixWidget),
          ],
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      height: effectiveHeight,
      child: button,
    );
  }

  _ButtonColors _resolveColors(bool isDark) {
    if (backgroundColor != null || foregroundColor != null) {
      return _ButtonColors(
        background:
            backgroundColor ??
            (variant == CustomButtonVariant.primary
                ? AppColors.primary
                : Colors.transparent),
        foreground:
            foregroundColor ??
            (variant == CustomButtonVariant.primary
                ? Colors.white
                : (isDark ? AppColors.white : AppColors.ink)),
      );
    }

    switch (variant) {
      case CustomButtonVariant.primary:
        return const _ButtonColors(
          background: AppColors.primary,
          foreground: Colors.white,
        );
      case CustomButtonVariant.success:
        return const _ButtonColors(
          background: AppColors.bgHomeColor,
          foreground: Colors.white,
        );
      case CustomButtonVariant.secondary:
        return const _ButtonColors(
          background: AppColors.accent,
          foreground: Colors.white,
        );
      case CustomButtonVariant.outline:
        return _ButtonColors(
          background: Colors.transparent,
          foreground: isDark ? AppColors.white : AppColors.primary,
        );
      case CustomButtonVariant.ghost:
        return _ButtonColors(
          background: Colors.transparent,
          foreground: isDark ? AppColors.muted : AppColors.grey,
        );
    }
  }

  ButtonStyle _resolveButtonStyle({
    required _ButtonColors colors,
    required double height,
    required double radius,
    required bool isDark,
  }) {
    if (variant == CustomButtonVariant.outline) {
      return TextButton.styleFrom(
        backgroundColor: colors.background,
        foregroundColor: colors.foreground,
        disabledBackgroundColor: isDark
            ? AppColors.dark.withValues(alpha: 0.3)
            : AppColors.grey.withValues(alpha: 0.3),
        disabledForegroundColor: isDark
            ? AppColors.muted
            : AppColors.grey.withValues(alpha: 0.6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(
            color: isDark ? AppColors.muted : AppColors.divider,
            width: 1.2,
          ),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      );
    }

    if (variant == CustomButtonVariant.ghost) {
      return TextButton.styleFrom(
        backgroundColor: colors.background,
        foregroundColor: colors.foreground,
        disabledBackgroundColor: isDark
            ? AppColors.dark.withValues(alpha: 0.1)
            : AppColors.grey.withValues(alpha: 0.1),
        disabledForegroundColor: isDark
            ? AppColors.muted
            : AppColors.grey.withValues(alpha: 0.6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      );
    }

    return TextButton.styleFrom(
      backgroundColor: colors.background,
      foregroundColor: colors.foreground,
      disabledBackgroundColor: isDark
          ? AppColors.dark.withValues(alpha: 0.3)
          : AppColors.grey.withValues(alpha: 0.3),
      disabledForegroundColor: isDark
          ? AppColors.muted
          : AppColors.grey.withValues(alpha: 0.6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
    );
  }
}

class _ButtonColors {
  final Color background;
  final Color foreground;

  const _ButtonColors({required this.background, required this.foreground});
}
