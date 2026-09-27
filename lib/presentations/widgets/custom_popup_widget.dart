import 'package:flutter/material.dart';
import '../../core/constants/app_text_style.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';

class CustomPopupWidget extends StatelessWidget {
  final List menuList;
  final Widget child;
  final double? height;

  final Function(int) onTap;

  const CustomPopupWidget({
    super.key,
    required this.menuList,
    this.height,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: (value) {
        onTap(value);
      },
      constraints: BoxConstraints.tight(
        Size(double.infinity, height ?? Dimensions.px120),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.px16),
        side: const BorderSide(
          width: Dimensions.px1,
          color: ColorConstants.gallery,
        ),
      ),
      itemBuilder: (context) => List.generate(menuList.length, (index) {
        return PopupMenuItem(
          value: index,
          child: Text(
            menuList[index],
            style: AppTextStyles.regularText(
              color: ColorConstants.ebony,
              fontSize: Dimensions.px16,
            ),
          ),
        );
      }),
      offset: const Offset(0, 65),
      color: ColorConstants.white,
      elevation: Dimensions.px0,
      child: child,
    );
  }
}
