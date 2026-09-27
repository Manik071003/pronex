import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/dimension_constants.dart';
import '../../../core/constants/icon_constants.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color color;
  final double size;
  final EdgeInsetsGeometry padding;

  const AppBackButton({
    super.key,
    this.onTap,
    this.color = Colors.black,
    this.size = 24,
    this.padding = const EdgeInsets.all(Dimensions.px8),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => Navigator.of(context).pop(),
      borderRadius: BorderRadius.circular(Dimensions.px20),
      child: Padding(
        padding: padding,
        child: SvgPicture.asset(
          IconConstants.backArrow,
          width: size,
          height: size,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
      ),
    );
  }
}
