import 'package:pronex/core/constants/app_constants.dart';
import 'package:pronex/core/di/injector.dart';
import 'package:pronex/core/helper/helper_imports.dart';
import 'package:pronex/core/repository/app_repository.dart';
import 'package:pronex/core/utils/data_state.dart';
import 'package:pronex/presentations/verify_otp/verify_otp_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../core/enums/response_state_enum.dart';
import '../../core/utils/view_state.dart';

class SignupViewModel extends BaseViewModel {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final AppRepository _repo = injector<AppRepository>();
  ViewState<dynamic> viewState = ViewState(state: ResponseState.empty);
  void _setViewState(ViewState<dynamic> state) {
    viewState = state;
    notifyListeners();
  }
  bool _agreeToTerms = false;
  bool get agreeToTerms => _agreeToTerms;

  void init() {}

  void setAgreeToTerms(bool value) {
    _agreeToTerms = value;
    rebuildUi();
  }

  Future<void> onCreateAccountPressed() async {
    final name = fullNameController.text.trim();
    final email = emailController.text.trim();
    if (name.isEmpty || email.isEmpty) {
      AppHelper.showSnackBar(message: 'Enter your name and email address');
      return;
    }
    _setViewState(ViewState.loading());
    setBusy(true);
    final result = await _repo.sendOtp(email: email, name: name);
    setBusy(false);
    if (result is DataSuccess) {
      _setViewState(ViewState.complete("data"));

      RoutingHelper.pushToScreen(screen: VerifyOtpView(email: email));
    } else if (result is DataFailed) {
      _setViewState(ViewState.complete("data"));
      AppHelper.showSnackBar(message: result.error ?? 'Unable to send OTP');
    }
  }

  void onLoginPressed() {}

  void onTermsAndConditionsPressed() {}

  void onPrivacyPolicyPressed() {}

  void onBackPressed() {
    Navigator.pop(AppConstants.globalNavKey.currentContext!);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    super.dispose();
  }
}
