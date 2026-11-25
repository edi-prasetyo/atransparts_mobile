import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum CustomFieldVariant { filled, outline, underline }

class CustomField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextCapitalization capitalization;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? suffix;
  final CustomFieldVariant variant;
  final bool showCounter;
  final bool dense;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;

  const CustomField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.capitalization = TextCapitalization.none,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.suffix,
    this.variant = CustomFieldVariant.filled,
    this.showCounter = false,
    this.dense = false,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
  });

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  late bool _obscure;
  late FocusNode _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
    _internalFocusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  void _toggleObscure() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveFillColor = widget.fillColor ??
        (widget.variant == CustomFieldVariant.filled
            ? (isDark ? AppColors.cardDark : AppColors.surface)
            : Colors.transparent);
    final effectiveBorderColor = widget.borderColor ??
        (isDark ? AppColors.muted.withValues(alpha: 0.3) : AppColors.divider);
    final effectiveFocusedBorderColor = widget.focusedBorderColor ??
        AppColors.primary;

    final textStyle = TextStyle(
      fontSize: widget.dense ? 13 : 14,
      color: widget.enabled
          ? (isDark ? AppColors.white : AppColors.ink)
          : (isDark ? AppColors.muted : AppColors.grey),
    );

    final labelStyle = TextStyle(
      fontSize: widget.dense ? 12 : 13,
      fontWeight: FontWeight.w600,
      color: widget.enabled
          ? (isDark ? AppColors.muted : AppColors.grey)
          : AppColors.grey,
    );

    final hintStyle = TextStyle(
      fontSize: widget.dense ? 13 : 14,
      color: widget.enabled
          ? (isDark ? AppColors.muted.withValues(alpha: 0.6) : AppColors.grey)
          : AppColors.grey.withValues(alpha: 0.5),
    );

    final effectiveSuffixIcon = _buildSuffixIcon(isDark);
    final effectivePrefixIcon = _buildPrefixIcon();

    final decoration = InputDecoration(
      labelText: widget.label,
      hintText: widget.hint,
      helperText: widget.helperText,
      errorText: widget.errorText,
      filled: widget.variant != CustomFieldVariant.outline,
      fillColor: effectiveFillColor,
      labelStyle: labelStyle,
      hintStyle: hintStyle,
      helperStyle: TextStyle(
        fontSize: 11,
        color: isDark ? AppColors.muted.withValues(alpha: 0.7) : AppColors.grey,
      ),
      errorStyle: const TextStyle(fontSize: 12),
      prefixIcon: effectivePrefixIcon,
      suffixIcon: effectiveSuffixIcon,
      suffix: widget.suffix,
      contentPadding: EdgeInsets.symmetric(
        horizontal: widget.prefixIcon == null && widget.suffixIcon == null
            ? 16
            : 12,
        vertical: widget.dense ? 12 : 16,
      ),
      counterText: widget.showCounter ? null : '',
      border: _buildOutlineBorder(
        radius: 12,
        borderSide: BorderSide(color: effectiveBorderColor),
      ),
      enabledBorder: _buildOutlineBorder(
        radius: 12,
        borderSide: BorderSide(color: effectiveBorderColor),
      ),
      focusedBorder: _buildOutlineBorder(
        radius: 12,
        borderSide: BorderSide(color: effectiveFocusedBorderColor, width: 1.5),
      ),
      errorBorder: _buildOutlineBorder(
        radius: 12,
        borderSide: const BorderSide(color: AppColors.danger),
      ),
      focusedErrorBorder: _buildOutlineBorder(
        radius: 12,
        borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
      ),
    );

    final textField = TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode ?? _internalFocusNode,
      keyboardType: widget.keyboardType,
      obscureText: _obscure,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      textCapitalization: widget.capitalization,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.enabled ? widget.validator : null,
      style: textStyle,
      decoration: decoration,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textField,
        if (widget.errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText!,
            style: const TextStyle(fontSize: 12, color: AppColors.danger),
          ),
        ],
        if (widget.helperText != null && widget.errorText == null) ...[
          const SizedBox(height: 4),
          Text(
            widget.helperText!,
            style: TextStyle(
              fontSize: 11,
              color: isDark
                  ? AppColors.muted.withValues(alpha: 0.7)
                  : AppColors.grey,
            ),
          ),
        ],
      ],
    );
  }

  Widget? _buildSuffixIcon(bool isDark) {
    if (widget.obscureText) {
      return IconButton(
        onPressed: _toggleObscure,
        icon: Icon(
          _obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
          size: 20,
          color: isDark ? AppColors.muted : AppColors.grey,
        ),
      );
    }
    if (widget.suffixIcon != null) {
      return widget.suffixIcon;
    }
    return null;
  }

  Widget? _buildPrefixIcon() {
    if (widget.prefixIcon != null) {
      return widget.prefixIcon;
    }
    return null;
  }

  OutlineInputBorder _buildOutlineBorder({
    required double radius,
    required BorderSide borderSide,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: borderSide,
    );
  }
}
