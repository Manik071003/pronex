import 'package:flutter/material.dart';
import '../../core/constants/app_text_style.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../core/constants/image_constants.dart';
import '../../core/utils/base_view.dart';
import '../widgets/custom_widgets/custom_button.dart';
import 'verify_otp_view_model.dart';

class VerifyOtpView extends StatelessWidget {
  final String email;

  const VerifyOtpView({required this.email, super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView.reactive(
      viewModelBuilder: () => VerifyOtpViewModel(email: email),
      onViewModelReady: (viewModel) => viewModel.init(),
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: ColorConstants.white,
          body: SafeArea(
            child: Column(
              children: [
                _buildAppBar(viewModel),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.px24,
                    ),
                    child: Column(
                      children: [
                        _buildIllustration(),

                        Text(
                          'Verify Your Email',
                          style: AppTextStyles.boldText(
                            fontSize: Dimensions.px26,
                            color: ColorConstants.pronexTextDark,
                          ),
                        ),

                        GestureDetector(
                          onTap: viewModel.onEditEmailPressed,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Code sent to $email ',
                                style: AppTextStyles.regularText(
                                  fontSize: Dimensions.px16,
                                  color: ColorConstants.pronexTextGrey,
                                ),
                              ),
                              Icon(
                                Icons.edit,
                                size: Dimensions.px18,
                                color: ColorConstants.pronexPrimary,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: Dimensions.px10),

                        _buildOtpFields(viewModel),

                        const SizedBox(height: Dimensions.px10),

                        Text(
                          'CODE EXPIRES IN ${viewModel.countdownFormatted}',
                          style: AppTextStyles.semiBoldText(
                            fontSize: Dimensions.px16,
                            color: ColorConstants.pronexPrimary,
                          ),
                        ),

                        const SizedBox(height: Dimensions.px16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't receive the code? ",
                              style: AppTextStyles.regularText(
                                fontSize: Dimensions.px16,
                                color: ColorConstants.pronexTextGrey,
                              ),
                            ),
                            GestureDetector(
                              onTap: viewModel.isResendEnabled
                                  ? viewModel.onResendOtpPressed
                                  : null,
                              child: Text(
                                'Resend OTP',
                                style: AppTextStyles.semiBoldText(
                                  fontSize: Dimensions.px18,
                                  color: viewModel.isResendEnabled
                                      ? ColorConstants.pronexPrimary
                                      : ColorConstants.pronexTextGrey
                                            .withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: Dimensions.px10),

                        CustomButton(
                          label: 'Verify & Continue',
                          state: viewModel.viewState.state,
                          btnColor: ColorConstants.pronexPrimary,
                          borderRadius: Dimensions.px20,
                          height: Dimensions.px50,
                          onTap: viewModel.onVerifyPressed,
                          style: AppTextStyles.mediumText(
                            fontSize: Dimensions.px20,
                            fontWeight: FontWeight.w500,
                            color: ColorConstants.white,
                          ),
                        ),

                        const SizedBox(height: Dimensions.px24),

                        _buildSecurityNotice(),

                        const SizedBox(height: Dimensions.px24),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.px16,
                          ),
                          child: Text(
                            'DIGITAL KYC IS REQUIRED ONLY WHEN YOU MAKE YOUR FIRST INVESTMENT.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.regularText(
                              fontSize: Dimensions.px13,
                              color: ColorConstants.pronexTextGrey.withValues(
                                alpha: 0.6,
                              ),
                              height: 1.4,
                            ),
                          ),
                        ),

                        const SizedBox(height: Dimensions.px28),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(VerifyOtpViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px16,
        vertical: Dimensions.px5,
      ),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFF0F0F0),
            width: Dimensions.px1,
          ),
        ),
      ),
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: viewModel.onBackPressed,
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.px8),
                    child: Icon(
                      Icons.arrow_back,
                      color: ColorConstants.pronexTextDark,
                      size: Dimensions.px28,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              child: Text(
                'PRONEX',
                style: AppTextStyles.boldText(
                  fontSize: Dimensions.px26,
                  color: ColorConstants.pronexPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px5,
        vertical: Dimensions.px40,
      ),
      decoration: BoxDecoration(
        // gradient: RadialGradient(
        //   center: Alignment.center,
        //   radius: 0.9,
        //   colors: [
        //     ColorConstants.pronexPrimaryLight.withValues(alpha: 0.8),
        //     ColorConstants.white,
        //   ],
        // ),
        borderRadius: BorderRadius.circular(Dimensions.px24),
      ),
      child: Center(
        child: Image.asset(ImageConstants.verifyOtp, fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildOtpFields(VerifyOtpViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return Container(
          width: Dimensions.px52,
          height: Dimensions.px70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.px16),
            // border: Border.all(
            //   color: index == 0
            //       ? ColorConstants.pronexPrimary
            //       : const Color(0xFFD1D5DB),
            //   width: index == 0 ? Dimensions.px2 : Dimensions.px1,
            // ),
          ),
          child: Center(
            child: TextFormField(
              controller: viewModel.otpControllers[index],
              focusNode: viewModel.focusNodes[index],
              maxLength: 1,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: AppTextStyles.boldText(
                fontSize: Dimensions.px22,
                color: ColorConstants.pronexTextDark,
              ),
              decoration: const InputDecoration(
                counterText: '',
                // border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) => viewModel.onOtpChanged(index, value),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSecurityNotice() {
    return Container(
      padding: const EdgeInsets.all(Dimensions.px16),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(Dimensions.px20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(Dimensions.px12),
            decoration: BoxDecoration(
              color: ColorConstants.pronexPrimaryLight,
              borderRadius: BorderRadius.circular(Dimensions.px14),
            ),
            child: Icon(
              Icons.verified_user_outlined,
              color: ColorConstants.pronexPrimary,
              size: Dimensions.px26,
            ),
          ),
          const SizedBox(width: Dimensions.px14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: Dimensions.px4),
              child: Text(
                'Your verification code is encrypted and used only to securely verify your identity.',
                style: AppTextStyles.regularText(
                  fontSize: Dimensions.px16,
                  color: ColorConstants.pronexTextDark,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
