import 'package:flutter/material.dart';
import '../../core/constants/app_text_style.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../core/constants/image_constants.dart';
import '../../core/models/property_model.dart';
import '../widgets/property_image_view.dart';
import '../../core/utils/base_view.dart';
import 'home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (viewModel) => viewModel.init(),
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
                  _buildHeader(viewModel),
                  const SizedBox(height: Dimensions.px8),
                  _buildSearchAndFilters(viewModel),
                  const SizedBox(height: Dimensions.px20),
                  // _buildPortfolioCard(viewModel),
                  // const SizedBox(height: Dimensions.px24),
                  _buildPropertiesSection(viewModel),
                  const SizedBox(height: Dimensions.px24),
                  _buildFaqSection(viewModel),
                  const SizedBox(height: Dimensions.px32),
                  _buildCommandCentre(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(HomeViewModel viewModel) {
    final displayName = viewModel.name?.trim() ?? '';
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimensions.px20,
        Dimensions.px8,
        Dimensions.px20,
        Dimensions.px4,
      ),
      child: SizedBox(
        height: Dimensions.px52,
        child: Row(
          children: [
            GestureDetector(
              onTap: viewModel.onProfilePressed,
              child: Container(
                width: Dimensions.px44,
                height: Dimensions.px44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConstants.pronexPrimaryLight,
                  border: Border.all(
                    color: ColorConstants.pronexPrimary.withValues(alpha: 0.18),
                    width: Dimensions.px1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  initial,
                  style: AppTextStyles.boldText(
                    fontSize: Dimensions.px18,
                    color: ColorConstants.pronexPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: Dimensions.px10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.regularText(
                      fontSize: Dimensions.px12,
                      color: ColorConstants.pronexTextGrey,
                    ),
                  ),
                  Text(
                    displayName.isEmpty ? 'Investor' : displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.boldText(
                      fontSize: Dimensions.px16,
                      color: ColorConstants.pronexTextDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Image.asset(
              ImageConstants.appLogo,
              height: 34,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters(HomeViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.px12),
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(Dimensions.px20),
          border: Border.all(color: const Color(0xFFEEF2F1)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A3C34).withValues(alpha: 0.05),
              blurRadius: Dimensions.px18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: Dimensions.px48,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7F6),
                borderRadius: BorderRadius.circular(Dimensions.px14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.px14),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: ColorConstants.pronexPrimary,
                    size: Dimensions.px22,
                  ),
                  const SizedBox(width: Dimensions.px10),
                  Expanded(
                    child: TextField(
                      controller: viewModel.searchController,
                      onChanged: viewModel.onSearchChanged,
                      onSubmitted: viewModel.onSearchSubmitted,
                      textInputAction: TextInputAction.search,
                      style: AppTextStyles.regularText(
                        fontSize: Dimensions.px15,
                        color: ColorConstants.pronexTextDark,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: 'Search premium properties',
                        hintStyle: AppTextStyles.regularText(
                          fontSize: Dimensions.px14,
                          color: const Color(0xFF9AA3A0),
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.px10),
            Container(
              height: Dimensions.px40,
              padding: const EdgeInsets.all(Dimensions.px4),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7F6),
                borderRadius: BorderRadius.circular(Dimensions.px14),
              ),
              child: Row(
                children: List.generate(viewModel.assetFilters.length, (i) {
                  final selected = viewModel.selectedAssetFilter == i;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => viewModel.setAssetFilter(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected
                              ? ColorConstants.pronexPrimary
                              : ColorConstants.transparent,
                          borderRadius: BorderRadius.circular(Dimensions.px10),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color: ColorConstants.pronexPrimary
                                        .withValues(alpha: 0.22),
                                    blurRadius: Dimensions.px8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          viewModel.assetFilters[i],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.semiBoldText(
                            fontSize: Dimensions.px13,
                            color: selected
                                ? ColorConstants.white
                                : ColorConstants.pronexTextGrey,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioCard(HomeViewModel viewModel) {
    final bars = <double>[0.25, 0.35, 0.3, 0.5, 0.6, 0.8, 1.0];
    final barColors = [
      const Color(0xFFB8D4CD),
      const Color(0xFFB8D4CD),
      const Color(0xFFB8D4CD),
      const Color(0xFFB8D4CD),
      const Color(0xFF7CB1A4),
      const Color(0xFF5A9688),
      ColorConstants.pronexPrimary,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px20,
      ),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.px20),
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(Dimensions.px24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: Dimensions.px16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TOTAL PORTFOLIO VALUE',
              style: AppTextStyles.regularText(
                fontSize: Dimensions.px12,
                color: ColorConstants.pronexTextGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Dimensions.px10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹12,45,000',
                  style: AppTextStyles.boldText(
                    fontSize: Dimensions.px25,
                    color: ColorConstants.pronexTextDark,
                  ),
                ),
                const SizedBox(width: Dimensions.px16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.px5,
                    vertical: Dimensions.px4,
                  ),
                  decoration: BoxDecoration(
                    color: ColorConstants.pronexPrimaryLight,
                    borderRadius: BorderRadius.circular(Dimensions.px8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_outward_rounded,
                        color: ColorConstants.pronexPrimary,
                        size: Dimensions.px16,
                      ),
                      const SizedBox(width: Dimensions.px2),
                      Text(
                        '+₹18,750 (1.53%)',
                        style: AppTextStyles.semiBoldText(
                          fontSize: Dimensions.px10,
                          color: ColorConstants.pronexPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimensions.px20),
            SizedBox(
              height: Dimensions.px52,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(bars.length, (i) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.px4,
                      ),
                      child: Container(
                        height: Dimensions.px52 * bars[i],
                        decoration: BoxDecoration(
                          color: barColors[i],
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(Dimensions.px4),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertiesSection(HomeViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: Dimensions.px40),
        child: Center(
          child: CircularProgressIndicator(
            color: ColorConstants.pronexPrimary,
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (viewModel.errorMessage != null && viewModel.displayProperties.isEmpty) {
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
              Text(
                viewModel.errorMessage ?? 'Unable to load properties',
                textAlign: TextAlign.center,
                style: AppTextStyles.semiBoldText(
                  fontSize: Dimensions.px15,
                  color: ColorConstants.pronexTextDark,
                ),
              ),
              const SizedBox(height: Dimensions.px16),
              GestureDetector(
                onTap: viewModel.retry,
                child: Container(
                  height: Dimensions.px44,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ColorConstants.pronexPrimary,
                    borderRadius: BorderRadius.circular(Dimensions.px14),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Retry',
                    style: AppTextStyles.semiBoldText(
                      fontSize: Dimensions.px14,
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

    if (viewModel.displayProperties.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
        child: Text(
          viewModel.isSearching
              ? 'No properties match your search.'
              : 'No properties available right now.',
          textAlign: TextAlign.center,
          style: AppTextStyles.regularText(
            fontSize: Dimensions.px14,
            color: ColorConstants.pronexTextGrey,
          ),
        ),
      );
    }

    final featured = viewModel.featuredProperty;
    final opportunities = viewModel.opportunityProperties;

    return Column(
      children: [
        if (featured != null) _buildFeaturedProperty(viewModel, featured),
        const SizedBox(height: Dimensions.px28),
        _buildNewOpportunitiesHeader(viewModel),
        const SizedBox(height: Dimensions.px16),
        if (opportunities.isEmpty && !viewModel.isSearching)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
            child: Text(
              'No more opportunities to show.',
              style: AppTextStyles.regularText(
                fontSize: Dimensions.px14,
                color: ColorConstants.pronexTextGrey,
              ),
            ),
          )
        else
          ...opportunities.map((property) {
            return Padding(
              padding: const EdgeInsets.only(bottom: Dimensions.px16),
              child: _buildOpportunityCard(
                viewModel: viewModel,
                property: property,
              ),
            );
          }),
      ],
    );
  }

  Widget _buildNetworkImage({
    required String url,
    required double height,
    double? width,
    required BoxFit fit,
    List<String> gallery = const [],
  }) {
    final photos = gallery.where((item) => item.trim().isNotEmpty).toList();
    if (url.isEmpty && photos.isEmpty) {
      return Container(
        height: height,
        width: width ?? double.infinity,
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
            size: Dimensions.px48,
          ),
        ),
      );
    }
    return PropertyImageView(
      urls: photos.isEmpty ? [url] : photos,
      height: height,
      width: width ?? double.infinity,
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
            size: Dimensions.px48,
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedProperty(
    HomeViewModel viewModel,
    PropertyModel property,
  ) {
    final propId = property.id ?? '';
    final funded = (property.soldPercent.clamp(0.0, 100.0) / 100).toDouble();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px20,
      ),
      child: GestureDetector(
        onTap: () => viewModel.onPropertyTap(propId),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: ColorConstants.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFE6EEEA)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF145C3A).withValues(alpha: 0.12),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                child: _buildNetworkImage(
                  url: property.firstImage,
                  gallery: property.media?.images ?? const [],
                  height: Dimensions.px200,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.1),
                        Colors.black.withValues(alpha: 0.65),
                      ],
                      stops: const [0.4, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: Dimensions.px16,
                left: Dimensions.px16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.px14,
                    vertical: Dimensions.px6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB8860B),
                    borderRadius: BorderRadius.circular(Dimensions.px20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        color: ColorConstants.white,
                        size: Dimensions.px14,
                      ),
                      const SizedBox(width: Dimensions.px4),
                      Text(
                        'VERIFIED STOCK',
                        style: AppTextStyles.semiBoldText(
                          fontSize: Dimensions.px11,
                          color: ColorConstants.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: Dimensions.px16,
                right: Dimensions.px16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.px12,
                    vertical: Dimensions.px6,
                  ),
                  decoration: BoxDecoration(
                    color: ColorConstants.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(Dimensions.px12),
                  ),
                  child: Text(
                    property.formattedYield,
                    style: AppTextStyles.boldText(
                      fontSize: Dimensions.px18,
                      color: const Color(0xFFB8860B),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: Dimensions.px16,
                right: Dimensions.px16,
                bottom: Dimensions.px50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.name,
                      style: AppTextStyles.boldText(
                        fontSize: Dimensions.px20,
                        color: ColorConstants.white,
                      ),
                    ),
                    const SizedBox(height: Dimensions.px4),
                    Text(
                      property.displayLocation.isEmpty
                          ? property.typeDisplay
                          : property.displayLocation,
                      style: AppTextStyles.regularText(
                        fontSize: Dimensions.px13,
                        color: ColorConstants.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: Dimensions.px16,
                right: Dimensions.px16,
                bottom: Dimensions.px16,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${property.displaySoldPercent}% funded',
                            style: AppTextStyles.regularText(
                              fontSize: Dimensions.px11,
                              color: ColorConstants.white.withValues(alpha: 0.9),
                            ),
                          ),
                          const SizedBox(height: Dimensions.px6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              Dimensions.px4,
                            ),
                            child: LinearProgressIndicator(
                              value: funded,
                              minHeight: Dimensions.px6,
                              backgroundColor:
                                  ColorConstants.white.withValues(alpha: 0.25),
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(
                                Color(0xFFD4A843),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: Dimensions.px16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.px14,
                        vertical: Dimensions.px8,
                      ),
                      decoration: BoxDecoration(
                        color: ColorConstants.white,
                        borderRadius: BorderRadius.circular(Dimensions.px14),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.flash_on_rounded,
                            color: const Color(0xFFD4A843),
                            size: Dimensions.px16,
                          ),
                          const SizedBox(width: Dimensions.px4),
                          Text(
                            property.formattedTotalValue,
                            style: AppTextStyles.boldText(
                              fontSize: Dimensions.px12,
                              color: const Color(0xFFB8860B),
                            ),
                          ),
                        ],
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

  Widget _buildNewOpportunitiesHeader(HomeViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px20,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              viewModel.isSearching ? 'Search results' : 'New Opportunities',
              style: AppTextStyles.boldText(
                fontSize: Dimensions.px20,
                color: ColorConstants.pronexPrimary,
              ),
            ),
          ),
          GestureDetector(
            onTap: viewModel.onViewAllOpportunities,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View All',
                  style: AppTextStyles.semiBoldText(
                    fontSize: Dimensions.px14,
                    color: ColorConstants.pronexPrimary,
                  ),
                ),
                const SizedBox(width: Dimensions.px2),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: Dimensions.px14,
                  color: ColorConstants.pronexPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpportunityCard({
    required HomeViewModel viewModel,
    required PropertyModel property,
  }) {
    final propId = property.id ?? '';
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px20,
      ),
      child: GestureDetector(
        onTap: () => viewModel.onPropertyTap(propId),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: ColorConstants.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFE4EFE9)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF145C3A).withValues(alpha: 0.1),
                blurRadius: 26,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  _buildNetworkImage(
                    url: property.firstImage,
                    gallery: property.media?.images ?? const [],
                    height: 176,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 64,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.45),
                          ],
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
                        borderRadius: BorderRadius.circular(Dimensions.px20),
                      ),
                      child: Text(
                        property.typeDisplay,
                        style: AppTextStyles.semiBoldText(
                          fontSize: Dimensions.px11,
                          color: const Color(0xFF145C3A),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: Dimensions.px12,
                    right: Dimensions.px12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.px12,
                        vertical: Dimensions.px6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF145C3A),
                        borderRadius: BorderRadius.circular(Dimensions.px20),
                      ),
                      child: Text(
                        'IRR ${property.formattedRoi}',
                        style: AppTextStyles.boldText(
                          fontSize: Dimensions.px11,
                          color: ColorConstants.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.name,
                      style: AppTextStyles.boldText(
                        fontSize: Dimensions.px18,
                        color: ColorConstants.pronexTextDark,
                      ),
                    ),
                    const SizedBox(height: Dimensions.px8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 16,
                          color: Color(0xFF1B6B45),
                        ),
                        const SizedBox(width: Dimensions.px4),
                        Expanded(
                          child: Text(
                            property.displayLocation.isEmpty
                                ? property.typeDisplay
                                : property.displayLocation,
                            style: AppTextStyles.regularText(
                              fontSize: Dimensions.px13,
                              color: ColorConstants.pronexTextGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.px14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3FBF6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MIN INVEST',
                                  style: AppTextStyles.regularText(
                                    fontSize: Dimensions.px10,
                                    color: ColorConstants.pronexTextGrey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: Dimensions.px4),
                                Text(
                                  property.formattedPricePerShare,
                                  style: AppTextStyles.boldText(
                                    fontSize: Dimensions.px16,
                                    color: const Color(0xFF145C3A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 32,
                            color: const Color(0xFFD7E8DF),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'YIELD',
                                    style: AppTextStyles.regularText(
                                      fontSize: Dimensions.px10,
                                      color: ColorConstants.pronexTextGrey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: Dimensions.px4),
                                  Text(
                                    property.formattedYield,
                                    style: AppTextStyles.boldText(
                                      fontSize: Dimensions.px16,
                                      color: const Color(0xFF145C3A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Dimensions.px16),
                    GestureDetector(
                      onTap: () => viewModel.onInvestNowTap(propId),
                      child: Container(
                        height: Dimensions.px52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1D29),
                          borderRadius: BorderRadius.circular(Dimensions.px26),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Invest Now  →',
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

  Widget _buildFaqSection(HomeViewModel viewModel) {
    final faqs = const [
      (
        'What is Pronex World?',
        'Pronex World is an AI-powered fractional real estate investment platform that enables investors to participate in selected real estate opportunities through professionally managed property-specific LLPs.',
      ),
      (
        'How does an investment opportunity work on Pronex World?',
        'Every investment opportunity follows a standardized presentation format. Investors can review the property snapshot, investment highlights, AI investment score, available documents, applicable fees and charges, risk factors and relevant investment documents before making an investment decision.',
      ),
      (
        'What information is available for each property?',
        'Depending on the opportunity, investors can review property information including Property Name, City, Asset Type, Developer, Status, Minimum Investment and LLP Name, along with supporting investment information and disclosures.',
      ),
      (
        'How does the LLP ownership model work?',
        'Each investment opportunity may be structured through a dedicated property-specific LLP. The applicable LLP Agreement governs rights, obligations, governance, voting, distributions and exit mechanisms for that investment opportunity.',
      ),
      (
        'What can I access through the investor dashboard?',
        'The investor dashboard provides access to portfolio overview, current investments, LLP holdings, capital contributed, property updates, financial statements, distribution history, tax documents, KYC status, notifications, support centre and download centre.',
      ),
      (
        'How does diversification help investors?',
        'Diversification does not eliminate investment risk, but it can help reduce concentration risk by allowing investors to build exposure across different cities, developers and asset classes as part of a broader investment strategy.',
      ),
      (
        'What is available in the Research Centre?',
        'The Research Centre includes market intelligence and educational content such as weekly market reports, city investment reports, infrastructure watch, developer insights, rental market analysis, commercial real estate updates, residential price trends, investment guides, economic commentary and AI research notes.',
      ),
      (
        'Are investments risk-free?',
        'No. Real estate and LLP investments are subject to market risks, liquidity risks, regulatory changes, vacancy risks and property-specific considerations. Investors should review the relevant LLP Agreement, investment documents and risk disclosures before making an investment decision.',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequently Asked Questions',
            style: AppTextStyles.boldText(
              fontSize: Dimensions.px18,
              color: ColorConstants.pronexTextDark,
            ),
          ),
          const SizedBox(height: Dimensions.px16),
          ...List.generate(faqs.length, (i) {
            final (question, answer) = faqs[i];
            final expanded = viewModel.faqExpanded[i] ?? false;
            return Padding(
              padding: EdgeInsets.only(
                bottom: i == faqs.length - 1 ? 0 : Dimensions.px12,
              ),
              child: GestureDetector(
                onTap: () => viewModel.toggleFaq(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    color: ColorConstants.white,
                    borderRadius: BorderRadius.circular(Dimensions.px16),
                    border: Border.all(
                      color: expanded
                          ? const Color(0xFF3B6FD8)
                          : const Color(0xFFE6E8EE),
                      width: expanded ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.px16,
                          vertical: Dimensions.px16,
                        ),
                        decoration: BoxDecoration(
                          color: expanded
                              ? const Color(0xFFF3FBFA)
                              : ColorConstants.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(Dimensions.px15),
                            bottom: Radius.circular(
                              expanded ? 0 : Dimensions.px15,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                question,
                                style: AppTextStyles.boldText(
                                  fontSize: Dimensions.px15,
                                  color: ColorConstants.pronexTextDark,
                                ),
                              ),
                            ),
                            const SizedBox(width: Dimensions.px12),
                            Icon(
                              expanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: expanded
                                  ? const Color(0xFF3D9A78)
                                  : const Color(0xFF9AA3B2),
                              size: Dimensions.px22,
                            ),
                          ],
                        ),
                      ),
                      if (expanded)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            Dimensions.px16,
                            Dimensions.px4,
                            Dimensions.px16,
                            Dimensions.px16,
                          ),
                          child: Text(
                            answer,
                            style: AppTextStyles.regularText(
                              fontSize: Dimensions.px14,
                              color: const Color(0xFF6B7280),
                              height: 1.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCommandCentre() {
    const accent = Color(0xFF3DDCB4);
    final items = const <(IconData, String)>[
      (Icons.bar_chart_rounded, 'Portfolio Overview'),
      (Icons.apartment_rounded, 'Current Investments'),
      (Icons.account_balance_rounded, 'LLP Holdings'),
      (Icons.currency_rupee_rounded, 'Capital Contributed'),
      (Icons.show_chart_rounded, 'Property Updates'),
      (Icons.description_outlined, 'Financial Statements'),
      (Icons.attach_money_rounded, 'Distribution History'),
      (Icons.receipt_long_outlined, 'Tax Documents'),
      (Icons.verified_rounded, 'KYC Status'),
      (Icons.visibility_outlined, 'Notifications'),
      (Icons.headset_mic_outlined, 'Support Centre'),
      (Icons.download_rounded, 'Download Centre'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          Dimensions.px16,
          Dimensions.px28,
          Dimensions.px16,
          Dimensions.px16,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF0C1420),
          borderRadius: BorderRadius.circular(Dimensions.px24),
        ),
        child: Column(
          children: [
            Text(
              'INVESTOR DASHBOARD',
              style: AppTextStyles.semiBoldText(
                fontSize: Dimensions.px11,
                color: accent,
              ).copyWith(letterSpacing: 1.4),
            ),
            const SizedBox(height: Dimensions.px10),
            Text(
              'Your Digital Command Centre',
              textAlign: TextAlign.center,
              style: AppTextStyles.boldText(
                fontSize: Dimensions.px26,
                color: ColorConstants.white,
              ),
            ),
            const SizedBox(height: Dimensions.px10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.px12),
              child: Text(
                'The investor dashboard should become the digital command centre for every investor.',
                textAlign: TextAlign.center,
                style: AppTextStyles.regularText(
                  fontSize: Dimensions.px13,
                  color: const Color(0xFF9AA6B8),
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: Dimensions.px22),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: Dimensions.px10,
                mainAxisSpacing: Dimensions.px10,
                childAspectRatio: 1.28,
              ),
              itemBuilder: (context, i) {
                final (icon, label) = items[i];
                return Container(
                  padding: const EdgeInsets.all(Dimensions.px14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151E2C),
                    borderRadius: BorderRadius.circular(Dimensions.px16),
                    border: Border.all(color: const Color(0xFF243044)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Dimensions.px36,
                        height: Dimensions.px36,
                        decoration: BoxDecoration(
                          color: const Color(0xFF12352F),
                          borderRadius: BorderRadius.circular(Dimensions.px10),
                        ),
                        child: Icon(
                          icon,
                          color: accent,
                          size: Dimensions.px18,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.semiBoldText(
                          fontSize: Dimensions.px13,
                          color: ColorConstants.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
