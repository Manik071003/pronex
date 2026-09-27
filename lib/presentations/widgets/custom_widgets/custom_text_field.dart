import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dimension_constants.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? labelAbove;
  final bool isObscureText;
  final bool? readOnly;
  final TextInputType textInputType;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final OutlineInputBorder? enabledBorder;
  final Widget? suffixIcon;
  final int? maxlines;
  final int? maxLength; // ✅ ADDED
  final Widget? prefixIcon;
  final Color? fillColor;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    this.controller,
    this.maxlines,
    this.maxLength,
    this.label,
    this.labelAbove,
    this.readOnly,
    this.textInputType = TextInputType.text,
    this.isObscureText = false,
    this.hintText,
    this.inputFormatters,
    this.hintTextStyle,
    this.enabledBorder,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.fillColor,
    this.onTap,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isShowPassword;

  @override
  void initState() {
    super.initState();
    _isShowPassword = widget.isObscureText;
  }

  void _showHidePasswordIconTapped() {
    setState(() {
      _isShowPassword = !_isShowPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelAbove != null && widget.labelAbove!.isNotEmpty) ...[
          Text(
            widget.labelAbove!,
            style: AppTextStyles.regularText(
              fontSize: Dimensions.px14,
              fontWeight: FontWeight.w600,
              color: ColorConstants.darkGrey,
            ),
          ),
          const SizedBox(height: 6), // spacing between heading and field
        ],
        TextFormField(
          onTap: widget.onTap,
          readOnly: widget.readOnly ?? false,
          obscureText: _isShowPassword,
          onChanged: widget.onChanged,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          controller: widget.controller,
          keyboardType: widget.textInputType,
          maxLines: widget.maxlines ?? 1,
          maxLength: widget.maxLength, // ✅ ADDED

          decoration: InputDecoration(
            counterText: "", // ✅ hides default counter UI

            filled: true,
            fillColor: widget.fillColor ?? Colors.white,

            prefixIcon: widget.prefixIcon,
            suffixIcon: _getSuffixWidget(),

            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: widget.label,
            hintText: widget.hintText,

            hintStyle: widget.hintTextStyle ??
                AppTextStyles.regularText(fontSize: Dimensions.px12),

            labelStyle:
            AppTextStyles.regularText(fontSize: Dimensions.px12),

            enabledBorder: widget.enabledBorder ??
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(Dimensions.px10),
                  borderSide: const BorderSide(
                    width: 0.5,
                    color: ColorConstants.grey,
                  ),
                ),

            focusedBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(Dimensions.px10),
              borderSide: BorderSide(
                width: 1,
                color: ColorConstants.secondaryColor,
              ),
            ),

            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(Dimensions.px10),
              borderSide: const BorderSide(
                width: 0.5,
                color: ColorConstants.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget? _getSuffixWidget() {
    if (widget.isObscureText) {
      return GestureDetector(
        onTap: _showHidePasswordIconTapped,
        child: Icon(
          _isShowPassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: ColorConstants.secondaryColor,
        ),
      );
    }
    return widget.suffixIcon;
  }
}