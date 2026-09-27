import 'package:flutter/material.dart';
import '../../core/constants/app_text_style.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../core/constants/image_constants.dart';
import '../../core/utils/base_view.dart';
import '../../core/models/portfolio_model.dart';
import 'kyc_documents_page.dart';
import 'profile_view_model.dart';

class ProfileView extends StatelessWidget {
  final VoidCallback? onOpenSaved;

  const ProfileView({super.key, this.onOpenSaved});

  @override
  Widget build(BuildContext context) {
    return BaseView.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      onViewModelReady: (viewModel) => viewModel.init(),
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: ColorConstants.white,
          body: SafeArea(
            child: viewModel.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: ColorConstants.pronexPrimary,
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: Dimensions.px110),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _header(),
                        const SizedBox(height: Dimensions.px8),
                        _identity(viewModel),
                        const SizedBox(height: Dimensions.px16),
                        _stats(viewModel),
                        const SizedBox(height: Dimensions.px16),
                        _shortcuts(context, viewModel),
                        const SizedBox(height: Dimensions.px22),
                        _faqs(viewModel),
                        const SizedBox(height: Dimensions.px22),
                        _howItWorks(),
                        const SizedBox(height: Dimensions.px22),
                        _messageButton(context, viewModel),
                        const SizedBox(height: Dimensions.px20),
                        _logout(viewModel),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          Image.asset(
            ImageConstants.appLogo,
            height: 36,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _identity(ProfileViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFF145C3A),
              shape: BoxShape.circle,
            ),
            child: Text(
              viewModel.nameInitial,
              style: AppTextStyles.boldText(
                fontSize: Dimensions.px22,
                color: ColorConstants.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          Text(
            viewModel.displayName,
            style: AppTextStyles.boldText(
              fontSize: Dimensions.px22,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: Dimensions.px6),
          Text(
            viewModel.displayEmail,
            style: AppTextStyles.regularText(
              fontSize: Dimensions.px14,
              color: ColorConstants.pronexTextGrey,
            ),
          ),
          if (viewModel.displayPhone.isNotEmpty) ...[
            const SizedBox(height: Dimensions.px4),
            Text(
              viewModel.displayPhone,
              style: AppTextStyles.regularText(
                fontSize: Dimensions.px14,
                color: ColorConstants.pronexTextGrey,
              ),
            ),
          ],
          if (viewModel.isPremium) ...[
            const SizedBox(height: Dimensions.px10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFE7F6EE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Premium investor',
                style: AppTextStyles.semiBoldText(
                  fontSize: Dimensions.px12,
                  color: const Color(0xFF1B6B45),
                ),
              ),
            ),
          ],
          if (viewModel.errorMessage != null) ...[
            const SizedBox(height: Dimensions.px8),
            Text(
              viewModel.errorMessage!,
              style: AppTextStyles.regularText(
                fontSize: Dimensions.px13,
                color: ColorConstants.radicalRed,
              ),
            ),
          ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stats(ProfileViewModel viewModel) {
    final items = [
      ('Total', viewModel.totalInvestedLabel),
      ('Properties Owned', viewModel.propertiesOwnedLabel),
      ('Total Returns (Est.)', viewModel.estimatedReturnsLabel),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.px16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3FBF6),
          borderRadius: BorderRadius.circular(Dimensions.px16),
          border: Border.all(color: const Color(0xFFE3F3EA)),
        ),
        child: Row(
          children: List.generate(items.length, (index) {
            return Expanded(
              child: Column(
                children: [
                  Text(
                    items[index].$1,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.regularText(
                      fontSize: Dimensions.px12,
                      color: ColorConstants.pronexTextGrey,
                    ),
                  ),
                  const SizedBox(height: Dimensions.px6),
                  Text(
                    items[index].$2,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.boldText(
                      fontSize: Dimensions.px16,
                      color: const Color(0xFF145C3A),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _shortcuts(BuildContext context, ProfileViewModel viewModel) {
    final items = <(IconData, String, String, VoidCallback?)>[
      (
        Icons.bookmark_border_rounded,
        'Saved Properties',
        'View your saved investments',
        onOpenSaved,
      ),
      if (viewModel.kycDocuments.isNotEmpty)
        (
          Icons.description_outlined,
          'Documents & Statements',
          'KYC, agreements, receipts',
          () => _openDocuments(context, viewModel.kycDocuments),
        ),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Row(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            if (index > 0) const SizedBox(width: 12),
            Expanded(child: _shortcutCard(items[index])),
          ],
        ],
      ),
    );
  }

  Widget _shortcutCard((IconData, String, String, VoidCallback?) item) {
    return Material(
      color: ColorConstants.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: item.$4,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 118,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8ECF0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(item.$1, color: const Color(0xFF1B6B45), size: 22),
              const Spacer(),
              Text(
                item.$2,
                style: AppTextStyles.semiBoldText(
                  fontSize: Dimensions.px14,
                  color: const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.$3,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.regularText(
                  fontSize: Dimensions.px12,
                  color: ColorConstants.pronexTextGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openDocuments(BuildContext context, List<PortfolioDocument> documents) {
    if (documents.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => KycDocumentsPage(documents: documents),
      ),
    );
  }

  Widget _faqs(ProfileViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Frequently Asked Questions',
                  style: AppTextStyles.boldText(
                    fontSize: Dimensions.px20,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.px12),
          ...List.generate(ProfileViewModel.faqs.length, (index) {
            final (question, answer) = ProfileViewModel.faqs[index];
            final open = viewModel.openFaq == index;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => viewModel.toggleFaq(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    color: ColorConstants.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: open
                          ? const Color(0xFF3B6FD8)
                          : const Color(0xFFE6E8EE),
                      width: open ? 1.4 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                question,
                                style: AppTextStyles.semiBoldText(
                                  fontSize: Dimensions.px15,
                                  color: const Color(0xFF111827),
                                ),
                              ),
                            ),
                            Icon(
                              open
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: const Color(0xFF6B7280),
                            ),
                          ],
                        ),
                      ),
                      if (open)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                          child: Text(
                            answer,
                            style: AppTextStyles.regularText(
                              fontSize: Dimensions.px14,
                              color: const Color(0xFF6B7280),
                              height: 1.45,
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

  Widget _howItWorks() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE6E8EE)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How it works',
              style: AppTextStyles.boldText(
                fontSize: Dimensions.px18,
                color: const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Simple. Transparent. Built for investors.',
              style: AppTextStyles.regularText(
                fontSize: Dimensions.px13,
                color: ColorConstants.pronexTextGrey,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                Expanded(
                  child: _HowStep(
                    icon: Icons.apartment_rounded,
                    title: '1 Property',
                    subtitle: 'Premium real estate asset',
                  ),
                ),
                Expanded(
                  child: _HowStep(
                    icon: Icons.hub_outlined,
                    title: 'Pronex World 10%',
                    subtitle: 'Management & operations',
                  ),
                ),
                Expanded(
                  child: _HowStep(
                    icon: Icons.groups_outlined,
                    title: 'Up to 9 Investors',
                    subtitle: 'Co-ownership through LLP',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _messageButton(BuildContext context, ProfileViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: () => _openMessageForm(context, viewModel),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF145C3A),
            foregroundColor: ColorConstants.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
          label: Text(
            'Send us a Message',
            style: AppTextStyles.semiBoldText(
              fontSize: Dimensions.px15,
              color: ColorConstants.white,
            ),
          ),
        ),
      ),
    );
  }

  void _openMessageForm(BuildContext context, ProfileViewModel viewModel) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return Scaffold(
              backgroundColor: ColorConstants.white,
              appBar: AppBar(
                title: Text(
                  'Send us a Message',
                  style: AppTextStyles.boldText(
                    fontSize: Dimensions.px18,
                    color: const Color(0xFF111827),
                  ),
                ),
                backgroundColor: ColorConstants.white,
                foregroundColor: const Color(0xFF111827),
                elevation: 0,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 8, bottom: 28),
                child: _contactForm(viewModel),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _contactForm(ProfileViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE6E8EE)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send us a Message',
              style: AppTextStyles.boldText(
                fontSize: Dimensions.px18,
                color: const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "We're here to help. Fill in the details and we'll get back to you soon.",
              style: AppTextStyles.regularText(
                fontSize: Dimensions.px13,
                color: ColorConstants.pronexTextGrey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('Full Name'),
                      _textField(viewModel.nameController, 'Your name'),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('Email Address'),
                      _textField(
                        viewModel.emailController,
                        'you@email.com',
                        keyboard: TextInputType.emailAddress,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('Phone Number'),
                      _textField(
                        viewModel.phoneController,
                        '9876543210',
                        keyboard: TextInputType.phone,
                        prefix: '+91 ',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('Inquiry Type'),
                      _dropdown(
                        value: viewModel.selectedType,
                        hint: 'Select inquiry type',
                        items: ProfileViewModel.inquiryTypes,
                        onChanged: viewModel.setInquiryType,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _fieldLabel('Subject'),
            _dropdown(
              value: viewModel.selectedSubject,
              hint: 'Select subject',
              items: ProfileViewModel.subjects,
              onChanged: viewModel.setSubject,
            ),
            const SizedBox(height: 12),
            _fieldLabel('Message'),
            _textField(
              viewModel.messageController,
              'Type your message here...',
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: viewModel.isSending ? null : viewModel.sendMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF145C3A),
                  disabledBackgroundColor: const Color(0xFF145C3A),
                  foregroundColor: ColorConstants.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: viewModel.isSending
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded, size: 18),
                label: Text(
                  'Send Message',
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

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: AppTextStyles.semiBoldText(
          fontSize: Dimensions.px13,
          color: const Color(0xFF111827),
        ),
      ),
    );
  }

  Widget _textField(
    TextEditingController controller,
    String hint, {
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
    String? prefix,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      style: AppTextStyles.regularText(
        fontSize: Dimensions.px15,
        color: const Color(0xFF111827),
      ),
      decoration: InputDecoration(
        hintText: hint,
        prefixText: prefix,
        prefixStyle: AppTextStyles.regularText(
          fontSize: Dimensions.px14,
          color: const Color(0xFF111827),
        ),
        hintStyle: AppTextStyles.regularText(
          fontSize: Dimensions.px14,
          color: const Color(0xFF9CA3AF),
        ),
        filled: true,
        fillColor: const Color(0xFFF8F9FB),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE6E8EE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE6E8EE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1B6B45)),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: value,
      hint: Text(
        hint,
        style: AppTextStyles.regularText(
          fontSize: Dimensions.px14,
          color: const Color(0xFF9CA3AF),
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: AppTextStyles.regularText(
                  fontSize: Dimensions.px14,
                  color: const Color(0xFF111827),
                ),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF8F9FB),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE6E8EE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE6E8EE)),
        ),
      ),
    );
  }

  Widget _logout(ProfileViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: GestureDetector(
        onTap: viewModel.onLogout,
        child: Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColorConstants.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFF3C3CB)),
          ),
          child: Text(
            'Log Out',
            style: AppTextStyles.semiBoldText(
              fontSize: Dimensions.px15,
              color: ColorConstants.radicalRed,
            ),
          ),
        ),
      ),
    );
  }
}

class _HowStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _HowStep({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF1B6B45), size: 22),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.semiBoldText(
            fontSize: 12,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.regularText(
            fontSize: 11,
            color: ColorConstants.pronexTextGrey,
          ),
        ),
      ],
    );
  }
}
