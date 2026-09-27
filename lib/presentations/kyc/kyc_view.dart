import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_text_style.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../core/utils/base_view.dart';
import 'kyc_view_model.dart';

class KYCView extends StatelessWidget {
  final String propertyId;
  final int shares;
  final String referralCode;

  const KYCView({
    super.key,
    required this.propertyId,
    this.shares = 1,
    this.referralCode = '',
  });

  @override
  Widget build(BuildContext context) {
    return BaseView.reactive(
      viewModelBuilder: () => KYCViewModel(
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
                  top: Dimensions.px60,
                  bottom: Dimensions.px140,
                ),
                child: Column(
                  children: [
                    _buildHeader(vm),
                    const SizedBox(height: Dimensions.px24),
                    _buildStepper(vm),
                    const SizedBox(height: Dimensions.px28),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, anim) {
                        final offsetAnim =
                            Tween<Offset>(
                              begin: const Offset(0.18, 0),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: anim,
                                curve: Curves.easeOut,
                              ),
                            );
                        final fadeAnim = CurvedAnimation(
                          parent: anim,
                          curve: Curves.easeOut,
                        );
                        return FadeTransition(
                          opacity: fadeAnim,
                          child: SlideTransition(
                            position: offsetAnim,
                            child: child,
                          ),
                        );
                      },
                      child: _buildStepContent(vm),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildBottomActionBar(vm),
              ),
            ],
          ),
        );
      },
    );
  }

  Key _stepKey(KYCViewModel vm) => ValueKey('step-${vm.currentStep}');

  Widget _buildStepContent(KYCViewModel vm) {
    switch (vm.currentStep) {
      case 1:
        return KeyedSubtree(key: _stepKey(vm), child: _buildStep1Personal(vm));
      case 2:
        return KeyedSubtree(key: _stepKey(vm), child: _buildStep2Pan(vm));
      case 3:
        return KeyedSubtree(key: _stepKey(vm), child: _buildStep3Aadhaar(vm));
      case 4:
        return KeyedSubtree(key: _stepKey(vm), child: _buildStep4Nominee(vm));
      case 5:
        return KeyedSubtree(key: _stepKey(vm), child: _buildStep5Bank(vm));
      case 6:
      default:
        return KeyedSubtree(key: _stepKey(vm), child: _buildReviewStep(vm));
    }
  }

  Widget _buildHeader(KYCViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px16),
      child: Row(
        children: [
          GestureDetector(
            onTap: vm.goBack,
            child: Container(
              width: Dimensions.px40,
              height: Dimensions.px40,
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back_rounded,
                color: const Color(0xFF3D7A6A),
                size: Dimensions.px24,
              ),
            ),
          ),
          const SizedBox(width: Dimensions.px8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete Your KYC',
                  style: AppTextStyles.boldText(
                    fontSize: Dimensions.px22,
                    color: const Color(0xFF3D7A6A),
                  ),
                ),
                const SizedBox(height: Dimensions.px3),
                Text(
                  'Required only once before your first investment.',
                  style: AppTextStyles.regularText(
                    fontSize: Dimensions.px13,
                    color: ColorConstants.pronexTextGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper(KYCViewModel vm) {
    final stepLabels = const [
      'Personal',
      'PAN',
      'Aadhaar',
      'Nominee',
      'Bank',
      'Review',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px28),
      child: Row(
        children: List.generate(6, (i) {
          final stepNum = i + 1;
          final isActive = vm.currentStep == stepNum;
          final isCompleted = vm.currentStep > stepNum;
          final isLast = i == 5;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: Dimensions.px48,
                            height: Dimensions.px48,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFF3D7A6A)
                                  : isCompleted
                                  ? const Color(0xFF3D7A6A)
                                  : const Color(0xFFEEF2F7),
                              shape: BoxShape.circle,
                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF3D7A6A,
                                        ).withValues(alpha: 0.25),
                                        blurRadius: Dimensions.px10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: isCompleted
                                ? Icon(
                                    Icons.check_rounded,
                                    color: ColorConstants.white,
                                    size: Dimensions.px22,
                                  )
                                : Text(
                                    '$stepNum',
                                    style: AppTextStyles.boldText(
                                      fontSize: Dimensions.px16,
                                      color: isActive
                                          ? ColorConstants.white
                                          : ColorConstants.pronexTextGrey,
                                    ),
                                  ),
                          ),
                          if (isActive)
                            Container(
                              width: Dimensions.px64,
                              height: Dimensions.px64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(
                                  0xFF3D7A6A,
                                ).withValues(alpha: 0.08),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.px8),
                      Text(
                        stepLabels[i],
                        style: AppTextStyles.semiBoldText(
                          fontSize: Dimensions.px8,
                          color: isActive || isCompleted
                              ? const Color(0xFF3D7A6A)
                              : ColorConstants.pronexTextGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Container(
                    margin: const EdgeInsets.only(bottom: Dimensions.px18),
                    height: Dimensions.px2,
                    width: Dimensions.px14,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? const Color(0xFF3D7A6A)
                          : const Color(0xFFE5E9F0),
                      borderRadius: BorderRadius.circular(Dimensions.px2),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ---------------- STEP 1 — PERSONAL ----------------

  Widget _buildStep1Personal(KYCViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Column(
        children: [
          _buildSecurityCard(),
          const SizedBox(height: Dimensions.px24),
          _buildPersonalCard(vm),
        ],
      ),
    );
  }

  Widget _buildSecurityCard() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px20,
        vertical: Dimensions.px22,
      ),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(Dimensions.px24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: Dimensions.px10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -Dimensions.px8,
            top: -Dimensions.px8,
            child: Opacity(
              opacity: 0.08,
              child: Icon(
                Icons.verified_user_rounded,
                size: Dimensions.px80,
                color: const Color(0xFF3D7A6A),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Dimensions.px44,
                height: Dimensions.px44,
                decoration: BoxDecoration(
                  color: const Color(0xFF3D7A6A).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.px12),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.shield_rounded,
                  color: const Color(0xFF3D7A6A),
                  size: Dimensions.px24,
                ),
              ),
              const SizedBox(width: Dimensions.px14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Information is Safe',
                      style: AppTextStyles.boldText(
                        fontSize: Dimensions.px19,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: Dimensions.px8),
                    Text(
                      'We use industry-leading encryption to protect your data. Your privacy is our highest priority.',
                      style: AppTextStyles.regularText(
                        fontSize: Dimensions.px13,
                        color: ColorConstants.pronexTextGrey,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: Dimensions.px18),
                    // _buildTrustChip(
                    //   Icons.lock_outline_rounded,
                    //   const Color(0xFFD4A843),
                    //   '256-bit Encryption',
                    // ),
                    // const SizedBox(height: Dimensions.px8),
                    // _buildTrustChip(
                    //   Icons.verified_user_outlined,
                    //   const Color(0xFF4A7ED1),
                    //   'Secure Verification',
                    // ),
                    // const SizedBox(height: Dimensions.px8),
                    // _buildTrustChip(
                    //   Icons.gavel_outlined,
                    //   const Color(0xFF3D7A6A),
                    //   'SEBI Compliant',
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrustChip(IconData icon, Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: Dimensions.px16),
        const SizedBox(width: Dimensions.px8),
        Text(
          label,
          style: AppTextStyles.regularText(
            fontSize: Dimensions.px12,
            color: ColorConstants.pronexTextGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalCard(KYCViewModel vm) {
    return _FormCard(
      icon: Icons.person_rounded,
      title: 'Personal Details',
      children: [
        _buildInputField(
          label: 'FULL NAME (AS PER PAN)',
          controller: vm.fullNameCtrl,
          hint: 'e.g. Rahul Sharma',
          errorText: vm.fullNameError,
          onChanged: (_) => vm.clearPersonalError('fullName'),
        ),
        const SizedBox(height: Dimensions.px18),
        _buildInputField(
          label: 'DATE OF BIRTH',
          controller: vm.dobCtrl,
          hint: 'mm/dd/yyyy',
          suffix: Icon(
            Icons.calendar_today_rounded,
            color: ColorConstants.pronexTextGrey,
            size: Dimensions.px18,
          ),
          keyboard: TextInputType.datetime,
          readOnly: true,
          onTap: () => _pickDateOfBirth(vm),
          errorText: vm.dobError,
        ),
        const SizedBox(height: Dimensions.px18),
        _buildInputField(
          label: 'EMAIL ADDRESS',
          controller: vm.emailCtrl,
          hint: 'rahul.sharma@example.com',
          keyboard: TextInputType.emailAddress,
          verified: vm.emailVerified,
          errorText: vm.emailError,
          onChanged: (_) => vm.clearPersonalError('email'),
        ),
        const SizedBox(height: Dimensions.px18),
        _buildInputField(
          label: 'ADDRESS',
          controller: vm.addressCtrl,
          hint: 'e.g. Indore',
          keyboard: TextInputType.streetAddress,
          errorText: vm.addressError,
          onChanged: (_) => vm.clearPersonalError('address'),
        ),
        if (vm.basicErrorMessage != null) ...[
          const SizedBox(height: Dimensions.px14),
          Text(
            vm.basicErrorMessage!,
            style: AppTextStyles.regularText(
              fontSize: Dimensions.px13,
              color: ColorConstants.radicalRed,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _pickDateOfBirth(KYCViewModel vm) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: AppConstants.globalNavKey.currentContext!,
      initialDate: DateTime(now.year - 25, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) vm.setDob(picked);
  }

  // ---------------- STEP 2 — PAN ----------------

  Widget _buildStep2Pan(KYCViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Column(
        children: [
          _buildPANCard(vm),
          const SizedBox(height: Dimensions.px22),
          _buildDocumentUploadCard(
            title: 'PAN Card Photo',
            description: 'Upload a clear photo of your PAN card.',
            isUploaded: vm.panDocument != null,
            onTap: vm.pickPanDocument,
          ),
        ],
      ),
    );
  }

  // ---------------- STEP 3 — AADHAAR ----------------

  Widget _buildStep3Aadhaar(KYCViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Column(
        children: [
          _FormCard(
            icon: Icons.badge_rounded,
            title: 'Aadhaar Verification',
            description: 'Enter your 12-digit Aadhaar number.',
            children: [
              _buildInputField(
                label: 'AADHAAR NUMBER',
                controller: vm.aadhaarNumberCtrl,
                hint: '1234 5678 9012',
                keyboard: TextInputType.number,
                digitsOnly: true,
                maxLength: 12,
                errorText: vm.aadhaarError,
                onChanged: (_) => vm.clearAadhaarError(),
              ),
              if (vm.aadhaarSubmitError != null) ...[
                const SizedBox(height: Dimensions.px10),
                Text(
                  vm.aadhaarSubmitError!,
                  style: AppTextStyles.regularText(
                    fontSize: Dimensions.px13,
                    color: ColorConstants.radicalRed,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: Dimensions.px22),
          _buildDocumentUploadCard(
            title: 'Aadhaar Card Photo',
            description: 'Upload a clear photo of your Aadhaar card.',
            isUploaded: vm.aadhaarDocument != null,
            onTap: vm.pickAadhaarDocument,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentUploadCard({
    required String title,
    required String description,
    required bool isUploaded,
    required VoidCallback onTap,
  }) {
    return _FormCard(
      icon: Icons.cloud_upload_outlined,
      title: title,
      description: description,
      children: [
        _buildDashedUploadBox(
          label: isUploaded ? 'PHOTO SELECTED' : 'UPLOAD PHOTO',
          icon: Icons.photo_camera_outlined,
          isUploaded: isUploaded,
          onTap: onTap,
        ),
      ],
    );
  }

  Widget _buildPANCard(KYCViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.px22),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(Dimensions.px24),
        boxShadow: _cardShadow(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: Dimensions.px40,
                height: Dimensions.px40,
                decoration: BoxDecoration(
                  color: const Color(0xFF3D7A6A).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.px12),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.receipt_long_rounded,
                  color: const Color(0xFF3D7A6A),
                  size: Dimensions.px22,
                ),
              ),
              const SizedBox(width: Dimensions.px12),
              Expanded(
                child: Text(
                  'PAN Details',
                  style: AppTextStyles.boldText(
                    fontSize: Dimensions.px20,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
              if (vm.panVerified)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.px10,
                    vertical: Dimensions.px5,
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
                        'VERIFIED',
                        style: AppTextStyles.boldText(
                          fontSize: Dimensions.px11,
                          color: const Color(0xFF3FA964),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: Dimensions.px22),
          _buildInputField(
            label: 'PAN NUMBER',
            controller: vm.panNumberCtrl,
            hint: 'ABCDE1234F',
            keyboard: TextInputType.text,
            uppercase: true,
            maxLength: 10,
            errorText: vm.panError,
            onChanged: (_) => vm.clearPanError(),
          ),
          const SizedBox(height: Dimensions.px8),
          Text(
            '10 characters: 5 letters, 4 numbers, and 1 letter',
            style: AppTextStyles.regularText(
              fontSize: Dimensions.px12,
              color: ColorConstants.pronexTextGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityUploadCard(KYCViewModel vm) {
    return _FormCard(
      icon: Icons.badge_rounded,
      title: 'Identity Verification',
      description:
          'Upload a clear photo of your Aadhaar Card, Passport, or Driving Licence.',
      children: [
        _buildDashedUploadBox(
          label: 'FRONT SIDE',
          icon: Icons.crop_original_rounded,
          isUploaded: vm.frontSideUploaded == true,
          onTap: vm.toggleFrontUploaded,
        ),
        const SizedBox(height: Dimensions.px16),
        _buildDashedUploadBox(
          label: 'BACK SIDE',
          icon: Icons.image_outlined,
          isUploaded: vm.backSideUploaded == true,
          onTap: vm.toggleBackUploaded,
        ),
      ],
    );
  }

  Widget _buildAddressProofCard(KYCViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.px22),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(Dimensions.px24),
        boxShadow: _cardShadow(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: Dimensions.px40,
                height: Dimensions.px40,
                decoration: BoxDecoration(
                  color: const Color(0xFF3D7A6A).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.px12),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.location_on_outlined,
                  color: const Color(0xFF3D7A6A),
                  size: Dimensions.px22,
                ),
              ),
              const SizedBox(width: Dimensions.px12),
              Expanded(
                child: Text(
                  'Address Proof',
                  style: AppTextStyles.boldText(
                    fontSize: Dimensions.px20,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.px18),
          GestureDetector(
            onTap: vm.toggleAddressProofUploaded,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimensions.px18),
              decoration: BoxDecoration(
                color: vm.addressProofUploaded == true
                    ? const Color(0xFFF0F8F4)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(Dimensions.px20),
                border: Border.all(
                  color: vm.addressProofUploaded == true
                      ? const Color(0xFF3D7A6A).withValues(alpha: 0.35)
                      : const Color(0xFFC9D0DB),
                  width: 1,
                  style: vm.addressProofUploaded == true
                      ? BorderStyle.solid
                      : BorderStyle.solid,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.px16),
                  border: Border.all(
                    color: const Color(0xFFC9D0DB),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.px15),
                  child: CustomPaint(
                    painter: _DashedBorderPainter(
                      color: const Color(0xFFC9D0DB),
                      strokeWidth: 1,
                      gap: 5,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.px16),
                      child: Row(
                        children: [
                          Container(
                            width: Dimensions.px60,
                            height: Dimensions.px60,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE7BA),
                              borderRadius: BorderRadius.circular(
                                Dimensions.px16,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: vm.addressProofUploaded == true
                                ? Icon(
                                    Icons.check_rounded,
                                    color: const Color(0xFFC9942A),
                                    size: Dimensions.px28,
                                  )
                                : Icon(
                                    Icons.description_rounded,
                                    color: const Color(0xFFC9942A),
                                    size: Dimensions.px28,
                                  ),
                          ),
                          const SizedBox(width: Dimensions.px16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Upload Utility Bill /\nBank Statement',
                                  style: AppTextStyles.boldText(
                                    fontSize: Dimensions.px15,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: Dimensions.px4),
                                Text(
                                  'Must be less than 3 months old (PDF, JPG, PNG)',
                                  style: AppTextStyles.regularText(
                                    fontSize: Dimensions.px12,
                                    color: ColorConstants.pronexTextGrey,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- STEP 4 — NOMINEE ----------------

  Widget _buildStep4Nominee(KYCViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: _FormCard(
        icon: Icons.person_add_alt_1_rounded,
        title: 'Nominee Details',
        description: 'Add the nominee for your investment account.',
        children: [
          _buildInputField(
            label: 'NOMINEE NAME',
            controller: vm.nomineeNameCtrl,
            hint: 'e.g. Priya Sharma',
            errorText: vm.nomineeNameError,
            onChanged: (_) => vm.clearNomineeError('name'),
          ),
          const SizedBox(height: Dimensions.px18),
          _buildInputField(
            label: 'NOMINEE PAN NUMBER',
            controller: vm.nomineePanCtrl,
            hint: 'ABCDE1234F',
            uppercase: true,
            maxLength: 10,
            errorText: vm.nomineePanError,
            onChanged: (_) => vm.clearNomineeError('pan'),
          ),
          const SizedBox(height: Dimensions.px18),
          _buildInputField(
            label: 'NOMINEE AADHAAR NUMBER',
            controller: vm.nomineeAadhaarCtrl,
            hint: '123456789012',
            keyboard: TextInputType.number,
            digitsOnly: true,
            maxLength: 12,
            errorText: vm.nomineeAadhaarError,
            onChanged: (_) => vm.clearNomineeError('aadhaar'),
          ),
          const SizedBox(height: Dimensions.px18),
          _buildInputField(
            label: 'NOMINEE DATE OF BIRTH',
            controller: vm.nomineeDobCtrl,
            hint: 'mm/dd/yyyy',
            suffix: Icon(
              Icons.calendar_today_rounded,
              color: ColorConstants.pronexTextGrey,
              size: Dimensions.px18,
            ),
            keyboard: TextInputType.datetime,
            readOnly: true,
            onTap: () => _pickNomineeDateOfBirth(vm),
            errorText: vm.nomineeDobError,
          ),
          if (vm.nomineeSubmitError != null) ...[
            const SizedBox(height: Dimensions.px14),
            Text(
              vm.nomineeSubmitError!,
              style: AppTextStyles.regularText(
                fontSize: Dimensions.px13,
                color: ColorConstants.radicalRed,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickNomineeDateOfBirth(KYCViewModel vm) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: AppConstants.globalNavKey.currentContext!,
      initialDate: DateTime(now.year - 30, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) vm.setNomineeDob(picked);
  }

  // ---------------- STEP 5 — BANK ----------------

  Widget _buildStep5Bank(KYCViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Column(
        children: [
          _buildBankCard(vm),
          const SizedBox(height: Dimensions.px24),
          _buildRbiComplianceCard(),
        ],
      ),
    );
  }

  Widget _buildBankCard(KYCViewModel vm) {
    return _FormCard(
      icon: Icons.account_balance_rounded,
      title: 'Bank Verification',
      children: [
        _buildInputField(
          label: 'BENEFICIARY NAME',
          controller: vm.beneficiaryNameCtrl,
          hint: 'e.g. Mahima Babani',
        ),
        const SizedBox(height: Dimensions.px18),
        _buildInputField(
          label: 'ACCOUNT NUMBER',
          controller: vm.accountNumberCtrl,
          hint: '1234567890',
          keyboard: TextInputType.number,
        ),
        const SizedBox(height: Dimensions.px18),
        _buildInputField(
          label: 'IFSC CODE',
          controller: vm.ifscCodeCtrl,
          hint: 'HDFC0001234',
          uppercase: true,
        ),
        const SizedBox(height: Dimensions.px18),
        _buildInputField(
          label: 'BRANCH',
          controller: vm.branchCtrl,
          hint: 'Jaipur Main Branch',
        ),
        const SizedBox(height: Dimensions.px18),
        _buildDocumentUploadCard(
          title: 'Cancelled Cheque Photo',
          description: 'Upload a clear photo of your cancelled cheque.',
          isUploaded: vm.cancelledChequeDocument != null,
          onTap: vm.pickCancelledCheque,
        ),
        if (vm.bankError != null || vm.bankSubmitError != null) ...[
          const SizedBox(height: Dimensions.px14),
          Text(
            vm.bankSubmitError ?? vm.bankError!,
            style: AppTextStyles.regularText(
              fontSize: Dimensions.px13,
              color: ColorConstants.radicalRed,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRbiComplianceCard() {
    return Container(
      padding: const EdgeInsets.all(Dimensions.px20),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(Dimensions.px24),
        boxShadow: _cardShadow(),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Dimensions.px44,
            height: Dimensions.px44,
            decoration: BoxDecoration(
              color: const Color(0xFF3D7A6A),
              borderRadius: BorderRadius.circular(Dimensions.px12),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.security_rounded,
              color: ColorConstants.white,
              size: Dimensions.px22,
            ),
          ),
          const SizedBox(width: Dimensions.px14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PRONEX is an RBI-regulated platform.',
                  style: AppTextStyles.semiBoldText(
                    fontSize: Dimensions.px14,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: Dimensions.px8),
                Text(
                  'We store all data in localized, ISO-certified data centers with AES-256 bank-grade encryption. Your bank details are used only for investment settlements and redemptions.',
                  style: AppTextStyles.regularText(
                    fontSize: Dimensions.px13,
                    color: ColorConstants.pronexTextGrey,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep(KYCViewModel vm) {
    final data = vm.reviewData;
    if (vm.isLoadingReview) {
      return const Center(child: CircularProgressIndicator());
    }
    if (data == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
        child: _ReviewCard(
          title: 'Unable to load KYC details',
          child: Text(
            vm.reviewError ?? 'Please try again.',
            style: AppTextStyles.regularText(
              fontSize: Dimensions.px14,
              color: ColorConstants.pronexTextGrey,
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.px20),
      child: Column(
        children: [
          _ReviewCard(
            title: 'Personal Info',
            child: _reviewGrid([
              ('FULL NAME', data.personal.fullName),
              ('EMAIL ADDRESS', data.personal.email),
              ('DOB', data.personal.dob),
              ('RESIDENTIAL ADDRESS', data.personal.address),
            ]),
          ),
          const SizedBox(height: Dimensions.px16),
          _ReviewCard(
            title: 'Pan Verification',
            child: _reviewGrid([
              ('PAN NUMBER', data.pan.number),
              (
                'DOCUMENT TYPE',
                data.pan.documentType.isEmpty
                    ? 'PAN Card'
                    : data.pan.documentType,
              ),
            ]),
          ),
          const SizedBox(height: Dimensions.px16),
          _ReviewCard(
            title: 'Aadhar Verification',
            child: _reviewGrid([
              ('AADHAAR NUMBER', data.aadhaar.number),
              (
                'DOCUMENT TYPE',
                data.aadhaar.documentType.isEmpty
                    ? 'Aadhaar Card'
                    : data.aadhaar.documentType,
              ),
            ]),
          ),
          const SizedBox(height: Dimensions.px16),
          _ReviewCard(
            title: 'Nominee Verification',
            child: _reviewGrid([
              ('NOMINEE NAME', data.nominee.name),
              ('NOMINEE PAN', data.nominee.pan),
              ('NOMINEE DOB', data.nominee.dob),
              ('NOMINEE AADHAAR', data.nominee.aadhaar),
            ]),
          ),
          const SizedBox(height: Dimensions.px16),
          _ReviewCard(
            title: 'Bank Verification',
            child: _reviewGrid([
              ('BENEFICIARY NAME', data.bank.beneficiaryName),
              ('ACCOUNT NUMBER', data.bank.accountNumber),
              ('BRANCH NAME', data.bank.branch),
              ('IFSC CODE', data.bank.ifsc),
            ]),
          ),
          const SizedBox(height: Dimensions.px16),
          _ReviewCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: Dimensions.px26,
                  height: Dimensions.px26,
                  child: Checkbox(
                    value: vm.reviewAccepted,
                    onChanged: (_) => vm.toggleReviewAccepted(),
                    activeColor: const Color(0xFF3D7A6A),
                  ),
                ),
                const SizedBox(width: Dimensions.px10),
                Expanded(
                  child: Text(
                    'I confirm all details are correct\n\nI hereby declare that the information provided is true and accurate to the best of my knowledge. I understand that providing false information may result in application rejection.',
                    style: AppTextStyles.regularText(
                      fontSize: Dimensions.px14,
                      color: ColorConstants.pronexTextGrey,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (vm.reviewError != null) ...[
            const SizedBox(height: Dimensions.px12),
            Text(
              vm.reviewError!,
              style: AppTextStyles.regularText(
                fontSize: Dimensions.px13,
                color: ColorConstants.radicalRed,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _reviewGrid(List<(String, String)> values) {
    return Wrap(
      spacing: Dimensions.px18,
      runSpacing: Dimensions.px18,
      children: values
          .map(
            (item) => SizedBox(
              width: 145,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.$1,
                    style: AppTextStyles.boldText(
                      fontSize: Dimensions.px10,
                      color: const Color(0xFF98A2B3),
                    ),
                  ),
                  const SizedBox(height: Dimensions.px7),
                  Text(
                    item.$2.isEmpty ? '-' : item.$2,
                    style: AppTextStyles.semiBoldText(
                      fontSize: Dimensions.px14,
                      color: const Color(0xFF172033),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  // ---------------- SHARED FORM WIDGETS ----------------

  List<BoxShadow> _cardShadow() {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.03),
        blurRadius: Dimensions.px10,
        offset: const Offset(0, 2),
      ),
    ];
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    TextEditingController? controller,
    TextInputType keyboard = TextInputType.text,
    Widget? suffix,
    Widget? prefix,
    bool verified = false,
    bool obscure = false,
    bool readOnly = false,
    bool uppercase = false,
    bool digitsOnly = false,
    int? maxLength,
    String? errorText,
    ValueChanged<String>? onChanged,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.boldText(
            fontSize: Dimensions.px11,
            color: const Color(0xFF1E293B).withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: Dimensions.px8),
        Container(
          height: Dimensions.px52,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F1FB),
            borderRadius: BorderRadius.circular(Dimensions.px14),
            border: Border.all(
              color: const Color(0xFFE0DEF0),
              width: Dimensions.px1,
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              if (prefix != null) prefix,
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboard,
                  maxLength: maxLength,
                  inputFormatters: [
                    if (digitsOnly) FilteringTextInputFormatter.digitsOnly,
                    if (uppercase)
                      TextInputFormatter.withFunction(
                        (oldValue, newValue) => newValue.copyWith(
                          text: newValue.text.toUpperCase(),
                        ),
                      ),
                  ],
                  obscureText: obscure,
                  readOnly: readOnly,
                  onTap: onTap,
                  onChanged: onChanged,
                  style: AppTextStyles.regularText(
                    fontSize: Dimensions.px14,
                    color: ColorConstants.pronexTextDark,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: hint,
                    hintStyle: AppTextStyles.regularText(
                      fontSize: Dimensions.px14,
                      color: const Color(0xFF94A3B8),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: prefix == null
                          ? Dimensions.px14
                          : Dimensions.px4,
                      vertical: Dimensions.px12,
                    ),
                  ),
                ),
              ),
              if (suffix != null) suffix,
              if (verified && suffix == null)
                Padding(
                  padding: const EdgeInsets.only(right: Dimensions.px12),
                  child: Container(
                    width: Dimensions.px20,
                    height: Dimensions.px20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3D7A6A),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.check_rounded,
                      color: ColorConstants.white,
                      size: Dimensions.px13,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: Dimensions.px5),
          Text(
            errorText,
            style: AppTextStyles.regularText(
              fontSize: Dimensions.px12,
              color: ColorConstants.radicalRed,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDashedUploadBox({
    required String label,
    required IconData icon,
    required bool isUploaded,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: isUploaded
              ? const Color(0xFF3D7A6A).withValues(alpha: 0.55)
              : const Color(0xFFC9D0DB),
          strokeWidth: 1,
          gap: 5,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: Dimensions.px26),
          decoration: BoxDecoration(
            color: isUploaded ? const Color(0xFFF0F8F4) : Colors.transparent,
            borderRadius: BorderRadius.circular(Dimensions.px18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: Dimensions.px52,
                height: Dimensions.px52,
                decoration: BoxDecoration(
                  color: isUploaded
                      ? const Color(0xFF3D7A6A).withValues(alpha: 0.12)
                      : const Color(0xFFE6EFEB),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: isUploaded
                    ? Icon(
                        Icons.check_rounded,
                        color: const Color(0xFF3D7A6A),
                        size: Dimensions.px24,
                      )
                    : Icon(
                        icon,
                        color: const Color(0xFF3D7A6A),
                        size: Dimensions.px26,
                      ),
              ),
              const SizedBox(height: Dimensions.px10),
              Text(
                label,
                style: AppTextStyles.boldText(
                  fontSize: Dimensions.px12,
                  color: isUploaded
                      ? const Color(0xFF3D7A6A)
                      : ColorConstants.pronexTextGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- BOTTOM ACTION BAR ----------------

  Widget _buildBottomActionBar(KYCViewModel vm) {
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
      child: SafeArea(top: false, child: _buildButtonsForStep(vm)),
    );
  }

  Widget _buildButtonsForStep(KYCViewModel vm) {
    switch (vm.currentStep) {
      case 1:
        return Row(
          children: [
            Expanded(
              child: _buildGhostButton(
                icon: Icons.save_outlined,
                label: 'SAVE & COMPLETE\nLATER',
                onTap: vm.doLater,
              ),
            ),
            const SizedBox(width: Dimensions.px12),
            Expanded(
              flex: 2,
              child: _buildPrimaryButton(
                label: vm.isSubmittingBasic ? 'SAVING...' : 'CONTINUE TO\nPAN',
                icon: Icons.arrow_forward_rounded,
                onTap: vm.isSubmittingBasic ? () {} : vm.continueToIdentity,
              ),
            ),
          ],
        );
      case 2:
        return Row(
          children: [
            Expanded(
              child: _buildGhostButton(
                icon: Icons.arrow_back_rounded,
                label: 'BACK',
                onTap: vm.goBack,
              ),
            ),
            const SizedBox(width: Dimensions.px12),
            Expanded(
              flex: 2,
              child: _buildPrimaryButton(
                label: 'CONTINUE TO\nAADHAAR',
                icon: Icons.arrow_forward_rounded,
                onTap: vm.continueToPan,
              ),
            ),
          ],
        );
      case 3:
        return Row(
          children: [
            Expanded(
              child: _buildGhostButton(
                icon: Icons.arrow_back_rounded,
                label: 'BACK',
                onTap: vm.goBack,
              ),
            ),
            const SizedBox(width: Dimensions.px12),
            Expanded(
              flex: 2,
              child: _buildPrimaryButton(
                label: vm.isSubmittingAadhaar
                    ? 'UPLOADING...'
                    : 'CONTINUE TO\nNOMINEE',
                icon: Icons.arrow_forward_rounded,
                onTap: vm.isSubmittingAadhaar ? () {} : vm.continueToAadhaar,
              ),
            ),
          ],
        );
      case 4:
        return Row(
          children: [
            Expanded(
              child: _buildGhostButton(
                icon: Icons.arrow_back_rounded,
                label: 'BACK',
                onTap: vm.goBack,
              ),
            ),
            const SizedBox(width: Dimensions.px12),
            Expanded(
              flex: 2,
              child: _buildPrimaryButton(
                label: vm.isSubmittingNominee
                    ? 'SAVING...'
                    : 'CONTINUE TO\nBANK',
                icon: Icons.arrow_forward_rounded,
                onTap: vm.isSubmittingNominee ? () {} : vm.continueToNominee,
              ),
            ),
          ],
        );
      case 5:
        return Row(
          children: [
            Expanded(
              child: _buildGhostButton(
                icon: Icons.arrow_back_rounded,
                label: 'BACK',
                onTap: vm.goBack,
              ),
            ),
            const SizedBox(width: Dimensions.px12),
            Expanded(
              flex: 2,
              child: _buildPrimaryButton(
                label: vm.isSubmittingBank ? 'UPLOADING...' : 'REVIEW & SUBMIT',
                onTap: vm.isSubmittingBank ? () {} : vm.submitKyc,
              ),
            ),
          ],
        );
      case 6:
      default:
        return Row(
          children: [
            Expanded(
              child: _buildGhostButton(
                icon: Icons.arrow_back_rounded,
                label: 'BACK',
                onTap: vm.goBack,
              ),
            ),
            const SizedBox(width: Dimensions.px12),
            Expanded(
              flex: 2,
              child: _buildPrimaryButton(
                label: vm.isSubmittingKyc ? 'SUBMITTING...' : 'SUBMIT KYC',
                icon: Icons.check_rounded,
                onTap: vm.reviewAccepted ? vm.confirmKyc : () {},
              ),
            ),
          ],
        );
    }
  }

  Widget _buildGhostButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: Dimensions.px58,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.px12),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F1FB),
          borderRadius: BorderRadius.circular(Dimensions.px20),
          border: Border.all(
            color: const Color(0xFFE0DEF0),
            width: Dimensions.px1,
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF3D7A6A), size: Dimensions.px18),
            const SizedBox(width: Dimensions.px6),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: AppTextStyles.boldText(
                  fontSize: Dimensions.px11,
                  color: const Color(0xFF3D7A6A),
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: Dimensions.px58,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.px14),
        decoration: BoxDecoration(
          color: const Color(0xFF3D7A6A),
          borderRadius: BorderRadius.circular(Dimensions.px20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3D7A6A), Color(0xFF2D5E52)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3D7A6A).withValues(alpha: 0.28),
              blurRadius: Dimensions.px14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: AppTextStyles.boldText(
                  fontSize: Dimensions.px12,
                  color: ColorConstants.white,
                  height: 1.2,
                ),
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: Dimensions.px6),
              Icon(icon, color: ColorConstants.white, size: Dimensions.px18),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String? title;
  final Widget child;

  const _ReviewCard({this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.px20),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(Dimensions.px20),
        border: Border.all(color: const Color(0xFFE1E5EA)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: Dimensions.px12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: AppTextStyles.boldText(
                fontSize: Dimensions.px18,
                color: const Color(0xFF05664F),
              ),
            ),
            const SizedBox(height: Dimensions.px20),
          ],
          child,
        ],
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final List<Widget> children;

  const _FormCard({
    required this.icon,
    required this.title,
    this.description,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.px22),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(Dimensions.px24),
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
          Row(
            children: [
              Container(
                width: Dimensions.px40,
                height: Dimensions.px40,
                decoration: BoxDecoration(
                  color: const Color(0xFF3D7A6A).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.px12),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: const Color(0xFF3D7A6A),
                  size: Dimensions.px22,
                ),
              ),
              const SizedBox(width: Dimensions.px12),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.boldText(
                    fontSize: Dimensions.px20,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          if (description != null) ...[
            const SizedBox(height: Dimensions.px10),
            Text(
              description!,
              style: AppTextStyles.regularText(
                fontSize: Dimensions.px13,
                color: ColorConstants.pronexTextGrey,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: Dimensions.px22),
          ...children,
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    final radius = Dimensions.px16;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final dashPath = _createDashedPath(path, gap * 2, gap);
    canvas.drawPath(dashPath, paint);
  }

  Path _createDashedPath(Path source, double dash, double gap) {
    final result = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0;
      bool draw = true;
      while (distance < metric.length) {
        final len = draw ? dash : gap;
        if (distance + len > metric.length) {
          if (draw) {
            result.addPath(
              metric.extractPath(distance, metric.length),
              Offset.zero,
            );
          }
          break;
        }
        if (draw) {
          result.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }
    return result;
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gap != gap;
  }
}
