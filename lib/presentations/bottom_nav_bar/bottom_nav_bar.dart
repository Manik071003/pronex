import 'package:flutter/material.dart';
import '../../core/constants/app_text_style.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../core/utils/base_view.dart';
import 'bottom_nav_bar_view_model.dart';

class BottomNavBarView extends StatelessWidget {
  const BottomNavBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView.reactive(
      viewModelBuilder: () => BottomNavBarVM(),
      builder: (_, vm, __) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        return SafeArea(
          child: Scaffold(
            backgroundColor: ColorConstants.white,
            extendBody: true,
            body: vm.navItems.isEmpty
                ? const SizedBox.shrink()
                : vm.navItems[vm.index].screenBuilder(),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.04,
                right: screenWidth * 0.04,
                bottom: screenHeight * 0.015,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.px10,
                  horizontal: Dimensions.px8,
                ),
                decoration: BoxDecoration(
                  color: ColorConstants.white,
                  borderRadius: BorderRadius.circular(Dimensions.px32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: Dimensions.px16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: Dimensions.px60,
                  child: Row(
                    children: List.generate(vm.navItems.length, (i) {
                      final item = vm.navItems[i];
                      final isSelected = vm.index == i;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () => vm.navigate(i),
                          behavior: HitTestBehavior.opaque,
                          child: Center(
                            child: isSelected
                                ? _buildSelectedItem(item)
                                : _buildUnselectedItem(item),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedItem(NavItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px12,
        vertical: Dimensions.px8,
      ),
      decoration: BoxDecoration(
        color: ColorConstants.pronexPrimary,
        borderRadius: BorderRadius.circular(Dimensions.px20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.selectedIcon,
            color: ColorConstants.white,
            size: Dimensions.px20,
          ),
          const SizedBox(width: Dimensions.px2),
          Text(
            item.label,
            style: AppTextStyles.semiBoldText(
              fontSize: Dimensions.px8,
              color: ColorConstants.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnselectedItem(NavItem item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          item.unselectedIcon,
          color: ColorConstants.pronexTextGrey,
          size: Dimensions.px20,
        ),
        const SizedBox(height: Dimensions.px2),
        Text(
          item.label,
          style: AppTextStyles.regularText(
            fontSize: Dimensions.px8,
            color: ColorConstants.pronexTextGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
