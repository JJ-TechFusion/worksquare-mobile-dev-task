import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dreamdwell/core/shared/widgets/custom_text.dart';
import 'package:dreamdwell/core/theme/app_colors.dart';

class TextInputField extends StatelessWidget {
  final String hintText;
  final void Function(String value)? onChanged;
  final String? errorText;
  final bool? obscureText, isReadOnly;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final String? Function(String?)? validator;
  final double? width;
  final Widget? suffixIcon, prefixIcon;
  final FocusNode? focusNode;
  final Color? borderColor, fillColor, labelColor;
  final Function()? onTap, onEditingDone;
  final int? maxLines;
  final String? label;
  final bool? fullBorder;
  final List<TextInputFormatter>? customInputFormatters;

  const TextInputField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.errorText,
    this.controller,
    this.obscureText,
    this.validator,
    this.inputType,
    this.width,
    this.suffixIcon,
    this.focusNode,
    this.borderColor,
    this.inputAction,
    this.prefixIcon,
    this.fillColor,
    this.labelColor,
    this.isReadOnly,
    this.onTap,
    this.onEditingDone,
    this.maxLines,
    this.label,
    this.fullBorder = true,
    this.customInputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null && label!.isNotEmpty) ...[
          ResponsiveText(
            label ?? '',
            fontWeight: FontWeight.w500,
            baseSize: TextSizes.bodySmall,
            color: AppColor.upholdGrey2,
          ),
        ],
        TextFormField(
          maxLines: maxLines ?? 1,
          readOnly: isReadOnly ?? false,
          onTap: onTap,
          onChanged: onChanged,
          onEditingComplete: onEditingDone,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          obscureText: obscureText ?? false,
          controller: controller,
          decoration: InputDecoration(
            filled: false,
            enabledBorder: _fieldBorder(
              AppColor.upholdGrey.withAlpha(90),
              fullBorder ?? true,
            ),
            focusedBorder: _fieldBorder(AppColor.primary, fullBorder ?? true),
            errorBorder: _fieldBorder(AppColor.errorColor, fullBorder ?? true),
            focusedErrorBorder: _fieldBorder(
              AppColor.errorColor,
              fullBorder ?? true,
            ),
            hintText: hintText,
            suffixIcon: suffixIcon,
            helperText: ' ',
            prefixIcon: prefixIcon,
            hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 14,
              color: AppColor.hintTextColor.withValues(alpha: 0.7),
              fontWeight: FontWeight.w400,
              fontFamily: GoogleFonts.nunito().fontFamily,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          ),
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: inputType,
          textInputAction: inputAction,
          inputFormatters: customInputFormatters,
        ),
      ],
    );
  }
}

InputBorder _fieldBorder(Color borderColor, bool fullBorder) =>
    fullBorder
        ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor),
        )
        : UnderlineInputBorder(borderSide: BorderSide(color: borderColor));
