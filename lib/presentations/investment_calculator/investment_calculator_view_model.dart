import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/helper/investment_payment_flow.dart';
import '../../core/models/base_view_model.dart';

class InvestmentCalculatorViewModel extends BaseViewModel {
  final String propertyId;

  static const double defaultSharePrice = 25000;
  static const double defaultAnnualYieldPercent = 8.4;
  static const double defaultRoiPercent = 14.8;
  static const double defaultTotalAssetValue = 25000000;

  final double sharePrice;
  final double annualYieldPercent;
  final double roiPercent;
  final double totalAssetValue;
  final int buyCycle;
  final int minShares;
  final int maxShares;
  static const int totalShares = 1000;

  static const List<double> quickAmounts = [
    25000,
    50000,
    100000,
    500000,
    1000000,
  ];

  static const double minInvestment = 25000;
  static const double maxInvestment = 1000000;

  double _investmentAmount = 500000;
  double get investmentAmount => _investmentAmount;

  int _selectedQuickAmount = 3;
  int get selectedQuickAmount => _selectedQuickAmount;

  int _shareQuantity = 20;
  int get shareQuantity => _shareQuantity;

  InvestmentCalculatorViewModel(
    this.propertyId, {
    double? sharePrice,
    double? annualYieldPercent,
    double? roiPercent,
    double? totalAssetValue,
    int? buyingCycle,
    int? minimumShares,
    int? availableShares,
    int initialShareQuantity = 20,
  }) : sharePrice = sharePrice ?? defaultSharePrice,
       annualYieldPercent = annualYieldPercent ?? defaultAnnualYieldPercent,
       roiPercent = roiPercent ?? defaultRoiPercent,
       totalAssetValue = totalAssetValue ?? defaultTotalAssetValue,
       buyCycle = buyingCycle ?? 5,
       minShares = minimumShares ?? 10,
       maxShares = availableShares ?? 1000 {
    final initial = _normalizeInitialShares(initialShareQuantity);
    _shareQuantity = initial;
    _investmentAmount = _shareQuantity * this.sharePrice;
  }

  void setInvestmentAmount(double value) {
    _investmentAmount = value.clamp(minInvestment, maxInvestment);
    _syncSharesFromAmount();
    _updateQuickSelection();
    notifyListeners();
  }

  void selectQuickAmount(int index) {
    if (index < 0 || index >= quickAmounts.length) return;
    _selectedQuickAmount = index;
    _investmentAmount = quickAmounts[index];
    _syncSharesFromAmount();
    notifyListeners();
  }

  int get minSelection => minShares > 0 ? minShares : 10;
  int get stepSize => buyCycle > 0 ? buyCycle : 5;
  int get maxAllowedShares => maxShares > 0 ? maxShares : totalShares;

  int _normalizeInitialShares(int value) {
    final v = value < minSelection ? minSelection : value;
    return v <= maxAllowedShares ? v : maxAllowedShares;
  }

  void incrementShares() {
    final nextQty = _shareQuantity + stepSize;
    if (nextQty <= maxAllowedShares) {
      _shareQuantity = nextQty;
      _investmentAmount = _shareQuantity * sharePrice;
      _updateQuickSelection();
      notifyListeners();
    }
  }

  void decrementShares() {
    final minValue = minSelection;
    if (_shareQuantity > minValue) {
      final nextQty = _shareQuantity - stepSize;
      _shareQuantity = nextQty >= minValue ? nextQty : minValue;
      _investmentAmount = _shareQuantity * sharePrice;
      _updateQuickSelection();
      notifyListeners();
    }
  }

  void reset() {
    _investmentAmount = 500000;
    _selectedQuickAmount = 3;
    _syncSharesFromAmount();
    notifyListeners();
  }

  void _syncSharesFromAmount() {
    final qty = (_investmentAmount / sharePrice).floor();
    _shareQuantity = qty < 1 ? 1 : qty;
    _investmentAmount = (_shareQuantity * sharePrice).toDouble();
  }

  void _updateQuickSelection() {
    final idx = quickAmounts.indexOf(_investmentAmount);
    _selectedQuickAmount = idx;
  }

  double get ownershipPercent => (_investmentAmount / totalAssetValue) * 100;

  double get expectedAnnualReturn => _investmentAmount * (roiPercent / 100);

  double get monthlyReturn => expectedAnnualReturn / 12;

  double get rentalAnnualReturn =>
      _investmentAmount * (annualYieldPercent / 100);

  double get growthAnnualReturn => expectedAnnualReturn - rentalAnnualReturn;

  double get totalPrincipal => _investmentAmount;

  double get rentalSharePercent => 56;
  double get growthSharePercent => 44;

  void onBackPressed() {
    Navigator.of(AppConstants.globalNavKey.currentContext!).pop();
  }

  void onResetPressed() {
    reset();
  }

  Future<void> onProceedToInvest() async {
    if (isBusy || propertyId.isEmpty) return;
    setBusy(true);
    try {
      await InvestmentPaymentFlow.onProceedToPayment(
        propertyId: propertyId,
        shares: shareQuantity,
      );
    } finally {
      setBusy(false);
    }
  }
}
