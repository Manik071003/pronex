import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_text_style.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../core/constants/image_constants.dart';
import '../../core/utils/base_view.dart';
import '../widgets/custom_widgets/custom_snackbar.dart';
import '../widgets/property_image_view.dart';
import 'review_investment_view_model.dart';

class ReviewInvestmentView extends StatelessWidget {
  final String propertyId;
  final int shares;
  final String referralCode;

  const ReviewInvestmentView({
    super.key,
    required this.propertyId,
    this.shares = 1,
    this.referralCode = '',
  });

  static String formatFullCurrency(double value) {
    final str = value.toInt().toString();
    final len = str.length;
    String formatted = '';
    for (int i = 0; i < len; i++) {
      final fromRight = len - i;
      if (i > 0 &&
          ((fromRight > 3 && fromRight % 2 == 1) || fromRight == 4)) {
        formatted += ',';
      }
      formatted += str[i];
    }
    return '₹$formatted';
  }

  @override
  Widget build(BuildContext context) {
    return BaseView.reactive(
      viewModelBuilder: () => ReviewInvestmentViewModel(
        propertyId,
        shares: shares,
        referralCode: referralCode,
      ),
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF9F9FC),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: Dimensions.px20,
                  bottom: Dimensions.px140,
                ),
                child: Column(
                  children: [
                    _buildHeader(vm),
                    const SizedBox(height: Dimensions.px20),
                    _buildPropertyCard(vm),
                    const SizedBox(height: Dimensions.px16),
                    _buildInvestmentAmountCard(vm),
                    const SizedBox(height: Dimensions.px16),
                    _buildReferralCard(vm),
                    // const SizedBox(height: Dimensions.px16),
                    // _buildReturnsGrid(vm),
                    const SizedBox(height: Dimensions.px16),
                    _buildPaymentBreakdownCard(vm),
                    const SizedBox(height: Dimensions.px28),
                    _buildPaymentAgreementTile(vm),
                    // const SizedBox(height: Dimensions.px32),
                    // _buildTrustBadges(),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildBottomBar(vm),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(ReviewInvestmentViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px16,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: vm.onBackPressed,
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
          const SizedBox(width: Dimensions.px8),
          Expanded(
            child: Text(
              'Confirm Your Investment',
              style: AppTextStyles.boldText(
                fontSize: Dimensions.px20,
                color: ColorConstants.pronexTextDark,
              ),
            ),
          ),
          // GestureDetector(
          //   onTap: vm.onHelpPressed,
          //   child: Container(
          //     width: Dimensions.px40,
          //     height: Dimensions.px40,
          //     alignment: Alignment.center,
          //     child: Icon(
          //       Icons.help_outline_rounded,
          //       color: ColorConstants.pronexTextDark,
          //       size: Dimensions.px24,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(ReviewInvestmentViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px20,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(Dimensions.px24),
          boxShadow: _softShadow(),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(Dimensions.px14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.px12,
                      vertical: Dimensions.px6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDFF3E7),
                      borderRadius: BorderRadius.circular(Dimensions.px16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: const Color(0xFF3FA964),
                          size: Dimensions.px14,
                        ),
                        const SizedBox(width: Dimensions.px4),
                        Text(
                          'Verified',
                          style: AppTextStyles.boldText(
                            fontSize: Dimensions.px12,
                            color: const Color(0xFF3FA964),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Dimensions.px10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.px12,
                      vertical: Dimensions.px6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3D7A6A).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(Dimensions.px16),
                    ),
                    child: Text(
                      'New Listing',
                      style: AppTextStyles.semiBoldText(
                        fontSize: Dimensions.px12,
                        color: const Color(0xFF3D7A6A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.px14,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.px18),
                child: SizedBox(
                  height: Dimensions.px170,
                  width: double.infinity,
                  child: vm.propertyImage.isNotEmpty
                      ? PropertyImageView(
                          urls: [vm.propertyImage],
                          height: Dimensions.px170,
                          autoPlay: false,
                          fallback: _propertyImageFallback(),
                        )
                      : Image.asset(
                          ImageConstants.featuredProperty,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _propertyImageFallback(),
                        ),
                ),
              ),
            ),
            const SizedBox(height: Dimensions.px16),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.px20,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vm.propertyName,
                          style: AppTextStyles.boldText(
                            fontSize: Dimensions.px18,
                            color: ColorConstants.pronexTextDark,
                          ),
                        ),
                        const SizedBox(height: Dimensions.px6),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: ColorConstants.pronexTextGrey,
                              size: Dimensions.px14,
                            ),
                            const SizedBox(width: Dimensions.px4),
                            Expanded(
                              child: Text(
                                vm.propertyLocation,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'ANNUAL YIELD',
                        style: AppTextStyles.regularText(
                          fontSize: Dimensions.px11,
                          color: ColorConstants.pronexTextGrey,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: Dimensions.px4),
                      Text(
                        vm.annualYield,
                        style: AppTextStyles.boldText(
                          fontSize: Dimensions.px22,
                          color: const Color(0xFF3D7A6A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.px20),
          ],
        ),
      ),
    );
  }

  Widget _buildInvestmentAmountCard(ReviewInvestmentViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px20,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.px22,
          vertical: Dimensions.px20,
        ),
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(Dimensions.px24),
          boxShadow: _softShadow(),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'INVESTMENT AMOUNT',
                    style: AppTextStyles.regularText(
                      fontSize: Dimensions.px12,
                      color: ColorConstants.pronexTextGrey,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: Dimensions.px10),
                  Text(
                    formatFullCurrency(vm.investmentAmount),
                    style: AppTextStyles.boldText(
                      fontSize: Dimensions.px28,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: Dimensions.px14),
                  Row(
                    children: [
                      Container(
                        width: Dimensions.px22,
                        height: Dimensions.px22,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3D7A6A).withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(Dimensions.px6),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.layers_rounded,
                          color: const Color(0xFF3D7A6A),
                          size: Dimensions.px14,
                        ),
                      ),
                      const SizedBox(width: Dimensions.px8),
                      Text(
                        '${vm.sharesCount} Shares',
                        style: AppTextStyles.semiBoldText(
                          fontSize: Dimensions.px15,
                          color: ColorConstants.pronexTextDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.px12),
                  Row(
                    children: [
                      Text(
                        'Adjust shares',
                        style: AppTextStyles.regularText(
                          fontSize: Dimensions.px12,
                          color: ColorConstants.pronexTextGrey,
                        ),
                      ),
                      const Spacer(),
                      _buildShareButton(
                        icon: Icons.remove_rounded,
                        onPressed: vm.canDecrementShares
                            ? vm.decrementShares
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '${vm.shares}',
                          style: AppTextStyles.boldText(
                            fontSize: Dimensions.px14,
                            color: ColorConstants.pronexTextDark,
                          ),
                        ),
                      ),
                      _buildShareButton(
                        icon: Icons.add_rounded,
                        onPressed: vm.canIncrementShares
                            ? vm.incrementShares
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.px6),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: Dimensions.px30,
                    ),
                    child: Text(
                      '1 Share = 1% Ownership',
                      style: AppTextStyles.regularText(
                        fontSize: Dimensions.px13,
                        color: ColorConstants.pronexTextGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Dimensions.px12),
            SizedBox(
              width: Dimensions.px110,
              height: Dimensions.px110,
              child: CustomPaint(
                painter: _OwnershipRingPainter(
                  progress: vm.ownershipPercent / 100,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${vm.ownershipPercent.toInt()}%',
                        style: AppTextStyles.boldText(
                          fontSize: Dimensions.px26,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      Text(
                        'OWNERSHIP',
                        style: AppTextStyles.regularText(
                          fontSize: Dimensions.px10,
                          color: ColorConstants.pronexTextGrey,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        iconSize: 18,
        style: IconButton.styleFrom(
          backgroundColor: const Color(0xFFE8F2EF),
          foregroundColor: const Color(0xFF3D7A6A),
          disabledBackgroundColor: const Color(0xFFF1F3F4),
          disabledForegroundColor: const Color(0xFFB7BEC4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.px8),
          ),
        ),
        icon: Icon(icon),
      ),
    );
  }

  Widget _buildReferralCard(ReviewInvestmentViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.px18),
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(Dimensions.px20),
          boxShadow: _softShadow(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Referral Code',
              style: AppTextStyles.boldText(
                fontSize: Dimensions.px16,
                color: ColorConstants.pronexTextDark,
              ),
            ),
            const SizedBox(height: Dimensions.px4),
            Text(
              'Optional - apply a referral code before payment.',
              style: AppTextStyles.regularText(
                fontSize: Dimensions.px12,
                color: ColorConstants.pronexTextGrey,
              ),
            ),
            const SizedBox(height: Dimensions.px12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: vm.setReferralCode,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Enter referral code',
                      isDense: true,
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.px10),
                        borderSide: const BorderSide(color: Color(0xFFE1E5EA)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.px10),
                        borderSide: const BorderSide(color: Color(0xFFE1E5EA)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.px10),
                ElevatedButton(
                  onPressed: vm.referralCode.isEmpty || vm.isValidatingReferral
                      ? null
                      : vm.validateReferral,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: ColorConstants.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    minimumSize: const Size(0, 46),
                  ),
                  child: vm.isValidatingReferral
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Apply'),
                ),
              ],
            ),
            if (vm.referralMessage != null) ...[
              const SizedBox(height: Dimensions.px8),
              Text(
                vm.referralMessage!,
                style: AppTextStyles.semiBoldText(
                  fontSize: Dimensions.px12,
                  color: vm.referralValidated
                      ? const Color(0xFF3FA964)
                      : ColorConstants.radicalRed,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentAgreementTile(ReviewInvestmentViewModel vm) {
    const agreementUrl = 'https://pronexworld.com/';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: InkWell(
        onTap: vm.togglePaymentAgreement,
        borderRadius: BorderRadius.circular(Dimensions.px20),
        child: Container(
          padding: const EdgeInsets.all(Dimensions.px16),
          decoration: BoxDecoration(
            color: ColorConstants.white,
            borderRadius: BorderRadius.circular(Dimensions.px20),
            boxShadow: _softShadow(),
          ),
          child: Row(
            children: [
              Checkbox(
                value: vm.paymentAgreementAccepted,
                onChanged: (_) => vm.togglePaymentAgreement(),
                activeColor: const Color(0xFF3D7A6A),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'I agree to the payment terms.',
                      style: AppTextStyles.regularText(
                        fontSize: Dimensions.px13,
                        color: ColorConstants.pronexTextGrey,
                      ),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () async {
                        final uri = Uri.parse(agreementUrl);
                        final opened = await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                        if (!opened) {
                          AppSnackBar.show(
                            message: 'Unable to open the agreement',
                            isError: true,
                          );
                        }
                      },
                      child: Text(
                        'View Agreement',
                        style: AppTextStyles.regularText(
                          fontSize: Dimensions.px13,
                          color: ColorConstants.pronexPrimary,
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
  Widget _propertyImageFallback() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE0ECE8), Color(0xFFCADFD9)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.apartment_rounded,
          color: const Color(0xFF3D7A6A).withValues(alpha: 0.4),
          size: Dimensions.px64,
        ),
      ),
    );
  }

  Widget _buildReturnsGrid(ReviewInvestmentViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px20,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildReturnCard(
                  label: 'EXPECTED ROI',
                  value: vm.expectedRoi,
                  valueColor: const Color(0xFF3D7A6A),
                  subtitle: 'Pre-tax IRR',
                  subtitleColor: ColorConstants.pronexTextGrey,
                ),
              ),
              const SizedBox(width: Dimensions.px12),
              Expanded(
                child: _buildReturnCard(
                  label: 'MONTHLY RENTAL',
                  value: vm.monthlyRental,
                  valueColor: const Color(0xFF0F172A),
                  subtitle: 'Starting Month 1',
                  subtitleColor: ColorConstants.pronexTextGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.px12),
          Row(
            children: [
              Expanded(
                child: _buildReturnCard(
                  label: 'ANNUAL RENTAL',
                  value: vm.annualRental,
                  valueColor: const Color(0xFF0F172A),
                  subtitle: 'Distributed quarterly',
                  subtitleColor: ColorConstants.pronexTextGrey,
                ),
              ),
              const SizedBox(width: Dimensions.px12),
              Expanded(
                child: _buildReturnCard(
                  label: '5-YEAR EST.',
                  value: vm.fiveYearEst,
                  valueColor: const Color(0xFFC9A227),
                  subtitle: 'Projected value',
                  subtitleColor: ColorConstants.pronexTextGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReturnCard({
    required String label,
    required String value,
    required Color valueColor,
    required String subtitle,
    required Color subtitleColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.px18),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F2FF),
        borderRadius: BorderRadius.circular(Dimensions.px20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.regularText(
              fontSize: Dimensions.px11,
              color: ColorConstants.pronexTextGrey,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: Dimensions.px10),
          Text(
            value,
            style: AppTextStyles.boldText(
              fontSize: Dimensions.px20,
              color: valueColor,
            ),
          ),
          const SizedBox(height: Dimensions.px4),
          Text(
            subtitle,
            style: AppTextStyles.regularText(
              fontSize: Dimensions.px12,
              color: subtitleColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentBreakdownCard(ReviewInvestmentViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px20,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.px22,
          vertical: Dimensions.px22,
        ),
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(Dimensions.px24),
          boxShadow: _softShadow(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Details',
              style: AppTextStyles.boldText(
                fontSize: Dimensions.px19,
                color: ColorConstants.pronexTextDark,
              ),
            ),
            const SizedBox(height: Dimensions.px22),
            _buildBreakdownRow(
              'Property Value (20 Shares)',
              formatFullCurrency(vm.propertyValue),
            ),
            const SizedBox(height: Dimensions.px16),
            _buildBreakdownRow(
              'Platform Onboarding Fee',
              formatFullCurrency(vm.platformFee),
            ),
            const SizedBox(height: Dimensions.px16),
            _buildBreakdownRow(
              'Taxes & Legal Filings',
              formatFullCurrency(vm.taxLegalFee),
            ),
            const SizedBox(height: Dimensions.px18),
            Container(
              height: Dimensions.px1,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE5E7EB),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              child: CustomPaint(
                painter: _DottedLinePainter(
                  color: const Color(0xFFE5E7EB),
                ),
              ),
            ),
            const SizedBox(height: Dimensions.px18),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Total Payable',
                    style: AppTextStyles.boldText(
                      fontSize: Dimensions.px17,
                      color: ColorConstants.pronexTextDark,
                    ),
                  ),
                ),
                Text(
                  formatFullCurrency(vm.totalPayable),
                  style: AppTextStyles.boldText(
                    fontSize: Dimensions.px20,
                    color: const Color(0xFF3D7A6A),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.regularText(
              fontSize: Dimensions.px15,
              color: ColorConstants.pronexTextGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.semiBoldText(
            fontSize: Dimensions.px15,
            color: ColorConstants.pronexTextDark,
          ),
        ),
      ],
    );
  }

  Widget _buildLegalAgreementsTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px20,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Legal Agreements',
          style: AppTextStyles.boldText(
            fontSize: Dimensions.px19,
            color: const Color(0xFF0F172A),
          ),
        ),
      ),
    );
  }

  Widget _buildAgreementTile({
    required String title,
    required bool accepted,
    required VoidCallback onToggle,
    required VoidCallback onView,
    required VoidCallback onDownload,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px20,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.px16,
          vertical: Dimensions.px16,
        ),
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(Dimensions.px20),
          boxShadow: _softShadow(),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: Dimensions.px2,
              ),
              child: GestureDetector(
                onTap: onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  width: Dimensions.px24,
                  height: Dimensions.px24,
                  decoration: BoxDecoration(
                    color: accepted
                        ? const Color(0xFF3D7A6A)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(Dimensions.px7),
                    border: Border.all(
                      color: accepted
                          ? const Color(0xFF3D7A6A)
                          : const Color(0xFFC9D0DB),
                      width: Dimensions.px2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: accepted
                      ? Icon(
                          Icons.check_rounded,
                          color: ColorConstants.white,
                          size: Dimensions.px16,
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(width: Dimensions.px14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.semiBoldText(
                      fontSize: Dimensions.px16,
                      color: ColorConstants.pronexTextDark,
                    ),
                  ),
                  const SizedBox(height: Dimensions.px10),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onView,
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.visibility_outlined,
                              color: const Color(0xFF3D7A6A),
                              size: Dimensions.px16,
                            ),
                            const SizedBox(width: Dimensions.px5),
                            Text(
                              'View',
                              style: AppTextStyles.semiBoldText(
                                fontSize: Dimensions.px13,
                                color: const Color(0xFF3D7A6A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: Dimensions.px22),
                      GestureDetector(
                        onTap: onDownload,
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.file_download_outlined,
                              color: const Color(0xFF3D7A6A),
                              size: Dimensions.px16,
                            ),
                            const SizedBox(width: Dimensions.px5),
                            Text(
                              'Download',
                              style: AppTextStyles.semiBoldText(
                                fontSize: Dimensions.px13,
                                color: const Color(0xFF3D7A6A),
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
          ],
        ),
      ),
    );
  }

  Widget _buildTrustBadges() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px30,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTrustBadge(
              icon: Icons.shield_rounded,
              label: '256-BIT SSL',
            ),
          ),
          Expanded(
            child: _buildTrustBadge(
              icon: Icons.gavel_rounded,
              label: 'RBI-COMPLIANT',
            ),
          ),
          Expanded(
            child: _buildTrustBadge(
              icon: Icons.verified_rounded,
              label: 'LEGALLY VERIFIED',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustBadge({
    required IconData icon,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: ColorConstants.pronexTextGrey,
          size: Dimensions.px28,
        ),
        const SizedBox(height: Dimensions.px6),
        Text(
          label,
          style: AppTextStyles.regularText(
            fontSize: Dimensions.px11,
            color: ColorConstants.pronexTextGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(ReviewInvestmentViewModel vm) {
    final canContinue = vm.canContinue;
    return Container(
      padding: EdgeInsets.only(
        left: Dimensions.px20,
        right: Dimensions.px20,
        top: Dimensions.px12,
        bottom: Dimensions.px12,
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: Dimensions.px2,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL AMOUNT',
                    style: AppTextStyles.regularText(
                      fontSize: Dimensions.px11,
                      color: ColorConstants.pronexTextGrey,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: Dimensions.px4),
                  Text(
                    formatFullCurrency(vm.totalPayable),
                    style: AppTextStyles.boldText(
                      fontSize: Dimensions.px22,
                      color: ColorConstants.pronexTextDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Dimensions.px14),
            Expanded(
              child: GestureDetector(
                onTap: canContinue && !vm.isBusy ? vm.onContinueToPayment : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: Dimensions.px64,
                  decoration: BoxDecoration(
                    color: canContinue
                        ? const Color(0xFF3D7A6A)
                        : const Color(0xFFA8C5BD),
                    borderRadius: BorderRadius.circular(Dimensions.px22),
                    boxShadow: canContinue
                        ? [
                            BoxShadow(
                              color: const Color(0xFF3D7A6A)
                                  .withValues(alpha: 0.25),
                              blurRadius: Dimensions.px14,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: vm.isBusy
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Continue to Payment',
                        style: AppTextStyles.boldText(
                          fontSize: Dimensions.px15,
                          color: ColorConstants.white,
                        ),
                      ),
                      const SizedBox(width: Dimensions.px8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: ColorConstants.white,
                        size: Dimensions.px18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BoxShadow> _softShadow() {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.03),
        blurRadius: Dimensions.px10,
        offset: const Offset(0, 2),
      ),
    ];
  }
}

class _OwnershipRingPainter extends CustomPainter {
  final double progress;

  _OwnershipRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final stroke = Dimensions.px8;
    final radius = (size.width - stroke) / 2;

    final trackPaint = Paint()
      ..color = const Color(0xFFEEF3F1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    canvas.drawCircle(center, radius, trackPaint);

    final progressPaint = Paint()
      ..color = const Color(0xFF3D7A6A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final sweep = 2 * 3.14159265 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159265 / 2,
      sweep,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _OwnershipRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _DottedLinePainter extends CustomPainter {
  final Color color;
  final double dash;
  final double gap;

  _DottedLinePainter({
    required this.color,
    this.dash = 4,
    this.gap = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    double x = 0;
    while (x < size.width) {
      final end = (x + dash).clamp(0.0, size.width);
      canvas.drawLine(
        Offset(x, size.height / 2),
        Offset(end, size.height / 2),
        paint,
      );
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DottedLinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
