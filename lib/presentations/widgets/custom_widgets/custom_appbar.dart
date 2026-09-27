import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dimension_constants.dart';
import '../../../core/constants/icon_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  final bool centerTitle;
  final bool isBack;
  final Widget? action;
  final bool isAction;

  final TextStyle? style;
  final VoidCallback? onTap;
  final double? appBarSize;

  const CustomAppBar({
    super.key,
    required this.title,
    this.centerTitle = false,
    this.isBack = true,
    this.isAction = false,
    this.action,
    this.onTap,
    this.style,
    this.appBarSize = Dimensions.px60,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.px16),
        child: AppBar(
          scrolledUnderElevation: Dimensions.px0,
          elevation: Dimensions.px0,
          leadingWidth: Dimensions.px50,
          centerTitle: centerTitle,
          automaticallyImplyLeading: false,
          backgroundColor: ColorConstants.transparent,
          leading: isBack
              ? GestureDetector(
                  onTap: onTap ?? () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.px8),
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorConstants.primaryAppColor),
                      borderRadius: BorderRadius.circular(Dimensions.px12),
                    ),
                    child: SvgPicture.asset(
                      IconConstants.backArrow,
                      width: Dimensions.px16,
                      height: Dimensions.px16,
                      colorFilter: const ColorFilter.mode(
                        ColorConstants.primaryAppColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                )
              : null,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: centerTitle
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style:
                    style ??
                    AppTextStyles.regularText(
                      fontSize: Dimensions.px18,
                      color: ColorConstants.black,
                    ),
              ),
            ],
          ),
          actions: [
            if (isAction)
              action ??
                  Container(
                    height: Dimensions.px45,
                    width: Dimensions.px45,
                    margin: const EdgeInsets.only(
                      top: Dimensions.px4,
                      bottom: Dimensions.px4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorConstants.alto),
                      borderRadius: BorderRadius.circular(Dimensions.px10),
                    ),
                    child: Center(
                      child: SvgPicture.asset(IconConstants.profileIconMain),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarSize!);
}
