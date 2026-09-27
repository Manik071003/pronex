import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/helper/investment_payment_flow.dart';
import '../../core/models/base_view_model.dart';
import '../../core/models/property_detail_model.dart';
import '../../core/repository/app_repository.dart';
import '../../core/utils/data_state.dart';

class ReviewInvestmentViewModel extends BaseViewModel {
  final String propertyId;
  int _shares;
  String referralCode;
  final AppRepository _repo = AppRepository();

  PropertyDetailModel? _property;
  PropertyDetailModel? get property => _property;
  bool _isLoadingProperty = true;
  bool get isLoadingProperty => _isLoadingProperty;

  bool _isValidatingReferral = false;
  bool get isValidatingReferral => _isValidatingReferral;
  bool _referralValidated = false;
  bool get referralValidated => _referralValidated;
  String? _referralMessage;
  String? get referralMessage => _referralMessage;

  ReviewInvestmentViewModel(
    this.propertyId, {
    int shares = 1,
    this.referralCode = '',
  }) : _shares = shares > 0 ? shares : 1 {
    _loadProperty();
  }

  String get propertyName => _property?.name.isNotEmpty == true
      ? _property!.name
      : 'Property';
  String get propertyLocation => _property?.displayLocation ?? '';
  String get annualYield => '${(_property?.rentalYield ?? 0).toStringAsFixed(1)}%';
  String get expectedRoi => '${(_property?.targetROI ?? _property?.roi ?? 0).toStringAsFixed(1)}%';
  double get sharePrice => (_property?.sharePrice ?? 0).toDouble();
  int get shares => _shares;
  double get investmentAmount => _shares * sharePrice;
  String get monthlyRental => formatCurrency(
        investmentAmount * ((_property?.rentalYield ?? 0) / 100) / 12,
      );
  String get annualRental => formatCurrency(
        investmentAmount * ((_property?.rentalYield ?? 0) / 100),
      );
  String get fiveYearEst => formatCurrency(
        investmentAmount * (1 + ((_property?.roi ?? 0) / 100) * 5),
      );
  int get sharesCount => _shares;
  double get ownershipPercent => _shares.toDouble();

  int get minimumShares => _property?.effectiveMinimumShares ?? 5;
  int get shareStep => _property?.effectiveBuyingCycle ?? 5;
  int get maximumShares => _property?.effectiveShareLimit ?? 1000;
  bool get canIncrementShares => _shares + shareStep <= maximumShares;
  bool get canDecrementShares => _shares > minimumShares;

  void incrementShares() {
    final nextShares = _shares + shareStep;
    if (nextShares <= maximumShares) {
      _shares = nextShares;
      notifyListeners();
    }
  }

  void decrementShares() {
    final nextShares = _shares - shareStep;
    if (nextShares >= minimumShares) {
      _shares = nextShares;
      notifyListeners();
    }
  }

  double get propertyValue => investmentAmount;
  double get platformFee => 0;
  double get taxLegalFee => 0;
  double get totalPayable => investmentAmount;

  bool _paymentAgreementAccepted = false;
  bool get paymentAgreementAccepted => _paymentAgreementAccepted;

  bool get canContinue => _paymentAgreementAccepted && !_isLoadingProperty;

  Future<void> _loadProperty() async {
    try {
      final result = await _repo.propertyDetail(propertyId);
      if (result is DataSuccess && result.data is Map) {
        final payload = Map<String, dynamic>.from(result.data as Map);
        final data = payload['data'] is Map
            ? Map<String, dynamic>.from(payload['data'] as Map)
            : payload;
        _property = PropertyDetailModel.fromJson(data);
      }
    } catch (_) {
      // Keep the checkout usable with the basic property identifier if detail loading fails.
    } finally {
      _isLoadingProperty = false;
      notifyListeners();
    }
  }

  String get propertyImage => _property?.firstImage ?? '';

  String formatCurrency(double value) {
    final amount = value.toInt().toString();
    final formatted = StringBuffer();
    for (int index = 0; index < amount.length; index++) {
      final fromRight = amount.length - index;
      if (index > 0 &&
          ((fromRight > 3 && fromRight % 2 == 1) || fromRight == 4)) {
        formatted.write(',');
      }
      formatted.write(amount[index]);
    }
    return '₹$formatted';
  }

  void setReferralCode(String value) {
    referralCode = value.trim();
    _referralValidated = false;
    _referralMessage = null;
    notifyListeners();
  }

  Future<void> validateReferral() async {
    if (referralCode.isEmpty || _isValidatingReferral) return;
    _isValidatingReferral = true;
    _referralValidated = false;
    _referralMessage = null;
    notifyListeners();
    try {
      final result = await _repo.validateReferral(referralCode: referralCode);
      if (result is DataSuccess) {
        final data = result.data;
        final map = data is Map ? Map<String, dynamic>.from(data) : null;
        final valid = map?['valid'] ?? map?['isValid'] ?? map?['success'];
        if (valid is bool && !valid) {
          _referralMessage = map?['message']?.toString() ?? 'Invalid referral code';
        } else {
          _referralValidated = true;
          _referralMessage = map?['message']?.toString() ?? 'Referral code applied';
        }
      } else {
        _referralMessage = result is DataFailed
            ? (result.error ?? 'Invalid referral code')
            : 'Invalid referral code';
      }
    } catch (_) {
      _referralMessage = 'Unable to validate referral code';
    } finally {
      _isValidatingReferral = false;
      notifyListeners();
    }
  }

  void togglePaymentAgreement() {
    _paymentAgreementAccepted = !_paymentAgreementAccepted;
    notifyListeners();
  }

  void onBackPressed() {
    Navigator.of(AppConstants.globalNavKey.currentContext!).pop();
  }

  void onHelpPressed() {}

  void onViewAgreement(String agreementId) {}

  void onDownloadAgreement(String agreementId) {}

  Future<void> onContinueToPayment() async {
    if (!canContinue || isBusy) return;
    setBusy(true);
    try {
      await InvestmentPaymentFlow.createInvestmentAndOpenPayment(
        propertyId: propertyId,
        shares: shares,
        referralCode: referralCode,
      );
    } finally {
      setBusy(false);
    }
  }
}
