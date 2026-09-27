import 'package:flutter/material.dart';
import '../../core/constants/app_text_style.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../core/utils/base_view.dart';
import '../widgets/property_image_view.dart';
import 'saved_view_model.dart';

class SavedView extends StatelessWidget {
  final bool embedded;

  const SavedView({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    return BaseView.reactive(
      viewModelBuilder: () => SavedViewModel(),
      onViewModelReady: (viewModel) {
        viewModel.fetchWatchlist();
      },
      builder: (context, viewModel, child) {
        if (embedded) {
          return Column(
            children: [
              _buildSearchBar(viewModel),
              const SizedBox(height: Dimensions.px20),
              _buildAssetFilters(viewModel),
              const SizedBox(height: Dimensions.px18),
              _buildSortAndMapView(viewModel),
              const SizedBox(height: Dimensions.px20),
              _buildContentArea(viewModel),
            ],
          );
        }
        return Scaffold(
          backgroundColor: ColorConstants.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: Dimensions.px100),
              child: Column(
                children: [
                  _buildHeader(viewModel),
                  const SizedBox(height: Dimensions.px12),
                  _buildSubtitle(viewModel),
                  const SizedBox(height: Dimensions.px16),
                  _buildSearchBar(viewModel),
                  const SizedBox(height: Dimensions.px20),
                  _buildAssetFilters(viewModel),
                  const SizedBox(height: Dimensions.px18),
                  _buildSortAndMapView(viewModel),
                  const SizedBox(height: Dimensions.px20),
                  _buildContentArea(viewModel),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(SavedViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px20,
        vertical: Dimensions.px12,
      ),
      child: Row(
        children: [
          // Container(
          //   width: Dimensions.px40,
          //   height: Dimensions.px40,
          //   decoration: BoxDecoration(
          //     color: ColorConstants.white,
          //     shape: BoxShape.circle,
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black.withValues(alpha: 0.05),
          //         blurRadius: Dimensions.px8,
          //         offset: const Offset(0, 2),
          //       ),
          //     ],
          //   ),
          //   child: GestureDetector(
          //     onTap: viewModel.onFilterPressed,
          //     child: Icon(
          //       Icons.search_rounded,
          //       color: ColorConstants.pronexTextDark,
          //       size: Dimensions.px22,
          //     ),
          //   ),
          // ),
          const SizedBox(width: Dimensions.px12),
          Expanded(
            child: Text(
              'Saved Properties',
              style: AppTextStyles.boldText(
                fontSize: Dimensions.px20,
                color: ColorConstants.pronexTextDark,
              ),
            ),
          ),
          // Container(
          //   width: Dimensions.px40,
          //   height: Dimensions.px40,
          //   decoration: BoxDecoration(
          //     color: ColorConstants.white,
          //     shape: BoxShape.circle,
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black.withValues(alpha: 0.05),
          //         blurRadius: Dimensions.px8,
          //         offset: const Offset(0, 2),
          //       ),
          //     ],
          //   ),
          //   child: GestureDetector(
          //     onTap: viewModel.onFilterPressed,
          //     child: Icon(
          //       Icons.tune_rounded,
          //       color: ColorConstants.pronexTextDark,
          //       size: Dimensions.px22,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildSubtitle(SavedViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '${viewModel.favoriteIds.length} properties saved for later.',
          style: AppTextStyles.regularText(
            fontSize: Dimensions.px15,
            color: ColorConstants.pronexTextGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(SavedViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Container(
        height: Dimensions.px64,
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(Dimensions.px20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: Dimensions.px12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.px16),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                color: ColorConstants.pronexTextGrey,
                size: Dimensions.px26,
              ),
              const SizedBox(width: Dimensions.px12),
              Expanded(
                child: TextField(
                  controller: viewModel.searchController,
                  onChanged: viewModel.onSearchChanged,
                  onSubmitted: viewModel.onSearchSubmitted,
                  style: AppTextStyles.regularText(
                    fontSize: Dimensions.px16,
                    color: ColorConstants.pronexTextDark,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Search saved properties...',
                    hintStyle: AppTextStyles.regularText(
                      fontSize: Dimensions.px16,
                      color: ColorConstants.pronexTextGrey,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              // GestureDetector(
              //   onTap: viewModel.onFilterPressed,
              //   child: Container(
              //     width: Dimensions.px36,
              //     height: Dimensions.px36,
              //     alignment: Alignment.center,
              //     child: Icon(
              //       Icons.tune_rounded,
              //       color: ColorConstants.pronexTextGrey,
              //       size: Dimensions.px22,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssetFilters(SavedViewModel viewModel) {
    return SizedBox(
      height: Dimensions.px48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
        scrollDirection: Axis.horizontal,
        itemCount: viewModel.assetFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: Dimensions.px12),
        itemBuilder: (context, i) {
          final selected = viewModel.selectedAssetFilter == i;
          return GestureDetector(
            onTap: () => viewModel.setAssetFilter(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.px26),
              decoration: BoxDecoration(
                color: selected
                    ? ColorConstants.pronexPrimary
                    : ColorConstants.white,
                borderRadius: BorderRadius.circular(Dimensions.px24),
                border: Border.all(
                  color: selected
                      ? ColorConstants.pronexPrimary
                      : const Color(0xFFE5E7EB),
                  width: Dimensions.px1,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: ColorConstants.pronexPrimary.withValues(
                            alpha: 0.2,
                          ),
                          blurRadius: Dimensions.px8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                viewModel.assetFilters[i],
                style: AppTextStyles.semiBoldText(
                  fontSize: Dimensions.px15,
                  color: selected
                      ? ColorConstants.white
                      : ColorConstants.pronexTextGrey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortAndMapView(SavedViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: viewModel.onSortPressed,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.filter_list_rounded,
                    size: Dimensions.px20,
                    color: ColorConstants.pronexTextGrey,
                  ),
                  const SizedBox(width: Dimensions.px6),
                  Flexible(
                    child: Text(
                      viewModel.yieldSortLabel,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.semiBoldText(
                        fontSize: Dimensions.px14,
                        color: ColorConstants.pronexTextDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: viewModel.onMapViewPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.px16,
                vertical: Dimensions.px10,
              ),
              decoration: BoxDecoration(
                color: ColorConstants.white,
                borderRadius: BorderRadius.circular(Dimensions.px16),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: Dimensions.px1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.view_list_rounded,
                    size: Dimensions.px18,
                    color: ColorConstants.pronexTextDark,
                  ),
                  const SizedBox(width: Dimensions.px6),
                  Text(
                    'List View',
                    style: AppTextStyles.semiBoldText(
                      fontSize: Dimensions.px14,
                      color: ColorConstants.pronexTextDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentArea(SavedViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(Dimensions.px32),
        child: CircularProgressIndicator(color: ColorConstants.pronexPrimary),
      );
    }
    if (viewModel.errorMessage != null && viewModel.properties.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(Dimensions.px20),
        child: Text(
          viewModel.errorMessage!,
          textAlign: TextAlign.center,
          style: AppTextStyles.regularText(
            fontSize: Dimensions.px15,
            color: ColorConstants.radicalRed,
          ),
        ),
      );
    }
    if (viewModel.properties.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(Dimensions.px32),
        child: Text(
          'No saved properties found.',
          style: AppTextStyles.regularText(
            fontSize: Dimensions.px15,
            color: ColorConstants.pronexTextGrey,
          ),
        ),
      );
    }
    return Column(
      children: viewModel.properties.map((property) {
        return Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.px20),
          child: _buildPropertyCard(
            viewModel: viewModel,
            id: property.id ?? '',
            image: property.firstImage,
            images: property.media?.images ?? const [],
            title: property.name,
            location: property.displayLocation,
            type: property.typeDisplay,
            roi: property.formattedRoi,
            yieldVal: property.formattedYield,
            minInvest: property.formattedPricePerShare,
            fundedPercent: property.displaySoldPercent,
            fundedText: '${property.displaySoldPercent}% Funded',
            sharesText: 'Share: ${property.formattedPricePerShare}',
            isVerified: true,
            isFavorite: viewModel.favoriteIds.contains(property.id),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPropertyCard({
    required SavedViewModel viewModel,
    required String id,
    required String image,
    List<String> images = const [],
    required String title,
    required String location,
    required String type,
    required String roi,
    required String yieldVal,
    required String minInvest,
    required int fundedPercent,
    required String fundedText,
    required String sharesText,
    required bool isVerified,
    required bool isFavorite,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: GestureDetector(
        onTap: () => viewModel.onPropertyTap(id),
        child: Container(
          decoration: BoxDecoration(
            color: ColorConstants.white,
            borderRadius: BorderRadius.circular(Dimensions.px24),
            border: Border.all(
              color: const Color(0xFFEFF1F4),
              width: Dimensions.px1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: Dimensions.px10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(Dimensions.px24),
                    ),
                    child: PropertyImageView(
                      urls: images.where((item) => item.trim().isNotEmpty).isEmpty
                          ? [image]
                          : images,
                      height: Dimensions.px180,
                      fit: BoxFit.cover,
                      fallback: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  ColorConstants.pronexPrimaryLight,
                                  const Color(0xFFC8DCD6),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.home_work_outlined,
                                color: ColorConstants.pronexPrimary.withValues(
                                  alpha: 0.5,
                                ),
                                size: Dimensions.px56,
                              ),
                            ),
                          ),
                    ),
                  ),
                  Positioned(
                    top: Dimensions.px12,
                    left: Dimensions.px12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.px12,
                        vertical: Dimensions.px6,
                      ),
                      decoration: BoxDecoration(
                        color: ColorConstants.white,
                        borderRadius: BorderRadius.circular(Dimensions.px16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            color: ColorConstants.pronexPrimary,
                            size: Dimensions.px14,
                          ),
                          const SizedBox(width: Dimensions.px4),
                          Text(
                            'VERIFIED',
                            style: AppTextStyles.boldText(
                              fontSize: Dimensions.px11,
                              color: ColorConstants.pronexPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: Dimensions.px12,
                    right: Dimensions.px12,
                    child: GestureDetector(
                      onTap: () => viewModel.toggleFavorite(id),
                      child: Container(
                        width: Dimensions.px36,
                        height: Dimensions.px36,
                        decoration: BoxDecoration(
                          color: ColorConstants.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: Dimensions.px6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFavorite
                              ? ColorConstants.radicalRed
                              : ColorConstants.pronexTextGrey,
                          size: Dimensions.px20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(Dimensions.px18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: AppTextStyles.boldText(
                              fontSize: Dimensions.px17,
                              color: ColorConstants.pronexTextDark,
                            ),
                          ),
                        ),
                        const SizedBox(width: Dimensions.px8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              roi,
                              style: AppTextStyles.boldText(
                                fontSize: Dimensions.px17,
                                color: ColorConstants.pronexPrimary,
                              ),
                            ),
                            Text(
                              'ROI',
                              style: AppTextStyles.regularText(
                                fontSize: Dimensions.px11,
                                color: ColorConstants.pronexTextGrey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.px8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: Dimensions.px14,
                          color: ColorConstants.pronexTextGrey,
                        ),
                        const SizedBox(width: Dimensions.px4),
                        Text(
                          location,
                          style: AppTextStyles.regularText(
                            fontSize: Dimensions.px13,
                            color: ColorConstants.pronexTextGrey,
                          ),
                        ),
                        const SizedBox(width: Dimensions.px8),
                        Text(
                          '•',
                          style: AppTextStyles.regularText(
                            fontSize: Dimensions.px13,
                            color: ColorConstants.pronexTextGrey,
                          ),
                        ),
                        const SizedBox(width: Dimensions.px8),
                        Text(
                          type,
                          style: AppTextStyles.regularText(
                            fontSize: Dimensions.px13,
                            color: ColorConstants.pronexTextGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.px18),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'YIELD',
                                style: AppTextStyles.regularText(
                                  fontSize: Dimensions.px11,
                                  color: ColorConstants.pronexTextGrey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: Dimensions.px4),
                              Text(
                                yieldVal,
                                style: AppTextStyles.boldText(
                                  fontSize: Dimensions.px17,
                                  color: ColorConstants.pronexTextDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MIN. INVEST',
                                style: AppTextStyles.regularText(
                                  fontSize: Dimensions.px11,
                                  color: ColorConstants.pronexTextGrey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: Dimensions.px4),
                              Text(
                                minInvest,
                                style: AppTextStyles.boldText(
                                  fontSize: Dimensions.px17,
                                  color: ColorConstants.pronexTextDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.px18),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fundedText,
                                style: AppTextStyles.regularText(
                                  fontSize: Dimensions.px13,
                                  color: ColorConstants.pronexTextGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          sharesText,
                          style: AppTextStyles.regularText(
                            fontSize: Dimensions.px13,
                            color: ColorConstants.pronexTextGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.px10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.px6),
                      child: LinearProgressIndicator(
                        value: fundedPercent / 100,
                        minHeight: Dimensions.px8,
                        backgroundColor: const Color(0xFFE8F0EE),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          ColorConstants.pronexPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.px20),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => viewModel.onViewDetailsTap(id),
                            child: Container(
                              height: Dimensions.px50,
                              decoration: BoxDecoration(
                                color: ColorConstants.pronexPrimary,
                                borderRadius: BorderRadius.circular(
                                  Dimensions.px16,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorConstants.pronexPrimary
                                        .withValues(alpha: 0.15),
                                    blurRadius: Dimensions.px8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'View Details',
                                style: AppTextStyles.semiBoldText(
                                  fontSize: Dimensions.px15,
                                  color: ColorConstants.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: Dimensions.px12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => viewModel.onQuickInvestTap(id),
                            child: Container(
                              height: Dimensions.px50,
                              decoration: BoxDecoration(
                                color: ColorConstants.white,
                                borderRadius: BorderRadius.circular(
                                  Dimensions.px16,
                                ),
                                border: Border.all(
                                  color: ColorConstants.pronexPrimary,
                                  width: Dimensions.px2,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Quick Invest',
                                style: AppTextStyles.semiBoldText(
                                  fontSize: Dimensions.px15,
                                  color: ColorConstants.pronexPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
