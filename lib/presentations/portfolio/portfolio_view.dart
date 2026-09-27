import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_text_style.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../core/models/portfolio_model.dart';
import '../../core/utils/base_view.dart';
import '../widgets/custom_widgets/custom_snackbar.dart';
import '../saved/saved_view.dart';
import '../widgets/property_image_view.dart';
import 'portfolio_view_model.dart';

class PortfolioView extends StatelessWidget {
  final VoidCallback? onExploreMoreProperties;

  const PortfolioView({super.key, this.onExploreMoreProperties});

  @override
  Widget build(BuildContext context) {
    return BaseView.reactive(
      viewModelBuilder: () => PortfolioViewModel(),
      onViewModelReady: (viewModel) => viewModel.fetchPortfolio(),
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: ColorConstants.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: Dimensions.px100),
              child: Column(
                children: [
                  _buildHeader(viewModel),
                  const SizedBox(height: Dimensions.px20),
                  _buildStatsCard(viewModel),
                  const SizedBox(height: Dimensions.px32),
                  _buildTabs(viewModel),
                  const SizedBox(height: Dimensions.px24),
                  _buildTabContent(context, viewModel),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(PortfolioViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px20,
        vertical: Dimensions.px16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Portfolio',
                  style: AppTextStyles.boldText(
                    fontSize: Dimensions.px24,
                    color: ColorConstants.pronexTextDark,
                  ),
                ),
                const SizedBox(height: Dimensions.px8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Track your investments and returns across ',
                        style: AppTextStyles.regularText(
                          fontSize: Dimensions.px14,
                          color: ColorConstants.pronexTextGrey,
                        ),
                      ),
                      TextSpan(
                        text: 'premium',
                        style: AppTextStyles.boldText(
                          fontSize: Dimensions.px14,
                          color: ColorConstants.pronexTextDark,
                        ),
                      ),
                      TextSpan(
                        text: ' global assets.',
                        style: AppTextStyles.regularText(
                          fontSize: Dimensions.px14,
                          color: ColorConstants.pronexTextGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Dimensions.px12),
          GestureDetector(
            onTap: () {
              onExploreMoreProperties?.call();
              viewModel.onExploreMoreProperties();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.px20,
                vertical: Dimensions.px16,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF116052),
                borderRadius: BorderRadius.circular(Dimensions.px16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Explore More',
                    style: AppTextStyles.semiBoldText(
                      fontSize: Dimensions.px14,
                      color: ColorConstants.white,
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

  Widget _buildStatsCard(PortfolioViewModel viewModel) {
    final summary = viewModel.summary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px10),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.px12,
          vertical: Dimensions.px20,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFECF7F1),
          borderRadius: BorderRadius.circular(Dimensions.px15),
        ),
        child: viewModel.isLoading
            ? const SizedBox(
                height: Dimensions.px52,
                child: Center(
                  child: SizedBox(
                    width: Dimensions.px22,
                    height: Dimensions.px22,
                    child: CircularProgressIndicator(
                      color: ColorConstants.pronexPrimary,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              )
            : Column(
                children: [
                  if (viewModel.errorMessage != null) ...[
                    GestureDetector(
                      onTap: viewModel.retry,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: Dimensions.px12),
                        child: Text(
                          'Unable to load stats. Tap to retry.',
                          style: AppTextStyles.regularText(
                            fontSize: Dimensions.px12,
                            color: ColorConstants.radicalRed,
                          ),
                        ),
                      ),
                    ),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          icon: Icons.dashboard_customize_rounded,
                          label: 'TOTAL INVESTED',
                          value: summary.formattedTotalInvested,
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          icon: Icons.pie_chart_outline_rounded,
                          label: 'SHARES OWNED',
                          value: summary.formattedSharesOwned,
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          icon: Icons.show_chart_rounded,
                          label: 'EXPECTED RETURNS',
                          value: summary.formattedExpectedReturn,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: Dimensions.px28,
          height: Dimensions.px28,
          decoration: BoxDecoration(
            color: ColorConstants.white,
            borderRadius: BorderRadius.circular(Dimensions.px8),
          ),
          child: Icon(
            icon,
            color: ColorConstants.pronexPrimary,
            size: Dimensions.px16,
          ),
        ),
        const SizedBox(width: Dimensions.px6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.boldText(
                  fontSize: Dimensions.px10,
                  color: ColorConstants.pronexTextGrey,
                ),
              ),
              const SizedBox(height: Dimensions.px2),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.boldText(
                  fontSize: Dimensions.px15,
                  color: ColorConstants.pronexTextDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabs(PortfolioViewModel viewModel) {
    return SizedBox(
      height: Dimensions.px44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
        scrollDirection: Axis.horizontal,
        itemCount: viewModel.tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: Dimensions.px8),
        itemBuilder: (context, i) {
          final selected = viewModel.selectedTab == i;
          return GestureDetector(
            onTap: () => viewModel.setTab(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFB9F2CD) : Colors.transparent,
                borderRadius: BorderRadius.circular(Dimensions.px14),
                border: Border(
                  bottom: BorderSide(
                    color: selected
                        ? ColorConstants.pronexPrimary
                        : Colors.transparent,
                    width: Dimensions.px3,
                  ),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                viewModel.tabs[i],
                style: AppTextStyles.semiBoldText(
                  fontSize: Dimensions.px15,
                  color: selected
                      ? ColorConstants.pronexTextDark
                      : ColorConstants.pronexTextGrey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, PortfolioViewModel viewModel) {
    switch (viewModel.selectedTab) {
      case 0:
        if (viewModel.investments.isEmpty) {
          return _buildEmptyState(
            'No Active Investments',
            'Start investing by exploring premium properties.',
          );
        }
        return _buildInvestmentsList(viewModel);
      case 1:
        if (viewModel.pendingInvestments.isEmpty) {
          return _buildEmptyState(
            'No Pending Investments',
            'Pending investments will appear here.',
          );
        }
        return _buildPendingInvestmentsList(viewModel.pendingInvestments);
      case 2:
        return const SavedView(embedded: true);
      case 3:
        if (viewModel.paymentHistory.isEmpty) {
          return _buildEmptyState(
            'No Payment History',
            'Your payment transactions will appear here.',
          );
        }
        return _buildPaymentHistoryList(viewModel.paymentHistory);
      case 4:
        return _buildDocumentsSection(context, viewModel);
      case 5:
        return _buildEmptyState(
          'Support & Exit',
          'Contact support for assistance or exit requests.',
        );
      case 6:
        return _buildReferralSection(viewModel);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildInvestmentsList(PortfolioViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Column(
        children: viewModel.investments.map((investment) {
          return Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.px12),
            child: _PortfolioInvestmentCard(
              investment: investment,
              onSubmitPayment: (reference, method, document) =>
                  viewModel.submitPaymentApproval(
                investment: investment,
                paymentReference: reference,
                paymentMethod: method,
                document: document,
              ),
              onRequestExit: (shares, reason) => viewModel.requestExit(
                investment: investment,
                shares: shares,
                reason: reason,
              ),
              onRequestOwnership: () => viewModel.requestOwnership(
                investment: investment,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReferralSection(PortfolioViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF075B4D),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.card_giftcard_outlined, size: 16, color: Colors.white),
                      SizedBox(width: 6),
                      Text('Refer & Earn', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Invite Friends & Earn Rewards', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 6),
                          Text('Share your referral link. Your reward becomes eligible after your referred investor successfully completes an investment.', style: TextStyle(color: Colors.white.withValues(alpha: 0.78), fontSize: 13, height: 1.45)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Icon(Icons.people_outline_rounded, color: Color(0xFFB9F2CD), size: 28),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(child: _referralValueCard('YOUR REFERRAL CODE', viewModel.referralCode.isEmpty ? '—' : viewModel.referralCode, viewModel.referralCode)),
                    const SizedBox(width: 14),
                    Expanded(child: _referralValueCard('YOUR REFERRAL LINK', viewModel.referralLink.isEmpty ? '—' : viewModel.referralLink, viewModel.referralLink)),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: viewModel.referralLink.isEmpty ? null : () => _copyReferral(viewModel.referralLink, 'Referral link copied'),
                  icon: const Icon(Icons.share_outlined, size: 17),
                  label: const Text('Share Referral Link'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF32D39B), foregroundColor: const Color(0xFF063F38), elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: ColorConstants.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xFFE8ECEF))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Referral Rewards', style: AppTextStyles.boldText(fontSize: 17, color: ColorConstants.pronexTextDark)), const SizedBox(height: 5), Text('Track rewards earned from your successful referrals.', style: AppTextStyles.regularText(fontSize: 12, color: ColorConstants.pronexTextGrey))])),
                      Container(width: 38, height: 38, decoration: BoxDecoration(color: const Color(0xFFE9FBF3), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.card_giftcard_outlined, color: ColorConstants.pronexPrimary, size: 20)),
                    ],
                  ),
                ),
                const Divider(height: 1),
                if (viewModel.referralRewards.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 42),
                    child: Column(children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.people_outline_rounded, color: Color(0xFF9AA7B7))), const SizedBox(height: 12), Text('No referral rewards yet', style: AppTextStyles.semiBoldText(fontSize: 14, color: ColorConstants.pronexTextDark))]),
                  )
                else
                  ...viewModel.referralRewards.map(_buildRewardRow),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _referralValueCard(String label, String value, String copyValue) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white.withValues(alpha: 0.16))),
      child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Color(0xFFB9F2CD), fontSize: 10, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800))])), IconButton(onPressed: copyValue.isEmpty ? null : () => _copyReferral(copyValue, '$label copied'), icon: const Icon(Icons.copy_outlined, color: Colors.white, size: 18))]),
    );
  }

  Widget _buildRewardRow(Map<String, dynamic> reward) {
    final title = (reward['name'] ?? reward['propertyName'] ?? 'Referral reward').toString();
    final amount = (reward['amount'] ?? reward['reward'] ?? '').toString();
    return ListTile(leading: const Icon(Icons.check_circle_outline, color: ColorConstants.pronexPrimary), title: Text(title), trailing: Text(amount));
  }

  void _copyReferral(String value, String message) {
    Clipboard.setData(ClipboardData(text: value));
    AppSnackBar.show(message: message);
  }

  Widget _buildPendingInvestmentsList(
    List<PendingPortfolioInvestment> investments,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Column(
        children: investments
            .map((investment) => Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.px16),
                  child: _PendingInvestmentCard(investment: investment),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildPaymentHistoryList(
    List<PendingPortfolioInvestment> payments,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Column(
        children: payments
            .map((payment) => Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.px16),
                  child: _PendingInvestmentCard(investment: payment),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.px40),
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(Dimensions.px24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: Dimensions.px16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: Dimensions.px70,
              height: Dimensions.px70,
              decoration: BoxDecoration(
                color: ColorConstants.pronexPrimaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inbox_outlined,
                color: ColorConstants.pronexPrimary,
                size: Dimensions.px32,
              ),
            ),
            const SizedBox(height: Dimensions.px20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.boldText(
                fontSize: Dimensions.px18,
                color: ColorConstants.pronexTextDark,
              ),
            ),
            const SizedBox(height: Dimensions.px8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.regularText(
                fontSize: Dimensions.px14,
                color: ColorConstants.pronexTextGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsSection(
    BuildContext context,
    PortfolioViewModel viewModel,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Column(
        children: [
          _buildPersonalDetailsCard(viewModel.portfolio.kycDetails),
          const SizedBox(height: Dimensions.px24),
          _buildIdentityDetailsCard(viewModel.portfolio.kycDetails),
          const SizedBox(height: Dimensions.px24),
          _buildAdditionalDetailsCard(viewModel.portfolio.kycDetails),
          const SizedBox(height: Dimensions.px24),
          _buildDocumentsCard(context, viewModel.portfolio.documents),
        ],
      ),
    );
  }

  Widget _buildPersonalDetailsCard(PortfolioKycDetails details) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.px28),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(Dimensions.px24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: Dimensions.px20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: Dimensions.px28,
                height: Dimensions.px28,
                decoration: BoxDecoration(
                  color: ColorConstants.pronexPrimaryLight,
                  borderRadius: BorderRadius.circular(Dimensions.px8),
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: ColorConstants.pronexPrimary,
                  size: Dimensions.px16,
                ),
              ),
              const SizedBox(width: Dimensions.px12),
              Text(
                'Personal Details',
                style: AppTextStyles.boldText(
                  fontSize: Dimensions.px19,
                  color: ColorConstants.pronexTextDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.px28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildDetailRow(
                  label: 'Full Name',
                  value: _display(details.fullName),
                ),
              ),
              const SizedBox(width: Dimensions.px40),
              Expanded(
                child: _buildDetailRow(
                  label: 'Email',
                  value: _display(details.email),
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.px24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildDetailRow(
                  label: 'DOB',
                  value: _formatDate(details.dob),
                ),
              ),
              const SizedBox(width: Dimensions.px40),
              Expanded(
                child: _buildDetailRow(
                  label: 'Address',
                  value: _display(details.address),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityDetailsCard(PortfolioKycDetails details) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.px28),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(Dimensions.px24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: Dimensions.px20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: Dimensions.px28,
                height: Dimensions.px28,
                decoration: BoxDecoration(
                  color: ColorConstants.pronexPrimaryLight,
                  borderRadius: BorderRadius.circular(Dimensions.px8),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: ColorConstants.pronexPrimary,
                  size: Dimensions.px16,
                ),
              ),
              const SizedBox(width: Dimensions.px12),
              Text(
                'Identity Details',
                style: AppTextStyles.boldText(
                  fontSize: Dimensions.px19,
                  color: ColorConstants.pronexTextDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.px28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildDetailRow(
                  label: 'PAN Number',
                  value: _maskValue(details.panNumber, 4),
                ),
              ),
              const SizedBox(width: Dimensions.px40),
              Expanded(
                child: _buildDetailRow(
                  label: 'Aadhaar Number',
                  value: _maskValue(details.aadhaarNumber, 4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalDetailsCard(PortfolioKycDetails details) {
    return _buildInfoCard(
      title: 'Nominee & Bank Details',
      icon: Icons.account_balance_outlined,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildDetailRow(
                label: 'Nominee',
                value: _display(details.nominee['name']),
              ),
            ),
            const SizedBox(width: Dimensions.px40),
            Expanded(
              child: _buildDetailRow(
                label: 'Beneficiary',
                value: _display(details.bank['beneficiaryName']),
              ),
            ),
          ],
        ),
        const SizedBox(height: Dimensions.px24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildDetailRow(
                label: 'Account Number',
                value: _maskValue(details.bank['accountNumber'], 4),
              ),
            ),
            const SizedBox(width: Dimensions.px40),
            Expanded(
              child: _buildDetailRow(
                label: 'IFSC',
                value: _display(details.bank['ifsc']),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDocumentsCard(
    BuildContext context,
    List<PortfolioDocument> documents,
  ) {
    return _buildInfoCard(
      title: 'Uploaded Documents',
      icon: Icons.folder_open_outlined,
      children: documents.isEmpty
          ? [
              _buildDetailRow(
                label: 'Documents',
                value: 'No documents available',
              ),
            ]
          : documents.map((document) {
              return GestureDetector(
                onTap: document.url.isEmpty
                    ? null
                    : () => _openDocument(context, document),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.px16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        color: ColorConstants.pronexPrimary,
                        size: Dimensions.px20,
                      ),
                      const SizedBox(width: Dimensions.px12),
                      Expanded(
                        child: _buildDetailRow(
                          label: document.type.toUpperCase(),
                          value: document.name,
                        ),
                      ),
                      if (document.url.isNotEmpty)
                        Icon(
                          Icons.visibility_outlined,
                          color: ColorConstants.pronexPrimary,
                          size: Dimensions.px18,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
    );
  }

  void _openDocument(BuildContext context, PortfolioDocument document) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PortfolioDocumentPage(document: document),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.px28),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(Dimensions.px24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: Dimensions.px20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: ColorConstants.pronexPrimary,
                size: Dimensions.px20,
              ),
              const SizedBox(width: Dimensions.px12),
              Text(
                title,
                style: AppTextStyles.boldText(
                  fontSize: Dimensions.px19,
                  color: ColorConstants.pronexTextDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.px28),
          ...children,
        ],
      ),
    );
  }

  String _display(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? 'Not provided' : text;
  }

  String _formatDate(String value) {
    if (value.isEmpty) return 'Not provided';
    return value.split('T').first;
  }

  String _maskValue(dynamic value, int visibleCharacters) {
    final text = value?.toString().replaceAll(' ', '') ?? '';
    if (text.isEmpty) return 'Not provided';
    if (text.length <= visibleCharacters) return text;
    return '${text.substring(0, 2)}****${text.substring(text.length - visibleCharacters)}';
  }

  Widget _buildDetailRow({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.regularText(
            fontSize: Dimensions.px12,
            color: ColorConstants.pronexTextGrey,
          ),
        ),
        const SizedBox(height: Dimensions.px6),
        Text(
          value,
          style: AppTextStyles.semiBoldText(
            fontSize: Dimensions.px14,
            color: ColorConstants.pronexTextDark,
          ),
        ),
      ],
    );
  }
}

class _PendingInvestmentCard extends StatelessWidget {
  final PendingPortfolioInvestment investment;

  const _PendingInvestmentCard({required this.investment});

  @override
  Widget build(BuildContext context) {
    final perShare = investment.shares > 0
        ? investment.amount / investment.shares
        : 0.0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8ECEF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 620;
          if (compact) {
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildImage(),
                    const SizedBox(width: 14),
                    Expanded(child: _buildPropertyDetails()),
                  ],
                ),
                const SizedBox(height: 14),
                _buildPaymentSummary(perShare, compact: true),
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildImage(),
              const SizedBox(width: 18),
              Expanded(child: _buildPropertyDetails()),
              const SizedBox(width: 20),
              _buildPaymentSummary(perShare),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPropertyDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          investment.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.boldText(
            fontSize: 17,
            color: ColorConstants.pronexTextDark,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          investment.location,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.regularText(
            fontSize: 13,
            color: ColorConstants.pronexTextGrey,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'You paid ${investment.formattedAmount} for ${investment.shares} shares',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.regularText(
            fontSize: 13,
            color: const Color(0xFF466080),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _formatDate(investment.submittedAt),
          style: AppTextStyles.regularText(
            fontSize: 12,
            color: ColorConstants.pronexTextGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSummary(double perShare, {bool compact = false}) {
    return SizedBox(
      width: compact ? double.infinity : 220,
      child: Row(
        mainAxisAlignment: compact
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                investment.formattedAmount,
                style: AppTextStyles.boldText(
                  fontSize: 18,
                  color: ColorConstants.pronexTextDark,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${investment.shares} Shares • ${_currency(perShare)} / share',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.regularText(
                  fontSize: 12,
                  color: ColorConstants.pronexTextGrey,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          _statusBadge(),
        ],
      ),
    );
  }

  Widget _buildImage() {
    const fallback =
        'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=500&q=80';
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 74,
        height: 74,
        child: PropertyImageView(
          urls: [investment.imageUrl.isEmpty ? fallback : investment.imageUrl],
          width: 74,
          height: 74,
          autoPlay: false,
          fallback: Container(
            color: ColorConstants.pronexPrimaryLight,
            child: const Icon(
              Icons.apartment_rounded,
              color: ColorConstants.pronexPrimary,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDDE3E8)),
      ),
      child: Text(
        investment.displayStatus,
        style: AppTextStyles.semiBoldText(
          fontSize: 12,
          color: const Color(0xFF39516D),
        ),
      ),
    );
  }

  Widget _detail(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.regularText(
              fontSize: 13,
              color: ColorConstants.pronexTextGrey,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: AppTextStyles.boldText(
              fontSize: 17,
              color: ColorConstants.pronexTextDark,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String value) {
    if (value.trim().isEmpty) return '—';
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    return '${parsed.day}/${parsed.month}/${parsed.year}';
  }

  String _currency(double value) {
    final formatted = value.round().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
    return '₹$formatted';
  }
}

class _PortfolioInvestmentCard extends StatefulWidget {
  final PortfolioInvestment investment;
  final Future<void> Function(
    String reference,
    String method,
    File document,
  ) onSubmitPayment;
  final Future<void> Function(int shares, String reason) onRequestExit;
  final Future<void> Function() onRequestOwnership;

  const _PortfolioInvestmentCard({
    required this.investment,
    required this.onSubmitPayment,
    required this.onRequestExit,
    required this.onRequestOwnership,
  });

  @override
  State<_PortfolioInvestmentCard> createState() =>
      _PortfolioInvestmentCardState();
}

class _PortfolioInvestmentCardState extends State<_PortfolioInvestmentCard> {
  bool expanded = false;
  final _referenceController = TextEditingController();
  final _exitSharesController = TextEditingController(text: '10');
  final _exitReasonController = TextEditingController();
  File? _paymentProof;
  bool _isSubmittingPayment = false;
  bool _isSubmittingExit = false;
  bool _isSubmittingOwnership = false;
  String? _exitError;

  PortfolioInvestment get investment => widget.investment;

  @override
  void dispose() {
    _referenceController.dispose();
    _exitSharesController.dispose();
    _exitReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ownership = investment.shares.toDouble();
    return Container(
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(Dimensions.px24),
        border: Border.all(color: const Color(0xFFE6EBEF)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A3C34).withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => expanded = !expanded),
            borderRadius: BorderRadius.circular(Dimensions.px20),
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.px16),
              child: Column(
                children: [
                  Row(
                    children: [
                      _image(),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              investment.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.boldText(
                                fontSize: 18,
                                color: ColorConstants.pronexTextDark,
                              ),
                            ),
                            if (investment.location.isNotEmpty) ...[
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 15, color: ColorConstants.pronexPrimary),
                                  const SizedBox(width: 4),
                                  Expanded(child: Text(investment.location, maxLines: 1, overflow: TextOverflow.ellipsis, style: _smallStyle())),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      _roiBadge(),
                      const SizedBox(width: 8),
                      _expandButton(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(height: 1, color: const Color(0xFFEFF2F4)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _summary('SHARES', '${investment.shares}'),
                      _summary('OWNERSHIP', '${ownership.toStringAsFixed(0)}%', valueColor: ColorConstants.pronexPrimary),
                      _summary('INVESTED', investment.formattedInvestedAmount),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (expanded) _details(ownership),
        ],
      ),
    );
  }

  Widget _image() {
    const fallback = 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=500&q=80';
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 112,
        height: 92,
        child: PropertyImageView(
          urls: [investment.imageUrl.isEmpty ? fallback : investment.imageUrl],
          width: 112,
          height: 92,
          autoPlay: false,
          fallback: Container(
            color: ColorConstants.pronexPrimaryLight,
            child: const Icon(Icons.apartment_rounded, color: ColorConstants.pronexPrimary, size: 34),
          ),
        ),
      ),
    );
  }

  Widget _roiBadge() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFFE9FBF3),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFBDEDD7)),
        ),
        child: Text('${investment.roi.toStringAsFixed(1)}% ROI', style: AppTextStyles.boldText(fontSize: 13, color: const Color(0xFF087F5B))),
      );

  Widget _expandButton() => Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(color: const Color(0xFFF8FAFB), borderRadius: BorderRadius.circular(12)),
        child: Icon(expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, color: ColorConstants.pronexTextGrey),
      );

  Widget _summary(String label, String value, {Color? valueColor}) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: _smallStyle()),
            const SizedBox(height: 4),
            Text(value, style: AppTextStyles.boldText(fontSize: 17, color: valueColor ?? ColorConstants.pronexTextDark)),
          ],
        ),
      );

  Widget _details(double ownership) {
    final progress = (ownership / 100).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            _metric('TOTAL VALUE', _currency(investment.propertyValue)),
            const SizedBox(width: 8),
            _metric('SHARE PRICE', _currency(investment.sharePrice)),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            _metric('LOCK-IN', investment.durationYears > 0 ? '${investment.durationYears} Years' : '2 Years'),
            const SizedBox(width: 8),
            _metric('CURRENT VALUE', _currency(investment.currentValue)),
          ]),
          const SizedBox(height: 16),
          _sectionTitle('Investment Returns', 'Current value and expected return'),
          const SizedBox(height: 10),
          _line('Invested Amount', investment.formattedInvestedAmount),
          _line('Current Value', _currency(investment.currentValue)),
          const SizedBox(height: 16),
          _buildOwnershipPanel(ownership, progress),
          const SizedBox(height: 12),
          _buildExitPanel(),
        ],
      ),
    );
  }

  Widget _metric(String label, String value) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFFF8FAFB), borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: _smallStyle()),
              const SizedBox(height: 6),
              Text(value, style: AppTextStyles.boldText(fontSize: 15, color: ColorConstants.pronexTextDark)),
            ],
          ),
        ),
      );

  Widget _sectionTitle(String title, String subtitle) => Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: AppTextStyles.boldText(fontSize: 16, color: ColorConstants.pronexTextDark)), const SizedBox(height: 3), Text(subtitle, style: _smallStyle())])), const Icon(Icons.trending_up_rounded, size: 20, color: ColorConstants.pronexPrimary)]);

  Widget _line(String label, String value) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: _smallStyle()), Text(value, style: AppTextStyles.semiBoldText(fontSize: 14, color: ColorConstants.pronexTextDark))]));

  Widget _buildOwnershipPanel(double ownership, double progress) {
    final remainingShares = (100 - investment.shares).clamp(0, 100);
    final remainingAmount = remainingShares * investment.sharePrice;
    final locked = investment.durationYears > 0;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDDE6EA)),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: const Color(0xFF062F35),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, color: Color(0xFF75E5C1), size: 20),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(child: Text('Full Ownership', maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.boldText(fontSize: 15, color: Colors.white))),
                          const SizedBox(width: 7),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(color: const Color(0xFF0B705E), borderRadius: BorderRadius.circular(4)),
                            child: const Text('PREMIUM OPTION', style: TextStyle(color: Color(0xFFB9F2CD), fontSize: 9, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      const Text('Complete your ownership of this property', style: TextStyle(color: Color(0xFFB6D2D2), fontSize: 12)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('CURRENT', style: TextStyle(color: Color(0xFF9BC4C2), fontSize: 10, fontWeight: FontWeight.bold)),
                    Text('${ownership.toStringAsFixed(1)}%', style: const TextStyle(color: Color(0xFF62E6B5), fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Ownership Progress', style: AppTextStyles.boldText(fontSize: 14, color: ColorConstants.pronexTextDark)),
                  Text('Goal 100%', style: _smallStyle()),
                ]),
                const SizedBox(height: 5),
                Text('${investment.shares} of 100 shares owned', style: _smallStyle()),
                const SizedBox(height: 7),
                LinearProgressIndicator(value: progress, minHeight: 6, borderRadius: BorderRadius.circular(8), backgroundColor: const Color(0xFFE3F0EB), color: const Color(0xFF28C99A)),
                const SizedBox(height: 4),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Current ${ownership.toStringAsFixed(1)}%', style: _smallStyle()), Text('Goal 100%', style: _smallStyle())]),
                const SizedBox(height: 12),
                Row(children: [
                  _ownershipStat('SHARES OWNED', '${investment.shares}', false),
                  const SizedBox(width: 8),
                  _ownershipStat('SHARES REMAINING', '$remainingShares', true),
                ]),
                const SizedBox(height: 10),
                if (locked)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7DC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFF4D58D)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lock_outline_rounded, size: 18, color: Color(0xFFB7791F)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Full ownership is available after the lock-in period. You cannot buy the remaining shares while this investment is locked.',
                            style: AppTextStyles.regularText(fontSize: 13, color: const Color(0xFF8A5A12), height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  )
                else ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFFBFDFD), border: Border.all(color: const Color(0xFFDDE6EA)), borderRadius: BorderRadius.circular(12)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Complete Your Ownership', style: AppTextStyles.boldText(fontSize: 14, color: ColorConstants.pronexTextDark)),
                        const Icon(Icons.trending_up_rounded, size: 18, color: ColorConstants.pronexPrimary),
                      ]),
                      const SizedBox(height: 4),
                      Text('Acquire the remaining shares', style: _smallStyle()),
                      const SizedBox(height: 10),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        _ownershipAmount('ADDITIONAL SHARES', '$remainingShares'),
                        _ownershipAmount('PRICE / SHARE', _currency(investment.sharePrice)),
                      ]),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(color: const Color(0xFF10192E), borderRadius: BorderRadius.circular(10)),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          const Text('AMOUNT REQUIRED\nFOR 100% OWNERSHIP', style: TextStyle(color: Color(0xFFB8C3D4), fontSize: 11, fontWeight: FontWeight.bold, height: 1.3)),
                          Text(_currency(remainingAmount), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ]),
                      ),
                    ]),
                  ),
                  if (!investment.ownershipRequested && remainingShares > 0) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _isSubmittingOwnership ? null : _submitOwnership,
                        icon: _isSubmittingOwnership ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.arrow_forward_rounded, size: 18),
                        label: const Text('Request Full Ownership', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF087F6D), foregroundColor: Colors.white, disabledBackgroundColor: const Color(0xFFD9DEE5), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Center(child: Text('Our team will contact you to complete the process.', style: _smallStyle())),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ownershipStat(String label, String value, bool highlighted) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: highlighted ? const Color(0xFFF2FFF9) : const Color(0xFFF8FAFB), border: Border.all(color: highlighted ? const Color(0xFFBDEDD7) : const Color(0xFFE6EDF0)), borderRadius: BorderRadius.circular(7)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: _smallStyle()), const SizedBox(height: 4), Text(value, style: AppTextStyles.boldText(fontSize: 18, color: ColorConstants.pronexTextDark))]),
    ),
  );

  Widget _ownershipAmount(String label, String value) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: _smallStyle()), const SizedBox(height: 3), Text(value, style: AppTextStyles.boldText(fontSize: 15, color: ColorConstants.pronexTextDark))]);

  Widget _actionPanel(String title, String subtitle, IconData icon, String trailing, Color background, {bool danger = false}) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [Icon(icon, size: 20, color: danger ? const Color(0xFFE11D48) : ColorConstants.pronexPrimary), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: AppTextStyles.boldText(fontSize: 13, color: ColorConstants.pronexTextDark)), const SizedBox(height: 3), Text(subtitle, style: _smallStyle())])), Text(trailing, style: AppTextStyles.boldText(fontSize: 11, color: danger ? const Color(0xFFE11D48) : ColorConstants.pronexPrimary))]),
      );

  Widget _buildPaymentPanel() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FFFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBDEDD7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_outlined, size: 20, color: ColorConstants.pronexPrimary),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Complete Payment', style: AppTextStyles.boldText(fontSize: 13, color: ColorConstants.pronexTextDark)),
                const SizedBox(height: 3),
                Text('Submit your payment proof for verification.', style: _smallStyle()),
              ])),
              Text('Pending', style: AppTextStyles.boldText(fontSize: 11, color: ColorConstants.pronexPrimary)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFE9FBF3), borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              Expanded(child: Text('PAYABLE AMOUNT', style: _smallStyle())),
              Text(_currency(investment.investedAmount), style: AppTextStyles.boldText(fontSize: 14, color: ColorConstants.pronexTextDark)),
              const SizedBox(width: 10),
              Text('Shares\n${investment.shares}', textAlign: TextAlign.right, style: _smallStyle()),
            ]),
          ),
          const SizedBox(height: 12),
          _fieldLabel('PAYMENT REFERENCE / UTR'),
          const SizedBox(height: 5),
          TextField(
            controller: _referenceController,
            decoration: _inputDecoration('Enter your UTR number'),
          ),
          const SizedBox(height: 10),
          _fieldLabel('PAYMENT PROOF'),
          const SizedBox(height: 5),
          InkWell(
            onTap: _pickPaymentProof,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFC7D2D9)),
              ),
              child: Row(children: [
                const Icon(Icons.upload_file_outlined, size: 19, color: ColorConstants.pronexPrimary),
                const SizedBox(width: 8),
                Expanded(child: Text(_paymentProof == null ? 'Upload payment screenshot' : _paymentProof!.path.split(Platform.pathSeparator).last, maxLines: 1, overflow: TextOverflow.ellipsis, style: _smallStyle())),
                const Text('Browse', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ColorConstants.pronexPrimary)),
              ]),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: _isSubmittingPayment ? null : _submitPayment,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: _isSubmittingPayment ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Submit Payment Proof', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 5),
          Center(child: Text('Your payment proof will be reviewed by the admin team.', style: _smallStyle())),
        ],
      ),
    );
  }

  Widget _buildExitPanel() {
    final locked = investment.durationYears > 0;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFFFFBF2), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFF4D58D))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.logout_rounded, size: 20, color: Color(0xFFE11D48)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Exit Investment', style: AppTextStyles.boldText(fontSize: 13, color: ColorConstants.pronexTextDark)), const SizedBox(height: 3), Text('Submit a request to exit your investment shares.', style: _smallStyle())])),
        ]),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFFFFF7DC), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFF4D58D))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.info_outline_rounded, size: 17, color: Color(0xFFB7791F)),
            const SizedBox(width: 7),
            Expanded(child: Text(locked ? 'Investment is currently under lock-in period.\nYou will be eligible to request an exit after the lock-in period.' : 'You can request an exit for shares owned in multiples of 10.', style: const TextStyle(fontSize: 13, color: Color(0xFF8A5A12), height: 1.35))),
          ]),
        ),
        const SizedBox(height: 10),
        _fieldLabel('NUMBER OF SHARES TO EXIT'),
        const SizedBox(height: 5),
        Row(children: [
          Expanded(child: TextField(controller: _exitSharesController, enabled: !locked && !_isSubmittingExit, keyboardType: TextInputType.number, decoration: _inputDecoration('Multiples of 10'))),
          const SizedBox(width: 8),
          Expanded(child: ElevatedButton(onPressed: locked || _isSubmittingExit ? null : _submitExit, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE11D48), disabledBackgroundColor: const Color(0xFFD9DEE5), foregroundColor: Colors.white, elevation: 0, minimumSize: const Size(0, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: _isSubmittingExit ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(locked ? 'Exit Locked' : 'Request Exit', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))),
        ]),
        const SizedBox(height: 4),
        Text('You currently own ${investment.shares} shares. Exit requests must be in multiples of 10.', style: _smallStyle()),
        if (_exitError != null) ...[const SizedBox(height: 5), Text(_exitError!, style: const TextStyle(color: Colors.red, fontSize: 11))],
      ]),
    );
  }

  Widget _fieldLabel(String text) => Text(text, style: AppTextStyles.boldText(fontSize: 12, color: ColorConstants.pronexTextDark));

  InputDecoration _inputDecoration(String hint) => InputDecoration(hintText: hint, hintStyle: _smallStyle(), isDense: true, filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFDCE3E8))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFDCE3E8))));

  Future<void> _pickPaymentProof() async {
    final result = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (result != null && mounted) setState(() => _paymentProof = File(result.path));
  }

  Future<void> _submitPayment() async {
    if (_referenceController.text.trim().isEmpty || _paymentProof == null) {
      return;
    }
    setState(() => _isSubmittingPayment = true);
    await widget.onSubmitPayment(_referenceController.text.trim(), 'UPI', _paymentProof!);
    if (mounted) setState(() => _isSubmittingPayment = false);
  }

  Future<void> _submitOwnership() async {
    setState(() => _isSubmittingOwnership = true);
    await widget.onRequestOwnership();
    if (mounted) setState(() => _isSubmittingOwnership = false);
  }

  Future<void> _submitExit() async {
    final shares = int.tryParse(_exitSharesController.text.trim());
    if (shares == null || shares <= 0 || shares % 10 != 0) {
      setState(() => _exitError = 'Enter shares in multiples of 10.');
      return;
    }
    if (shares > investment.shares) {
      setState(() => _exitError = 'You cannot exit more shares than you own.');
      return;
    }
    setState(() { _isSubmittingExit = true; _exitError = null; });
    await widget.onRequestExit(shares, _exitReasonController.text.trim());
    if (mounted) setState(() => _isSubmittingExit = false);
  }

  TextStyle _smallStyle() => AppTextStyles.regularText(fontSize: 13, color: ColorConstants.pronexTextGrey);

  String _currency(double value) {
    final formatted = value.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},');
    return '₹$formatted';
  }

  Future<void> _showExitDialog() async {
    final sharesController = TextEditingController(text: '10');
    final reasonController = TextEditingController();
    String? error;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Request Exit'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: sharesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Shares to exit',
                      hintText: 'Use multiples of 10',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: reasonController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Reason (optional)',
                    ),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      error!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final shares = int.tryParse(sharesController.text.trim());
                    if (shares == null || shares <= 0 || shares % 10 != 0) {
                      setDialogState(
                        () => error = 'Enter shares in multiples of 10',
                      );
                      return;
                    }
                    Navigator.pop(dialogContext);
                    widget.onRequestExit(shares, reasonController.text.trim());
                  },
                  child: const Text('Submit Request'),
                ),
              ],
            );
          },
        );
      },
    );
    sharesController.dispose();
    reasonController.dispose();
  }
}

class PortfolioDocumentPage extends StatelessWidget {
  final PortfolioDocument document;

  const PortfolioDocumentPage({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final isSvg = document.url.toLowerCase().contains('.svg');
    return Scaffold(
      backgroundColor: ColorConstants.white,
      appBar: AppBar(
        title: Text(document.name),
        backgroundColor: ColorConstants.white,
        foregroundColor: ColorConstants.pronexTextDark,
      ),
      body: document.url.isEmpty
          ? const Center(child: Text('Document unavailable'))
          : Center(
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4,
                child: isSvg
                    ? SvgPicture.network(
                        document.url,
                        placeholderBuilder: (_) =>
                            const CircularProgressIndicator(),
                      )
                    : Image.network(
                        document.url,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const CircularProgressIndicator();
                        },
                        errorBuilder: (_, __, ___) =>
                            const Text('Unable to display this document'),
                      ),
              ),
            ),
    );
  }
}
