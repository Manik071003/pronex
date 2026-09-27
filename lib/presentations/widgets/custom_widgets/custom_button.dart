import 'package:flutter/material.dart';
import '../../../../../core/constants/constant_imports.dart';
import '../../../../core/enums/response_state_enum.dart';

class CustomButton extends StatelessWidget {
  final ResponseState? state;
  final Color borderColor;
  final double borderRadius;
  final double borderWidth;
  final Color btnColor;
  final Gradient? gradient;
  final bool isEnabled;
  final bool isExpanded;
  final Color lblColor;
  final VoidCallback? onTap;
  final String label;
  final TextStyle? style;
  final double? height;
  final double? width;
  final double paddingHorizontal;
  final double paddingVertical;
  final IconData? icon;
  final Widget? iconWidget;

  const CustomButton({
    super.key,
    this.state = ResponseState.empty,
    this.borderColor = ColorConstants.transparent,
    this.borderRadius = Dimensions.px30,
    this.borderWidth = Dimensions.px1,
    this.btnColor = ColorConstants.primaryAppColor,
    this.gradient, // NEW
    this.height = Dimensions.px50,
    this.width,
    this.icon,
    this.iconWidget,
    this.isEnabled = true,
    this.isExpanded = false,
    this.lblColor = ColorConstants.white,
    this.label = '',
    this.onTap,
    this.style,
    this.paddingHorizontal = Dimensions.px10,
    this.paddingVertical = Dimensions.px10,
    Function()? onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (state == ResponseState.loading) {
      return const Center(
        child: CircularProgressIndicator(color: ColorConstants.primaryAppColor),
      );
    } else {
      return GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: Container(
          height: height,
          width: width ?? double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontal,
            vertical: paddingVertical,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: isEnabled ? borderColor : ColorConstants.alto,
              width: borderWidth,
            ),
            color: (gradient == null && isEnabled) ? btnColor : null,
            gradient: (isEnabled && gradient != null) ? gradient : null,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: (icon != null)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: ColorConstants.white,
                      size: Dimensions.px25,
                    ),
                    isExpanded
                        ? Expanded(child: _buildTextPart())
                        : _buildTextPart(),
                  ],
                )
              : (iconWidget != null)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    iconWidget!,
                    isExpanded
                        ? Expanded(child: _buildTextPart())
                        : _buildTextPart(),
                  ],
                )
              : isExpanded
              ? Expanded(child: _buildTextPart())
              : _buildTextPart(),
        ),
      );
    }
  }

  Widget _buildTextPart() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px10,
        vertical: Dimensions.px0,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style:
            style ??
                AppTextStyles.mediumText(
                  color: lblColor,
                  fontSize: Dimensions.px16,
                ),
      ),
    );
  }
}
