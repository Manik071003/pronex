import 'dart:async';
import 'package:pronex/core/constants/constant_imports.dart';
import 'package:pronex/core/di/injector.dart';
import 'package:pronex/core/helper/helper_imports.dart';
import 'package:pronex/core/repository/app_repository.dart';
import 'package:pronex/core/utils/data_state.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../core/enums/response_state_enum.dart';
import '../../core/utils/view_state.dart';
import '../bottom_nav_bar/bottom_nav_bar.dart';

class VerifyOtpViewModel extends BaseViewModel {
  final String email;
  final AppRepository _repo = injector<AppRepository>();
  ViewState<dynamic> viewState = ViewState(state: ResponseState.empty);
  void _setViewState(ViewState<dynamic> state) {
    viewState = state;
    notifyListeners();
  }
  VerifyOtpViewModel({required this.email});

  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  int _countdownSeconds = 60;
  int get countdownSeconds => _countdownSeconds;

  bool get isResendEnabled => _countdownSeconds == 0;

  Timer? _timer;

  void init() {
    _startCountdown();
  }

  void _startCountdown() {
    _countdownSeconds = 60;
    rebuildUi();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        _countdownSeconds--;
        rebuildUi();
      } else {
        timer.cancel();
      }
    });
  }

  void onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  String getOtpCode() {
    return otpControllers.map((c) => c.text).join();
  }

  Future<void> onVerifyPressed() async {
    final otp = getOtpCode();
    if (otp.length != 6) {
      AppHelper.showSnackBar(message: 'Enter the 6-digit OTP');
      return;
    }
    _setViewState(ViewState.loading());
    setBusy(true);
    final result = await _repo.verifyOtp(email: email, otp: otp);
    setBusy(false);
    if (result is DataSuccess) {
      _setViewState(ViewState.complete("data"));

      AppLogger.log("${result.data} +wkjnfjlndlsknfkl");
      await SharedPrefHelper.setString(SharedPrefs.token, result.data["token"]);
      await SharedPrefHelper.setString(SharedPrefs.userName, result.data["user"]["name"]);
      await SharedPrefHelper.setBool(SharedPrefs.isLoggedIn, true);
      RoutingHelper.pushAndRemoveUntilToScreen(screen: BottomNavBarView());
    } else if (result is DataFailed) {
      _setViewState(ViewState.complete("data"));
      AppHelper.showSnackBar(message: result.error ?? 'Invalid OTP');
    }
  }

  Future<void> onResendOtpPressed() async {
    if (isResendEnabled) {
      setBusy(true);
      final result = await _repo.resendOtp(email: email);
      setBusy(false);
      if (result is DataSuccess) {
        _startCountdown();
      } else if (result is DataFailed) {
        AppHelper.showSnackBar(message: result.error ?? 'Unable to resend OTP');
      }
    }
  }

  void onEditEmailPressed() {}

  void onBackPressed() {
    Navigator.pop(AppConstants.globalNavKey.currentContext!);
  }

  String get countdownFormatted {
    final mins = (_countdownSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (_countdownSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in otpControllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }
}
