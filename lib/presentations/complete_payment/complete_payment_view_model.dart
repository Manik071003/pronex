import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/app_constants.dart';
import '../../core/di/injector.dart';
import '../../core/helper/app_helper.dart';
import '../../core/models/base_view_model.dart';
import '../../core/models/created_investment_model.dart';
import '../../core/repository/app_repository.dart';
import '../../core/utils/data_state.dart';
import '../widgets/custom_widgets/custom_snackbar.dart';

enum PaymentMethodType { bankTransfer, upi }

class CompletePaymentViewModel extends BaseViewModel {
  final CreatedInvestment investment;
  final AppRepository _repo = injector<AppRepository>();

  CompletePaymentViewModel(this.investment) {
    accountName = investment.accountName;
    accountNumber = investment.accountNumber;
    ifscCode = investment.ifsc;
    bankName = investment.bankName;
    upiId = investment.upiId;
    qrCodeUrl = investment.qrCodeUrl;
    _loadPaymentSettings();
  }

  PaymentMethodType _selectedMethod = PaymentMethodType.upi;
  PaymentMethodType get selectedMethod => _selectedMethod;

  final paymentReferenceCtrl = TextEditingController();
  File? screenshot;
  String? errorMessage;
  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  String accountName = '';
  String accountNumber = '';
  String ifscCode = '';
  String bankName = '';
  String upiId = '';
  String qrCodeUrl = '';
  bool isLoadingPaymentSettings = false;

  bool get canSubmit =>
      paymentReferenceCtrl.text.trim().isNotEmpty &&
      screenshot != null &&
      !_isSubmitting;

  String get paymentMethodValue =>
      _selectedMethod == PaymentMethodType.upi ? 'UPI' : 'Bank Transfer';

  Future<void> _loadPaymentSettings() async {
    try {
      isLoadingPaymentSettings = true;
      notifyListeners();

      final result = await _repo.paymentSettings();
      if (result is DataSuccess && result.data is Map) {
        final payload = Map<String, dynamic>.from(result.data as Map);
        final settings = payload['settings'];
        final payment = settings is Map
            ? Map<String, dynamic>.from(settings)
            : const <String, dynamic>{};

        if (payment.isNotEmpty) {
          accountName = (payment['accountName'] ?? accountName).toString();
          accountNumber = (payment['accountNumber'] ?? accountNumber).toString();
          ifscCode = (payment['ifscCode'] ?? ifscCode).toString();
          bankName = (payment['bankName'] ?? bankName).toString();
          upiId = (payment['upiId'] ?? upiId).toString();
          qrCodeUrl = (payment['qrCode'] ?? payment['qrCodeUrl'] ?? qrCodeUrl)
              .toString();
          notifyListeners();
        }
      }
    } catch (_) {
      // Keep the investment fallback values if the payment settings call fails.
    } finally {
      isLoadingPaymentSettings = false;
      notifyListeners();
    }
  }

  void selectMethod(PaymentMethodType method) {
    _selectedMethod = method;
    notifyListeners();
  }

  void onReferenceChanged(String _) {
    notifyListeners();
  }

  Future<void> pickScreenshot() async {
    final file = await AppHelper.getImage(ImageSource.gallery);
    if (file != null) {
      screenshot = file;
      notifyListeners();
    }
  }

  Future<void> submitPaymentProof() async {
    if (!canSubmit) return;
    _isSubmitting = true;
    errorMessage = null;
    notifyListeners();
    try {
      final result = await _repo.submitPaymentProof(
        investmentId: investment.id,
        paymentReference: paymentReferenceCtrl.text.trim(),
        paymentMethod: paymentMethodValue,
        document: screenshot!,
      );
      if (result is DataSuccess) {
        AppSnackBar.show(
          message: 'Admin will verify the payment',
        );
        Navigator.of(AppConstants.globalNavKey.currentContext!).pop();
      } else if (result is DataFailed) {
        errorMessage = result.error ?? 'Failed to submit payment proof';
        AppSnackBar.show(
          message: errorMessage!,
          isError: true,
        );
      }
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
      AppSnackBar.show(message: errorMessage!, isError: true);
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void onClose() {
    Navigator.of(AppConstants.globalNavKey.currentContext!).pop();
  }

  @override
  void dispose() {
    paymentReferenceCtrl.dispose();
    super.dispose();
  }
}
