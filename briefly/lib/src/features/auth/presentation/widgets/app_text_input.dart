import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_util.dart';

/// Design-system text input with validation, password toggle, and icon support.
class AppTextInput extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool showPasswordToggle;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final int? maxLines;
  final String? errorText;

  const AppTextInput({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.maxLines = 1,
    this.errorText,
  });

  @override
  State<AppTextInput> createState() => _AppTextInputState();
}

class _AppTextInputState extends State<AppTextInput> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          obscureText: _obscured,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          style: AppTextStyles.inputText(context),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.scaleFontSize(14),
              fontWeight: FontWeight.w400,
              color: AppColors.silverPlaceholder,
            ),
            labelText: widget.labelText,
            labelStyle: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.scaleFontSize(14),
              color: AppColors.silverSecondaryLabel,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: AppColors.silverPlaceholder,
                    size: 20,
                  )
                : null,
            suffixIcon: _buildSuffix(),
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.scaleWidth(24),
              vertical: context.scaleHeight(16),
            ),
            // Border Styling
            border: OutlineInputBorder(
              borderRadius: AppRadius.button,
              borderSide: BorderSide(
                color: AppColors.silverBorder,
                width: AppRadius.buttonValue,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.button,
              borderSide: BorderSide(
                color: AppColors.silverBorder,
                width: AppRadius.buttonValue,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.button,
              borderSide: const BorderSide(
                color: AppColors.primaryAccent,
                width: AppRadius.buttonValue,
              ),
            ),
            // Error Styling
            errorText: widget.errorText,
            errorStyle: const TextStyle(height: 0, fontSize: 0),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.button,
              borderSide: const BorderSide(
                color: AppColors.destructive,
                width: AppRadius.buttonValue,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.button,
              borderSide: const BorderSide(
                color: AppColors.destructive,
                width: 1.5,
              ),
            ),
          ),
        ),
        if (widget.errorText != null && widget.errorText!.isNotEmpty) ...[
          SizedBox(height: context.scaleHeight(8)),
          Padding(
            padding: EdgeInsets.only(left: context.scaleWidth(12)),
            child: Text(widget.errorText!, style: AppTextStyles.error(context)),
          ),
        ],
      ],
    );
  }

  Widget? _buildSuffix() {
    if (widget.showPasswordToggle) {
      return IconButton(
        icon: Icon(
          _obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: _obscured ? AppColors.silverPlaceholder : AppColors.foreground,
          size: 22,
        ),
        onPressed: () => setState(() => _obscured = !_obscured),
      );
    }
    return widget.suffixIcon;
  }
}
