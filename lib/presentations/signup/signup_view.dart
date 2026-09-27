import 'package:flutter/material.dart';
import '../../core/constants/app_text_style.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../core/constants/image_constants.dart';
import '../../core/utils/base_view.dart';
import '../widgets/custom_widgets/custom_button.dart';
import '../widgets/custom_widgets/custom_text_field.dart';
import 'signup_view_model.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView.reactive(
      viewModelBuilder: () => SignupViewModel(),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: Dimensions.px16),

                        Center(
                          child: Image.asset(
                            ImageConstants.appLogo,
                            height: Dimensions.px56,
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: Dimensions.px20),

                        Center(
                          child: Text(
                            'Join PRONEX',
                            style: AppTextStyles.boldText(
                              fontSize: Dimensions.px28,
                              color: ColorConstants.pronexTextDark,
                            ),
                          ),
                        ),

                        const SizedBox(height: Dimensions.px12),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.px16,
                          ),
                          child: Text(
                            'Start your journey to premium real estate ownership.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.regularText(
                              fontSize: Dimensions.px18,
                              color: ColorConstants.pronexTextGrey,
                              height: 1.4,
                            ),
                          ),
                        ),

                        const SizedBox(height: Dimensions.px40),

                        CustomTextField(
                          controller: viewModel.fullNameController,
                          labelAbove: 'Full Name',
                          hintText: 'John Doe',
                          textInputType: TextInputType.name,
                          fillColor: ColorConstants.white,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.px14,
                            ),
                            child: Icon(
                              Icons.person_outline,
                              color: ColorConstants.pronexTextGrey,
                              size: Dimensions.px22,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Dimensions.px18,
                            ),
                            borderSide: const BorderSide(
                              color: Color(0xFFE5E7EB),
                              width: Dimensions.px1,
                            ),
                          ),
                          hintTextStyle: AppTextStyles.regularText(
                            fontSize: Dimensions.px16,
                            color: ColorConstants.pronexTextGrey,
                          ),
                        ),

                        const SizedBox(height: Dimensions.px20),

                        CustomTextField(
                          controller: viewModel.emailController,
                          labelAbove: 'Email Address',
                          hintText: 'john@example.com',
                          textInputType: TextInputType.emailAddress,
                          fillColor: ColorConstants.white,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.px14,
                            ),
                            child: Icon(
                              Icons.email_outlined,
                              color: ColorConstants.pronexTextGrey,
                              size: Dimensions.px22,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Dimensions.px18,
                            ),
                            borderSide: const BorderSide(
                              color: Color(0xFFE5E7EB),
                              width: Dimensions.px1,
                            ),
                          ),
                          hintTextStyle: AppTextStyles.regularText(
                            fontSize: Dimensions.px16,
                            color: ColorConstants.pronexTextGrey,
                          ),
                        ),

                        const SizedBox(height: Dimensions.px20),

                        CustomTextField(
                          controller: viewModel.mobileController,
                          labelAbove: 'Mobile Number',
                          hintText: '9365426319',
                          textInputType: TextInputType.phone,
                          fillColor: ColorConstants.white,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.px14,
                            ),
                            child: Icon(
                              Icons.phone_outlined,
                              color: ColorConstants.pronexTextGrey,
                              size: Dimensions.px22,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Dimensions.px18,
                            ),
                            borderSide: const BorderSide(
                              color: Color(0xFFE5E7EB),
                              width: Dimensions.px1,
                            ),
                          ),
                          hintTextStyle: AppTextStyles.regularText(
                            fontSize: Dimensions.px16,
                            color: ColorConstants.pronexTextGrey,
                          ),
                        ),

                        const SizedBox(height: Dimensions.px24),

                        _buildTermsCheckbox(viewModel),

                        const SizedBox(height: Dimensions.px28),

                        CustomButton(
                          label: 'Create Account',
                          state: viewModel.viewState.state,
                          btnColor: ColorConstants.pronexPrimary,
                          borderRadius: Dimensions.px20,
                          height: Dimensions.px50,
                          onTap: viewModel.onCreateAccountPressed,
                          style: AppTextStyles.mediumText(
                            fontSize: Dimensions.px18,
                            fontWeight: FontWeight.w500,
                            color: ColorConstants.white,
                          ),
                        ),

                        const SizedBox(height: Dimensions.px32),

                        GestureDetector(
                          onTap: viewModel.onLoginPressed,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: AppTextStyles.regularText(
                                    fontSize: Dimensions.px16,
                                    color: ColorConstants.pronexTextGrey,
                                  ),
                                ),
                                Text(
                                  'Login',
                                  style: AppTextStyles.semiBoldText(
                                    fontSize: Dimensions.px18,
                                    color: ColorConstants.pronexPrimary,
                                  ),
                                ),
                              ],
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

  Widget _buildAppBar(SignupViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px16,
        vertical: Dimensions.px12,
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
        child: Row(
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
      ),
    );
  }

  Widget _buildTermsCheckbox(SignupViewModel viewModel) {
    return GestureDetector(
      onTap: () {
        viewModel.setAgreeToTerms(!viewModel.agreeToTerms);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Dimensions.px24,
            height: Dimensions.px24,
            margin: const EdgeInsets.only(top: Dimensions.px2),
            decoration: BoxDecoration(
              color: viewModel.agreeToTerms
                  ? ColorConstants.pronexPrimary
                  : ColorConstants.white,
              borderRadius: BorderRadius.circular(Dimensions.px6),
              border: Border.all(
                color: viewModel.agreeToTerms
                    ? ColorConstants.pronexPrimary
                    : const Color(0xFFD1D5DB),
                width: Dimensions.px2,
              ),
            ),
            child: viewModel.agreeToTerms
                ? Icon(
                    Icons.check,
                    size: Dimensions.px16,
                    color: ColorConstants.white,
                  )
                : null,
          ),
          const SizedBox(width: Dimensions.px12),
          Expanded(
            child: Wrap(
              children: [
                Text(
                  'I agree to the ',
                  style: AppTextStyles.regularText(
                    fontSize: Dimensions.px15,
                    color: ColorConstants.pronexTextDark,
                  ),
                ),
                GestureDetector(
                  onTap: viewModel.onTermsAndConditionsPressed,
                  child: Text(
                    'Terms & Conditions',
                    style: AppTextStyles.semiBoldText(
                      fontSize: Dimensions.px15,
                      color: ColorConstants.pronexPrimary,
                    ),
                  ),
                ),
                Text(
                  ' and ',
                  style: AppTextStyles.regularText(
                    fontSize: Dimensions.px15,
                    color: ColorConstants.pronexTextDark,
                  ),
                ),
                GestureDetector(
                  onTap: viewModel.onPrivacyPolicyPressed,
                  child: Text(
                    'Privacy Policy',
                    style: AppTextStyles.semiBoldText(
                      fontSize: Dimensions.px15,
                      color: ColorConstants.pronexPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
