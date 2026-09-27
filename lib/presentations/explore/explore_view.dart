import 'package:flutter/material.dart';
import '../../core/constants/app_text_style.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../core/models/property_model.dart';
import '../widgets/property_image_view.dart';
import '../../core/utils/base_view.dart';
import 'explore_filter_sheet.dart';
import 'explore_view_model.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView.reactive(
      viewModelBuilder: () => ExploreViewModel(),
      onViewModelReady: (viewModel) {
        viewModel.fetchProperties();
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: ColorConstants.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                bottom: Dimensions.px100,
              ),
              child: Column(
                children: [
                  _buildHeader(context, viewModel),
                  const SizedBox(height: Dimensions.px12),
                  _buildSubtitle(),
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

  Widget _buildContentArea(ExploreViewModel viewModel) {
    if (viewModel.isLoading) {
      return _buildLoadingSkeleton();
    }
    if (viewModel.errorMessage != null && viewModel.properties.isEmpty) {
      return _buildErrorState(viewModel);
    }
    return _buildPropertyList(viewModel);
  }

  Widget _buildLoadingSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Column(
        children: [
          _buildSkeletonCard(height: Dimensions.px420),
          const SizedBox(height: Dimensions.px20),
          _buildSkeletonCard(height: Dimensions.px380),
          const SizedBox(height: Dimensions.px20),
          _buildSkeletonCard(height: Dimensions.px380),
        ],
      ),
    );
  }

  Widget _buildSkeletonCard({required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(Dimensions.px24),
        border: Border.all(color: const Color(0xFFEFF1F4)),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: ColorConstants.pronexPrimary,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildErrorState(ExploreViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.px24),
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(Dimensions.px24),
          border: Border.all(color: const Color(0xFFEFF1F4)),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: Dimensions.px56,
              color: ColorConstants.radicalRed,
            ),
            const SizedBox(height: Dimensions.px16),
            Text(
              viewModel.errorMessage ?? 'Unable to load properties',
              style: AppTextStyles.semiBoldText(
                fontSize: Dimensions.px16,
                color: ColorConstants.pronexTextDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimensions.px20),
            GestureDetector(
              onTap: viewModel.retry,
              child: Container(
                height: Dimensions.px48,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorConstants.pronexPrimary,
                  borderRadius: BorderRadius.circular(Dimensions.px16),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Retry',
                  style: AppTextStyles.semiBoldText(
                    fontSize: Dimensions.px15,
                    color: ColorConstants.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyList(ExploreViewModel viewModel) {
    final featured = viewModel.featuredProperty;
    final otherProps = viewModel.properties.where((p) => p.id != featured?.id).toList();

    return Column(
      children: [
        if (featured != null)
          _buildFeaturedPropertyCard(viewModel, featured)
        else if (viewModel.properties.isEmpty)
          _buildEmptyState(viewModel),
        if (featured != null) const SizedBox(height: Dimensions.px20),
        ...otherProps.map((p) {
          return Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.px20),
            child: _buildPropertyCard(
              viewModel: viewModel,
              property: p,
            ),
          );
        }),
        if (otherProps.isEmpty && featured != null)
          const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildEmptyState(ExploreViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.px28),
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(Dimensions.px24),
          border: Border.all(color: const Color(0xFFEFF1F4)),
        ),
        child: Column(
          children: [
            Icon(
              Icons.search_off_rounded,
              size: Dimensions.px64,
              color: ColorConstants.pronexTextGrey.withValues(alpha: 0.5),
            ),
            const SizedBox(height: Dimensions.px16),
            Text(
              'No properties found',
              style: AppTextStyles.boldText(
                fontSize: Dimensions.px18,
                color: ColorConstants.pronexTextDark,
              ),
            ),
            const SizedBox(height: Dimensions.px8),
            Text(
              viewModel.searchController.text.isNotEmpty ||
                      viewModel.selectedAssetFilter != 0
                  ? 'Try adjusting your filters or search query.'
                  : 'Check back soon for new investment opportunities.',
              style: AppTextStyles.regularText(
                fontSize: Dimensions.px14,
                color: ColorConstants.pronexTextGrey,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ExploreViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px20,
        vertical: Dimensions.px12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Explore Investments',
              style: AppTextStyles.boldText(
                fontSize: Dimensions.px20,
                color: ColorConstants.pronexTextDark,
              ),
            ),
          ),
          Container(
            width: Dimensions.px40,
            height: Dimensions.px40,
            decoration: BoxDecoration(
              color: ColorConstants.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: Dimensions.px8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () => showExploreFilterSheet(context, viewModel),
              child: const Icon(
                Icons.tune_rounded,
                color: ColorConstants.pronexTextDark,
                size: Dimensions.px22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px20,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Discover verified real estate opportunities.',
          style: AppTextStyles.regularText(
            fontSize: Dimensions.px15,
            color: ColorConstants.pronexTextGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(ExploreViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px20,
      ),
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
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.px16,
          ),
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
                  textInputAction: TextInputAction.search,
                  style: AppTextStyles.regularText(
                    fontSize: Dimensions.px16,
                    color: ColorConstants.pronexTextDark,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Search by property name...',
                    hintStyle: AppTextStyles.regularText(
                      fontSize: Dimensions.px16,
                      color: ColorConstants.pronexTextGrey,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssetFilters(ExploreViewModel viewModel) {
    return SizedBox(
      height: Dimensions.px48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.px20,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: viewModel.assetFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: Dimensions.px12),
        itemBuilder: (context, i) {
          final selected = viewModel.selectedAssetFilter == i;
          return GestureDetector(
            onTap: () => viewModel.setAssetFilter(i),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.px26,
              ),
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
                          color: ColorConstants.pronexPrimary
                              .withValues(alpha: 0.2),
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

  Widget _buildSortAndMapView(ExploreViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px20,
      ),
      child: Row(
        children: [
          Expanded(
            child: PopupMenuButton<YieldSort>(
              onSelected: viewModel.setYieldSort,
              offset: const Offset(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.px12),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: YieldSort.highest,
                  child: Text(
                    'Highest Yield',
                    style: AppTextStyles.semiBoldText(
                      fontSize: Dimensions.px14,
                      color: viewModel.yieldSort == YieldSort.highest
                          ? ColorConstants.pronexPrimary
                          : ColorConstants.pronexTextDark,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: YieldSort.lowest,
                  child: Text(
                    'Lowest Yield',
                    style: AppTextStyles.semiBoldText(
                      fontSize: Dimensions.px14,
                      color: viewModel.yieldSort == YieldSort.lowest
                          ? ColorConstants.pronexPrimary
                          : ColorConstants.pronexTextDark,
                    ),
                  ),
                ),
              ],
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
                  const SizedBox(width: Dimensions.px2),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: Dimensions.px18,
                    color: ColorConstants.pronexTextGrey,
                  ),
                ],
              ),
            ),
          ),
          // GestureDetector(
          //   onTap: viewModel.onMapViewPressed,
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(
          //       horizontal: Dimensions.px16,
          //       vertical: Dimensions.px10,
          //     ),
          //     decoration: BoxDecoration(
          //       color: ColorConstants.white,
          //       borderRadius: BorderRadius.circular(Dimensions.px16),
          //       border: Border.all(
          //         color: const Color(0xFFE5E7EB),
          //         width: Dimensions.px1,
          //       ),
          //     ),
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Icon(
          //           Icons.map_outlined,
          //           size: Dimensions.px18,
          //           color: ColorConstants.pronexTextDark,
          //         ),
          //         const SizedBox(width: Dimensions.px6),
          //         Text(
          //           'Map View',
          //           style: AppTextStyles.semiBoldText(
          //             fontSize: Dimensions.px14,
          //             color: ColorConstants.pronexTextDark,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildNetworkImage({
    required String url,
    required double height,
    required BoxFit fit,
    List<String> gallery = const [],
  }) {
    final photos = gallery.where((item) => item.trim().isNotEmpty).toList();
    if (url.isEmpty && photos.isEmpty) {
      return Container(
        height: height,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A3A33),
              Color(0xFF2D5E52),
            ],
          ),
        ),
        child: Center(
          child: Icon(
            Icons.apartment_rounded,
            color: ColorConstants.white.withValues(alpha: 0.5),
            size: Dimensions.px64,
          ),
        ),
      );
    }
    return PropertyImageView(
      urls: photos.isEmpty ? [url] : photos,
      height: height,
      fit: fit,
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
            color: ColorConstants.pronexPrimary.withValues(alpha: 0.5),
            size: Dimensions.px56,
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedPropertyCard(ExploreViewModel viewModel, PropertyModel property) {
    final propId = property.id ?? '';
    final isFavorite = viewModel.favoriteIds.contains(propId);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px20,
      ),
      child: GestureDetector(
        onTap: () => viewModel.onPropertyTap(propId),
        child: Container(
          decoration: BoxDecoration(
            color: ColorConstants.white,
            borderRadius: BorderRadius.circular(Dimensions.px24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: Dimensions.px16,
                offset: const Offset(0, 4),
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
                    child: _buildNetworkImage(
                      url: property.firstImage,
                      gallery: property.media?.images ?? const [],
                      height: Dimensions.px200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: Dimensions.px14,
                    left: Dimensions.px14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.px12,
                        vertical: Dimensions.px6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Dimensions.px16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: Dimensions.px8,
                            height: Dimensions.px8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE5A823),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: Dimensions.px6),
                          Text(
                            (property.status ?? 'funding').toUpperCase(),
                            style: AppTextStyles.boldText(
                              fontSize: Dimensions.px11,
                              color: const Color(0xFFE5A823),
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
                      onTap: propId.isEmpty
                          ? null
                          : () => viewModel.toggleFavorite(propId),
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
                padding: const EdgeInsets.all(Dimensions.px20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.px14,
                            vertical: Dimensions.px6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF4D6),
                            borderRadius: BorderRadius.circular(Dimensions.px8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.emoji_events_rounded,
                                color: const Color(0xFFD4A843),
                                size: Dimensions.px16,
                              ),
                              const SizedBox(width: Dimensions.px4),
                              Text(
                                property.isFeatured ? "EDITOR'S CHOICE" : "FEATURED",
                                style: AppTextStyles.boldText(
                                  fontSize: Dimensions.px11,
                                  color: const Color(0xFFD4A843),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          property.formattedRoi,
                          style: AppTextStyles.boldText(
                            fontSize: Dimensions.px18,
                            color: ColorConstants.pronexPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.px14),
                    Text(
                      property.name,
                      style: AppTextStyles.boldText(
                        fontSize: Dimensions.px18,
                        color: ColorConstants.pronexTextDark,
                      ),
                    ),
                    if (property.displayLocation.isNotEmpty) ...[
                      const SizedBox(height: Dimensions.px4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: Dimensions.px14,
                            color: ColorConstants.pronexTextGrey,
                          ),
                          const SizedBox(width: Dimensions.px4),
                          Expanded(
                            child: Text(
                              property.displayLocation,
                              style: AppTextStyles.regularText(
                                fontSize: Dimensions.px13,
                                color: ColorConstants.pronexTextGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if ((property.description ?? '').isNotEmpty) ...[
                      const SizedBox(height: Dimensions.px8),
                      Text(
                        property.description!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.regularText(
                          fontSize: Dimensions.px14,
                          color: ColorConstants.pronexTextGrey,
                          height: 1.5,
                        ),
                      ),
                    ],
                    const SizedBox(height: Dimensions.px20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricTile(
                            title: 'ANNUAL YIELD',
                            value: property.rentalYield > 0
                                ? property.formattedYield
                                : '—',
                          ),
                        ),
                        const SizedBox(width: Dimensions.px12),
                        Expanded(
                          child: _buildMetricTile(
                            title: 'SHARE PRICE',
                            value: property.formattedPricePerShare,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.px24),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${property.displaySoldPercent}% Funded',
                                style: AppTextStyles.semiBoldText(
                                  fontSize: Dimensions.px14,
                                  color: ColorConstants.pronexTextDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          property.formattedTotalValue,
                          style: AppTextStyles.regularText(
                            fontSize: Dimensions.px14,
                            color: ColorConstants.pronexTextGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.px10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.px6),
                      child: LinearProgressIndicator(
                        value: property.displaySoldPercent / 100,
                        minHeight: Dimensions.px8,
                        backgroundColor: const Color(0xFFE8F0EE),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          ColorConstants.pronexPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.px24),
                    GestureDetector(
                      onTap: () => viewModel.onInvestNowTap(propId),
                      child: Container(
                        height: Dimensions.px56,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: ColorConstants.pronexPrimary,
                          borderRadius:
                              BorderRadius.circular(Dimensions.px18),
                          boxShadow: [
                            BoxShadow(
                              color: ColorConstants.pronexPrimary
                                  .withValues(alpha: 0.25),
                              blurRadius: Dimensions.px12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Invest Now',
                          style: AppTextStyles.semiBoldText(
                            fontSize: Dimensions.px16,
                            color: ColorConstants.white,
                          ),
                        ),
                      ),
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

  Widget _buildMetricTile({
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.px16),
      decoration: BoxDecoration(
        color: ColorConstants.pronexPrimaryLight,
        borderRadius: BorderRadius.circular(Dimensions.px14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.regularText(
              fontSize: Dimensions.px11,
              color: ColorConstants.pronexTextGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: Dimensions.px6),
          Text(
            value,
            style: AppTextStyles.boldText(
              fontSize: Dimensions.px18,
              color: ColorConstants.pronexTextDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard({
    required ExploreViewModel viewModel,
    required PropertyModel property,
  }) {
    final propId = property.id ?? '';
    final isFavorite = viewModel.favoriteIds.contains(propId);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px20,
      ),
      child: GestureDetector(
        onTap: () => viewModel.onPropertyTap(propId),
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
                    child: _buildNetworkImage(
                      url: property.firstImage,
                      gallery: property.media?.images ?? const [],
                      height: Dimensions.px180,
                      fit: BoxFit.cover,
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
                      onTap: () => viewModel.toggleFavorite(propId),
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
                            property.name,
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
                              property.formattedRoi,
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
                        Expanded(
                          child: Text(
                            property.displayLocation.isNotEmpty
                                ? property.displayLocation
                                : 'Location unavailable',
                            style: AppTextStyles.regularText(
                              fontSize: Dimensions.px13,
                              color: ColorConstants.pronexTextGrey,
                            ),
                            overflow: TextOverflow.ellipsis,
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
                          property.typeDisplay,
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
                                property.rentalYield > 0
                                    ? property.formattedYield
                                    : '—',
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
                                property.formattedPricePerShare,
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
                                '${property.displaySoldPercent}% Funded',
                                style: AppTextStyles.regularText(
                                  fontSize: Dimensions.px13,
                                  color: ColorConstants.pronexTextGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Share: ${property.formattedPricePerShare}',
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
                        value: property.displaySoldPercent / 100,
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
                            onTap: () => viewModel.onViewDetailsTap(propId),
                            child: Container(
                              height: Dimensions.px50,
                              decoration: BoxDecoration(
                                color: ColorConstants.pronexPrimary,
                                borderRadius:
                                    BorderRadius.circular(Dimensions.px16),
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
                            onTap: () => viewModel.onQuickInvestTap(propId),
                            child: Container(
                              height: Dimensions.px50,
                              decoration: BoxDecoration(
                                color: ColorConstants.white,
                                borderRadius:
                                    BorderRadius.circular(Dimensions.px16),
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
