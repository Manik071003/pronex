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
import '../signup/signup_view.dart';

class LoginViewModel extends BaseViewModel {
  final TextEditingController emailController = TextEditingController();
  final AppRepository _repo = injector<AppRepository>();
  ViewState<dynamic> viewState = ViewState(state: ResponseState.empty);

  void _setViewState(ViewState<dynamic> state) {
    viewState = state;
    notifyListeners();
  }

  void init() {}

  Future<void> onSendOtpPressed() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      AppHelper.showSnackBar(message: 'Enter your email address');
      return;
    }
    _setViewState(ViewState.loading());
    setBusy(true);
    final result = await _repo.loginOtp(email: email);
    setBusy(false);
    if (result is DataSuccess) {

      RoutingHelper.pushToScreen(screen: VerifyOtpView(email: email));
      _setViewState(ViewState.complete("data"));
     notifyListeners();
    } else if (result is DataFailed) {
      _setViewState(ViewState.complete("data"));
      AppHelper.showSnackBar(message: result.error ?? 'Unable to send OTP');
    }
  }

  void onSignupPressed() {
    RoutingHelper.pushToScreen(screen: SignupView());
  }

  void onBackPressed() {
    Navigator.pop(AppConstants.globalNavKey.currentContext!);
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
