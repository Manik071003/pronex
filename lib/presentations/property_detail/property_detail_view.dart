import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_text_style.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../core/models/property_detail_model.dart';
import '../../core/utils/base_view.dart';
import '../investment_calculator/returns_calculator_section.dart';
import '../widgets/property_image_view.dart';
import 'property_detail_view_model.dart';

class PropertyDetailView extends StatelessWidget {
  final String propertyId;

  const PropertyDetailView({super.key, required this.propertyId});

  static final _calculatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BaseView.reactive(
      viewModelBuilder: () => PropertyDetailViewModel(propertyId),
      onViewModelReady: (viewModel) {
        viewModel.fetchProperty();
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF9F9FB),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: Dimensions.px20,
                  bottom: Dimensions.px120,
                ),
                child: Column(
                  children: [
                    _buildAppBar(viewModel),
                    const SizedBox(height: Dimensions.px16),
                    _buildBody(viewModel),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildBottomInvestBar(
                  viewModel,
                  viewModel.onInvestNowPressed,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(PropertyDetailViewModel viewModel) {
    if (viewModel.isLoading) {
      return _buildLoadingState();
    }
    if (viewModel.errorMessage != null && viewModel.property == null) {
      return _buildErrorState(viewModel);
    }
    final property = viewModel.property;
    if (property == null) {
      return _buildErrorState(viewModel);
    }
    return Column(
      children: [
        _buildPropertyImage(viewModel, property),
        const SizedBox(height: Dimensions.px24),
        _buildHeaderInfo(property),
        const SizedBox(height: Dimensions.px20),
        _buildDeveloperCard(property),
        const SizedBox(height: Dimensions.px28),
        _buildAboutSection(viewModel, property),
        const SizedBox(height: Dimensions.px24),
        _buildMetricsGrid(property),
        const SizedBox(height: Dimensions.px32),
        _buildAmenitiesSection(property),
        const SizedBox(height: Dimensions.px32),
        _buildLegalVaultSection(viewModel, property),
        const SizedBox(height: Dimensions.px24),
        // _buildFundingProgressSection(property),
        // const SizedBox(height: Dimensions.px24),
        ReturnsCalculatorSection(
          key: _calculatorKey,
          propertyId: property.id ?? viewModel.propertyId,
          propertyName: property.name,
          sharePrice: property.sharePrice ?? 25000,
          totalValue: property.totalValue ?? 25000000000,
          roi: property.roi ?? property.targetROI ?? 14.8,
          rentalYield: property.rentalYield ?? 8.4,
          buyingCycle: property.effectiveBuyingCycle,
          minShares: property.effectiveMinimumShares,
          availableShares: property.effectiveShareLimit,
        ),
        const SizedBox(height: Dimensions.px24),
        _buildRelatedProperties(viewModel),
        const SizedBox(height: Dimensions.px28),
        const _InvestmentKnowledgeSection(),
        const SizedBox(height: Dimensions.px12),
        // _buildAIScoreCard(property),
        // const SizedBox(height: Dimensions.px20),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px16),
      child: Column(
        children: [
          Container(
            height: Dimensions.px220,
            decoration: BoxDecoration(
              color: ColorConstants.pronexPrimaryLight,
              borderRadius: BorderRadius.circular(Dimensions.px24),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: ColorConstants.pronexPrimary,
                strokeWidth: 2,
              ),
            ),
          ),
          const SizedBox(height: Dimensions.px24),
          _buildSkeletonTile(height: Dimensions.px32, width: double.infinity),
          const SizedBox(height: Dimensions.px12),
          _buildSkeletonTile(height: Dimensions.px20, width: 220),
          const SizedBox(height: Dimensions.px24),
          _buildSkeletonTile(height: Dimensions.px80, width: double.infinity),
          const SizedBox(height: Dimensions.px32),
          _buildSkeletonTile(height: Dimensions.px240, width: double.infinity),
        ],
      ),
    );
  }

  Widget _buildSkeletonTile({required double height, required double width}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(Dimensions.px14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: Dimensions.px8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(PropertyDetailViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Container(
        width: double.infinity,
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
              viewModel.errorMessage ?? 'Unable to load property details',
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

  Widget _buildRelatedProperties(PropertyDetailViewModel viewModel) {
    final related = viewModel.relatedProperties;
    if (related.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Related Properties',
                  style: AppTextStyles.boldText(
                    fontSize: Dimensions.px20,
                    color: const Color(0xFF3D7A6A),
                  ),
                ),
              ),
              Text(
                '${related.length} Picks',
                style: AppTextStyles.regularText(
                  fontSize: Dimensions.px12,
                  color: ColorConstants.pronexTextGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.px16),
          ...related.take(3).map((property) {
            final image = property.firstImage;
            return Container(
              margin: const EdgeInsets.only(bottom: Dimensions.px12),
              decoration: BoxDecoration(
                color: ColorConstants.white,
                borderRadius: BorderRadius.circular(Dimensions.px18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: Dimensions.px10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                    ),
                    child: PropertyImageView(
                      urls: image.isEmpty ? const [] : [image],
                      width: 110,
                      height: 120,
                      autoPlay: false,
                      fallback: Container(
                        width: 110,
                        height: 120,
                        color: ColorConstants.pronexPrimaryLight,
                        child: Icon(
                          Icons.home_work_outlined,
                          color: ColorConstants.pronexPrimary,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.px14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            property.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.semiBoldText(
                              fontSize: Dimensions.px15,
                              color: ColorConstants.pronexTextDark,
                            ),
                          ),
                          const SizedBox(height: Dimensions.px6),
                          if (property.displayLocation.isNotEmpty)
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 14,
                                  color: ColorConstants.pronexTextGrey,
                                ),
                                const SizedBox(width: Dimensions.px4),
                                Expanded(
                                  child: Text(
                                    property.displayLocation,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.regularText(
                                      fontSize: Dimensions.px12,
                                      color: ColorConstants.pronexTextGrey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: Dimensions.px10),
                          Row(
                            children: [
                              Text(
                                property.formattedRoi,
                                style: AppTextStyles.boldText(
                                  fontSize: Dimensions.px15,
                                  color: ColorConstants.pronexPrimary,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                property.formattedPricePerShare,
                                style: AppTextStyles.boldText(
                                  fontSize: Dimensions.px14,
                                  color: ColorConstants.pronexTextDark,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAppBar(PropertyDetailViewModel viewModel) {
    final title = viewModel.property?.name.trim();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px16),
      child: SizedBox(
        height: Dimensions.px48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: viewModel.onBackPressed,
                child: Container(
                  width: Dimensions.px40,
                  height: Dimensions.px40,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: ColorConstants.pronexTextDark,
                    size: Dimensions.px24,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.px48),
              child: Text(
                (title == null || title.isEmpty) ? 'Property Details' : title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.boldText(
                  fontSize: Dimensions.px18,
                  color: ColorConstants.pronexTextDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyImage(
    PropertyDetailViewModel viewModel,
    PropertyDetailModel property,
  ) {
    return _PropertyGallery(viewModel: viewModel, property: property);
  }


  Widget _buildHeaderInfo(PropertyDetailModel property) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            property.typeLabel,
            style: AppTextStyles.boldText(
              fontSize: Dimensions.px13,
              color: const Color(0xFFC9A227),
            ),
          ),
          const SizedBox(height: Dimensions.px8),
          Text(
            property.name,
            style: AppTextStyles.regularText(
              fontSize: Dimensions.px18,
              color: ColorConstants.pronexTextDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: Dimensions.px6),
          if (property.displayLocation.isNotEmpty)
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
      ),
    );
  }

  Widget _buildDeveloperCard(PropertyDetailModel property) {
    final grade = property.propertyGrade;
    final size = property.size;
    final tenants = property.tenants;
    final subtitleParts = <String>[];
    if (grade != null && grade.isNotEmpty && grade.toLowerCase() != 'sad') {
      subtitleParts.add(grade);
    }
    if (size != null && size.isNotEmpty) {
      subtitleParts.add('$size sq ft');
    }
    if (tenants != null && tenants.isNotEmpty) {
      subtitleParts.add('$tenants Tenants');
    }
    final subtitle = subtitleParts.isNotEmpty
        ? subtitleParts.join(' • ')
        : 'Property Details';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.px16,
          vertical: Dimensions.px14,
        ),
        decoration: BoxDecoration(
          color: ColorConstants.pronexPrimaryLight.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(Dimensions.px14),
        ),
        child: Row(
          children: [
            Container(
              width: Dimensions.px40,
              height: Dimensions.px40,
              decoration: BoxDecoration(
                color: ColorConstants.white,
                borderRadius: BorderRadius.circular(Dimensions.px10),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.apartment_rounded,
                color: ColorConstants.pronexPrimary,
                size: Dimensions.px22,
              ),
            ),
            const SizedBox(width: Dimensions.px12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.typeDisplay,
                    style: AppTextStyles.regularText(
                      fontSize: Dimensions.px11,
                      color: ColorConstants.pronexTextGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: Dimensions.px3),
                  Text(
                    subtitle,
                    style: AppTextStyles.semiBoldText(
                      fontSize: Dimensions.px15,
                      color: ColorConstants.pronexTextDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(
    PropertyDetailViewModel viewModel,
    PropertyDetailModel property,
  ) {
    final description = (property.description ?? '').trim();
    final highlights = property.highlights;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About this Investment',
            style: AppTextStyles.boldText(
              fontSize: Dimensions.px20,
              color: const Color(0xFF3D7A6A),
            ),
          ),
          const SizedBox(height: Dimensions.px12),
          if (description.isNotEmpty)
            Text(
              description,
              maxLines: viewModel.isAboutExpanded ? null : 5,
              overflow: viewModel.isAboutExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
              style: AppTextStyles.regularText(
                fontSize: Dimensions.px14,
                color: ColorConstants.pronexTextGrey,
                height: 1.6,
              ),
            ),
          if (highlights.isNotEmpty) ...[
            if (description.isNotEmpty) const SizedBox(height: Dimensions.px12),
            ...highlights.map(
              (h) => Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.px6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: Dimensions.px4),
                      width: Dimensions.px8,
                      height: Dimensions.px8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3FA964),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: Dimensions.px10),
                    Expanded(
                      child: Text(
                        h,
                        style: AppTextStyles.regularText(
                          fontSize: Dimensions.px14,
                          color: ColorConstants.pronexTextDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (description.isNotEmpty && description.length > 200) ...[
            const SizedBox(height: Dimensions.px8),
            GestureDetector(
              onTap: viewModel.onReadMorePressed,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    viewModel.isAboutExpanded ? 'READ LESS' : 'READ MORE',
                    style: AppTextStyles.boldText(
                      fontSize: Dimensions.px13,
                      color: const Color(0xFF3D7A6A),
                    ),
                  ),
                  const SizedBox(width: Dimensions.px4),
                  Icon(
                    viewModel.isAboutExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_right_rounded,
                    color: const Color(0xFF3D7A6A),
                    size: Dimensions.px18,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(PropertyDetailModel property) {
    final items = <(IconData, String, String)>[
      (
        Icons.trending_up_rounded,
        'Target ROI',
        property.targetROI != null && property.targetROI! > 0
            ? property.formattedTargetRoi
            : property.formattedRoi,
      ),
      // (Icons.receipt_long_rounded, 'Rental Yield',
      //     (property.rentalYield ?? 0) > 0 ? property.formattedYield : '—'),
      (Icons.diamond_outlined, 'Share Price', property.formattedSharePrice),
      (Icons.savings_rounded, 'Min Invest', property.formattedSharePrice),
      (Icons.layers_rounded, 'Total Shares', '${property.totalShares ?? 0}'),
      (Icons.groups_rounded, 'Investors', '${property.investors ?? 0}'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: Dimensions.px14,
        mainAxisSpacing: Dimensions.px14,
        childAspectRatio: 1.6,
        children: List.generate(items.length, (i) {
          final (icon, title, value) = items[i];
          return _buildMetricTile(icon: icon, title: title, value: value);
        }),
      ),
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.px16),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(Dimensions.px18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: Dimensions.px10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Dimensions.px32,
            height: Dimensions.px26,
            decoration: BoxDecoration(
              color: ColorConstants.pronexPrimaryLight,
              borderRadius: BorderRadius.circular(Dimensions.px8),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: ColorConstants.pronexPrimary,
              size: Dimensions.px18,
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: AppTextStyles.regularText(
              fontSize: Dimensions.px12,
              color: ColorConstants.pronexTextGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: Dimensions.px4),
          Text(
            value,
            style: AppTextStyles.boldText(
              fontSize: Dimensions.px17,
              color: ColorConstants.pronexTextDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesSection(PropertyDetailModel property) {
    final Map<String, IconData> iconMap = {
      'gym': Icons.fitness_center_rounded,
      'lift': Icons.elevator_rounded,
      'elevator': Icons.elevator_rounded,
      'club house': Icons.spa_rounded,
      'clubhouse': Icons.spa_rounded,
      'garden': Icons.park_rounded,
      'park': Icons.park_rounded,
      'pool': Icons.pool_rounded,
      'swimming': Icons.pool_rounded,
      'security': Icons.security_rounded,
      'cctv': Icons.videocam_rounded,
      'power backup': Icons.power_rounded,
      'parking': Icons.local_parking_rounded,
      'metro': Icons.subway_rounded,
      'ev': Icons.ev_station_rounded,
    };

    IconData pickIcon(String name) {
      final lower = name.toLowerCase();
      for (final entry in iconMap.entries) {
        if (lower.contains(entry.key)) return entry.value;
      }
      return Icons.spa_rounded;
    }

    final amenities = property.amenities;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'World-Class Amenities',
            style: AppTextStyles.boldText(
              fontSize: Dimensions.px20,
              color: const Color(0xFF3D7A6A),
            ),
          ),
          const SizedBox(height: Dimensions.px20),
          if (amenities.isEmpty)
            Text(
              'No amenities listed.',
              style: AppTextStyles.regularText(
                fontSize: Dimensions.px14,
                color: ColorConstants.pronexTextGrey,
              ),
            )
          else
            Wrap(
              spacing: Dimensions.px16,
              runSpacing: Dimensions.px16,
              children: List.generate(amenities.length, (i) {
                final name = amenities[i];
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: Dimensions.px46,
                      height: Dimensions.px46,
                      decoration: BoxDecoration(
                        color: ColorConstants.pronexPrimaryLight,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        pickIcon(name),
                        color: ColorConstants.pronexPrimary,
                        size: Dimensions.px22,
                      ),
                    ),
                    const SizedBox(width: Dimensions.px12),
                    Text(
                      name,
                      style: AppTextStyles.regularText(
                        fontSize: Dimensions.px15,
                        color: ColorConstants.pronexTextDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              }),
            ),
        ],
      ),
    );
  }

  Widget _buildLegalVaultSection(
    PropertyDetailViewModel viewModel,
    PropertyDetailModel property,
  ) {
    final apiDocs = property.documents;
    final hasBrochure = (property.brochure ?? '').isNotEmpty;
    final hasVideo = (property.video ?? '').isNotEmpty;

    final documents = <(String, IconData, Color, Color, String, String, bool)>[
      if (hasBrochure)
        (
          'brochure',
          Icons.menu_book_rounded,
          const Color(0xFFFFF0DC),
          const Color(0xFFD48B2C),
          'Brochure',
          'VIEW PROPERTY BROCHURE',
          true,
        ),
      ...apiDocs.asMap().entries.map((entry) {
        final doc = entry.value;
        final idx = entry.key;
        final palette = const [
          (Color(0xFFF9E0DF), Color(0xFFD8524E)),
          (Color(0xFFDDEBFF), Color(0xFF4A7ED1)),
          (Color(0xFFDFF3E7), Color(0xFF3FA964)),
          (Color(0xFFF4E8FB), Color(0xFF8A4FCF)),
        ];
        final (bg, fg) = palette[idx % palette.length];
        return (
          doc.id ?? 'doc-$idx',
          Icons.receipt_long_rounded,
          bg,
          fg,
          doc.name ?? 'Document ${idx + 1}',
          'PROPERTY DOCUMENT',
          true,
        );
      }),
      if (hasVideo)
        (
          'video',
          Icons.ondemand_video_rounded,
          const Color(0xFFE0F2F1),
          const Color(0xFF26A69A),
          'Property Video',
          'WALKTHROUGH VIDEO',
          false,
        ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Legal Vault',
                  style: AppTextStyles.boldText(
                    fontSize: Dimensions.px20,
                    color: const Color(0xFF3D7A6A),
                  ),
                ),
              ),
              Text(
                documents.isEmpty ? 'No document' : '${documents.length} Documents',
                style: AppTextStyles.regularText(
                  fontSize: Dimensions.px13,
                  color: ColorConstants.pronexTextGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.px16),
          if (documents.isEmpty)
            Text(
              'No document',
              style: AppTextStyles.regularText(
                fontSize: Dimensions.px14,
                color: ColorConstants.pronexTextGrey,
              ),
            )
          else
            ...List.generate(documents.length, (i) {
              final (
                id,
                icon,
                bgColor,
                iconColor,
                title,
                subtitle,
                canDownload,
              ) = documents[i];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: i == documents.length - 1 ? 0 : Dimensions.px10,
                ),
                child: _buildDocumentTile(
                  viewModel: viewModel,
                  id: id,
                  icon: icon,
                  bgColor: bgColor,
                  iconColor: iconColor,
                  title: title,
                  subtitle: subtitle,
                  canDownload: canDownload,
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildDocumentTile({
    required PropertyDetailViewModel viewModel,
    required String id,
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool canDownload,
  }) {
    final isVideo = id == 'video';

    final tileContent = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px14,
        vertical: Dimensions.px14,
      ),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(Dimensions.px16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: Dimensions.px8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: Dimensions.px46,
            height: Dimensions.px46,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(Dimensions.px12),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: Dimensions.px24),
          ),
          const SizedBox(width: Dimensions.px14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.semiBoldText(
                    fontSize: Dimensions.px15,
                    color: ColorConstants.pronexTextDark,
                  ),
                ),
                const SizedBox(height: Dimensions.px3),
                Text(
                  subtitle,
                  style: AppTextStyles.regularText(
                    fontSize: Dimensions.px11,
                    color: ColorConstants.pronexTextGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (id == 'video') {
                viewModel.playVideo();
                return;
              }

              canDownload
                  ? viewModel.onDocumentDownloadPressed(id)
                  : viewModel.onDocumentViewPressed(id);
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: Dimensions.px40,
              height: Dimensions.px40,
              alignment: Alignment.center,
              child: Icon(
                id == 'video'
                    ? Icons.play_circle_outline_rounded
                    : (canDownload
                          ? Icons.file_download_outlined
                          : Icons.visibility_outlined),
                color: ColorConstants.pronexTextGrey,
                size: Dimensions.px22,
              ),
            ),
          ),
        ],
      ),
    );

    return tileContent;
  }

  Widget _buildFundingProgressSection(PropertyDetailModel property) {
    final funded = property.displayFundedPercent;
    final duration = property.duration;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.px20),
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(Dimensions.px24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: Dimensions.px12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FUNDING PROGRESS',
                        style: AppTextStyles.regularText(
                          fontSize: Dimensions.px12,
                          color: ColorConstants.pronexTextGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: Dimensions.px6),
                      Text(
                        '${property.fundedAmount} of ${property.formattedTotalValue}',
                        style: AppTextStyles.boldText(
                          fontSize: Dimensions.px16,
                          color: ColorConstants.pronexTextDark,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.px14,
                    vertical: Dimensions.px6,
                  ),
                  decoration: BoxDecoration(
                    color: ColorConstants.pronexPrimaryLight,
                    borderRadius: BorderRadius.circular(Dimensions.px12),
                  ),
                  child: Text(
                    '$funded%',
                    style: AppTextStyles.boldText(
                      fontSize: Dimensions.px16,
                      color: ColorConstants.pronexPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimensions.px18),
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.px6),
              child: LinearProgressIndicator(
                value: funded / 100,
                minHeight: Dimensions.px10,
                backgroundColor: const Color(0xFFEEF3F1),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  ColorConstants.pronexPrimary,
                ),
              ),
            ),
            const SizedBox(height: Dimensions.px20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shares Remaining',
                        style: AppTextStyles.regularText(
                          fontSize: Dimensions.px12,
                          color: ColorConstants.pronexTextGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: Dimensions.px5),
                      Text(
                        '${property.sharesLeft ?? 0}',
                        style: AppTextStyles.boldText(
                          fontSize: Dimensions.px18,
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
                        'Tenure',
                        style: AppTextStyles.regularText(
                          fontSize: Dimensions.px12,
                          color: ColorConstants.pronexTextGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: Dimensions.px5),
                      Text(
                        duration != null && duration > 0
                            ? (duration >= 12
                                  ? '${(duration / 12).round()} Yrs'
                                  : '$duration Months')
                            : '—',
                        style: AppTextStyles.boldText(
                          fontSize: Dimensions.px18,
                          color: const Color(0xFFC9A227),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIScoreCard(PropertyDetailModel property) {
    // PRONEX AI UI removed per user request. Return an empty widget.
    return const SizedBox.shrink();
  }

  Widget _buildAIPoint(String text) {
    // AI point UI removed per user request. Return an empty widget.
    return const SizedBox.shrink();
  }

  Widget _buildBottomInvestBar(
    PropertyDetailViewModel viewModel,
    VoidCallback onCalculatePressed,
  ) {
    final sharePrice = viewModel.property?.formattedSharePrice ?? '—';
    return Container(
      padding: EdgeInsets.only(
        left: Dimensions.px20,
        right: Dimensions.px20,
        top: Dimensions.px12,
        bottom:
            Dimensions.px12 +
            MediaQuery.of(
              AppConstants.globalNavKey.currentContext!,
            ).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: Dimensions.px16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Price Per Share',
                    style: AppTextStyles.regularText(
                      fontSize: Dimensions.px11,
                      color: ColorConstants.pronexTextGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: Dimensions.px3),
                  Text(
                    sharePrice,
                    style: AppTextStyles.boldText(
                      fontSize: Dimensions.px20,
                      color: ColorConstants.pronexTextDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Dimensions.px16),
            GestureDetector(
              onTap: viewModel.isLoading || viewModel.property == null
                  ? null
                  : onCalculatePressed,
              child: Container(
                height: Dimensions.px56,
                constraints: const BoxConstraints(minWidth: Dimensions.px160),
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.px28,
                ),
                decoration: BoxDecoration(
                  color: (viewModel.isLoading || viewModel.property == null)
                      ? ColorConstants.pronexPrimary.withValues(alpha: 0.5)
                      : ColorConstants.pronexPrimary,
                  borderRadius: BorderRadius.circular(Dimensions.px28),
                  boxShadow: [
                    BoxShadow(
                      color: ColorConstants.pronexPrimary.withValues(
                        alpha: 0.25,
                      ),
                      blurRadius: Dimensions.px12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  'INVEST NOW',
                  style: AppTextStyles.boldText(
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
}

class _InvestmentKnowledgeSection extends StatefulWidget {
  const _InvestmentKnowledgeSection();

  @override
  State<_InvestmentKnowledgeSection> createState() =>
      _InvestmentKnowledgeSectionState();
}

class _InvestmentKnowledgeSectionState
    extends State<_InvestmentKnowledgeSection> {
  static const _items = <(String, String)>[
    (
      'What is fractional ownership?',
      'Fractional ownership allows multiple investors to own a percentage of a high-value property. Each investment represents a proportional ownership stake in the underlying asset.',
    ),
    (
      'What does one share represent?',
      'Each share represents a portion of ownership in the property and gives you proportional exposure to rental income and potential appreciation.',
    ),
    (
      'How do I exit my investment?',
      'You can exit based on the platform\'s available liquidity options, secondary marketplace opportunities, or the planned property exit strategy.',
    ),
  ];

  int? _openIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LEARN MORE',
            style: AppTextStyles.boldText(
              fontSize: Dimensions.px12,
              color: const Color(0xFF1B6B45),
            ).copyWith(letterSpacing: 0.8),
          ),
          const SizedBox(height: Dimensions.px8),
          Text(
            'Investment Knowledge',
            style: AppTextStyles.boldText(
              fontSize: Dimensions.px26,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: Dimensions.px16),
          ...List.generate(_items.length, (index) {
            final (question, answer) = _items[index];
            final expanded = _openIndex == index;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == _items.length - 1 ? 0 : Dimensions.px12,
              ),
              child: GestureDetector(
                onTap: () => setState(() {
                  _openIndex = expanded ? null : index;
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: ColorConstants.white,
                    borderRadius: BorderRadius.circular(Dimensions.px16),
                    border: Border.all(
                      color: expanded
                          ? const Color(0xFF3B6FD8)
                          : const Color(0xFFE6E8EE),
                      width: expanded ? 1.5 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.px16,
                          vertical: Dimensions.px16,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                question,
                                style: AppTextStyles.boldText(
                                  fontSize: Dimensions.px15,
                                  color: const Color(0xFF111827),
                                ),
                              ),
                            ),
                            const SizedBox(width: Dimensions.px12),
                            Icon(
                              expanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: const Color(0xFF6B7280),
                              size: Dimensions.px22,
                            ),
                          ],
                        ),
                      ),
                      if (expanded)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            Dimensions.px16,
                            0,
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
}

class _PropertyGallery extends StatefulWidget {
  final PropertyDetailViewModel viewModel;
  final PropertyDetailModel property;

  const _PropertyGallery({required this.viewModel, required this.property});

  @override
  State<_PropertyGallery> createState() => _PropertyGalleryState();
}

class _PropertyGalleryState extends State<_PropertyGallery> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.property.images
        .map((url) => url.trim())
        .where((url) => url.isNotEmpty)
        .toList();
    final slides = images.isEmpty ? <String>[''] : images;
    final hasVideo = (widget.property.video ?? '').isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px16),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.px24),
            child: CarouselSlider(
              carouselController: _controller,
              options: CarouselOptions(
                height: Dimensions.px220,
                enableInfiniteScroll: slides.length > 1,
                viewportFraction: 1,
                autoPlay: slides.length > 1,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(milliseconds: 700),
                autoPlayCurve: Curves.easeInOut,
                onPageChanged: (index, _) => setState(() => _current = index),
              ),
              items: List.generate(slides.length, (index) {
                return PropertyImageView(
                  urls: images.isEmpty ? const [] : images,
                  height: Dimensions.px220,
                  autoPlay: false,
                  initialIndex: index,
                  fallback: Container(
                    color: ColorConstants.pronexPrimaryLight,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.apartment_rounded,
                      color: ColorConstants.pronexPrimary.withValues(alpha: 0.45),
                      size: 64,
                    ),
                  ),
                );
              }),
            ),
          ),
          if (hasVideo)
            Positioned(
              top: Dimensions.px12,
              left: Dimensions.px12,
              child: GestureDetector(
                onTap: widget.viewModel.playVideo,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.px10,
                    vertical: Dimensions.px6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(Dimensions.px16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
                      const SizedBox(width: Dimensions.px6),
                      Text(
                        'Play Video',
                        style: AppTextStyles.semiBoldText(
                          fontSize: Dimensions.px12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: Dimensions.px12,
            right: Dimensions.px12,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.px10,
                vertical: Dimensions.px6,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(Dimensions.px12),
              ),
              child: Text(
                images.length > 1
                    ? '${_current + 1} / ${images.length}'
                    : '${images.isEmpty ? 0 : 1} Image',
                style: AppTextStyles.semiBoldText(
                  fontSize: Dimensions.px12,
                  color: ColorConstants.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
