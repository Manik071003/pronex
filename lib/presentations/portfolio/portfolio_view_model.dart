import 'dart:io';

import '../../core/di/injector.dart';
import '../../core/models/base_view_model.dart';
import '../../core/models/portfolio_model.dart';
import '../../core/repository/app_repository.dart';
import '../../core/utils/data_state.dart';
import '../widgets/custom_widgets/custom_snackbar.dart';

class PortfolioViewModel extends BaseViewModel {
  final AppRepository _repo = injector<AppRepository>();

  int _selectedTab = 0;
  int get selectedTab => _selectedTab;

  final List<String> tabs = const [
    'Active Investments',
    'Pending Investments',
    'Watchlist',
    'Payment History',
    'Documents',
    'Support / Exit Request',
    'Refer & Earn',
  ];

  PortfolioModel _portfolio = PortfolioModel.empty();
  PortfolioModel get portfolio => _portfolio;
  PortfolioSummary get summary => _portfolio.summary;
  List<PortfolioInvestment> get investments => _portfolio.investments;
  List<PendingPortfolioInvestment> get pendingInvestments =>
      _portfolio.pendingInvestments;
  List<PendingPortfolioInvestment> get paymentHistory {
    final mappedInvestments = investments
          .map(
            (investment) => PendingPortfolioInvestment(
              name: investment.name,
              imageUrl: investment.imageUrl,
              location: investment.location,
              shares: investment.shares,
              amount: investment.investedAmount,
              submittedAt: investment.submittedAt,
              status: investment.status,
            ),
          )
          .toList();
    final mappedPending = _portfolio.pendingInvestments;

    if (_portfolio.paymentHistory.isEmpty) {
      return [...mappedInvestments, ...mappedPending];
    }

      final existing = <String>{};
      final combined = <PendingPortfolioInvestment>[];
      for (final payment in _portfolio.paymentHistory) {
        final key = '${payment.name}|${payment.submittedAt}|${payment.amount}|${payment.shares}';
        if (existing.add(key)) combined.add(payment);
      }
      for (final payment in mappedInvestments) {
        final key = '${payment.name}|${payment.submittedAt}|${payment.amount}|${payment.shares}';
        if (existing.add(key)) combined.add(payment);
      }
      for (final payment in mappedPending) {
        final key = '${payment.name}|${payment.submittedAt}|${payment.amount}|${payment.shares}';
        if (existing.add(key)) combined.add(payment);
      }
      return combined;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _referralCode = '';
  String get referralCode => _referralCode;
  String _referralLink = '';
  String get referralLink => _referralLink;
  String _referredByName = '';
  String get referredByName => _referredByName;
  List<Map<String, dynamic>> _referralRewards = [];
  List<Map<String, dynamic>> get referralRewards => _referralRewards;

  Future<void> fetchPortfolio() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final portfolioResult = await _repo.portfolio();
      final documentsResult = await _repo.portfolioDocuments();
      if (portfolioResult is DataSuccess) {
        final portfolio = PortfolioModel.fromJson(portfolioResult.data);
        final documents = documentsResult is DataSuccess
            ? PortfolioModel.fromJson(documentsResult.data).documents
            : const <PortfolioDocument>[];
        _portfolio = PortfolioModel(
          summary: portfolio.summary,
          investments: portfolio.investments,
          pendingInvestments: portfolio.pendingInvestments,
          paymentHistory: portfolio.paymentHistory,
          documents: documents,
          kycDetails: documentsResult is DataSuccess
              ? PortfolioModel.fromJson(documentsResult.data).kycDetails
              : portfolio.kycDetails,
        );
      } else if (portfolioResult is DataFailed) {
        _errorMessage = portfolioResult.error ?? 'Failed to load portfolio';
      }
      if (documentsResult is DataFailed && _errorMessage == null) {
        _errorMessage = documentsResult.error ?? 'Failed to load documents';
      }
      await fetchReferralData();
    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchReferralData() async {
    try {
      final referralResult = await _repo.referral();
      if (referralResult is DataSuccess && referralResult.data is Map) {
        final data = Map<String, dynamic>.from(referralResult.data as Map);
        _referralCode = data['referralCode']?.toString() ?? '';
        _referralLink = data['referralLink']?.toString() ?? '';
        final referredBy = data['referredBy'];
        if (referredBy is Map) {
          _referredByName = referredBy['name']?.toString() ?? '';
        }
      }

      final rewardsResult = await _repo.referralRewards();
      if (rewardsResult is DataSuccess && rewardsResult.data is Map) {
        final data = Map<String, dynamic>.from(rewardsResult.data as Map);
        final rewards = data['rewards'];
        if (rewards is List) {
          _referralRewards = rewards
              .whereType<Map>()
              .map((reward) => Map<String, dynamic>.from(reward))
              .toList();
        }
      }
      notifyListeners();
    } catch (_) {
      // Referral content can remain empty without blocking the portfolio.
    }
  }

  void setTab(int index) {
    _selectedTab = index;
    notifyListeners();
  }

  void onExploreMoreProperties() {}

  Future<void> requestOwnership({required PortfolioInvestment investment}) async {
    if (investment.id == null || investment.id!.isEmpty) {
      AppSnackBar.show(message: 'Investment ID is missing', isError: true);
      return;
    }

    setBusy(true);
    try {
      final result = await _repo.requestOwnership(investmentId: investment.id!);
      if (result is DataSuccess) {
        AppSnackBar.show(message: 'Full ownership request submitted');
      } else if (result is DataFailed) {
        AppSnackBar.show(
          message: result.error ?? 'Failed to request full ownership',
          isError: true,
        );
      }
    } catch (_) {
      AppSnackBar.show(
        message: 'Failed to request full ownership',
        isError: true,
      );
    } finally {
      setBusy(false);
    }
  }

  Future<void> requestExit({
    required PortfolioInvestment investment,
    required int shares,
    String reason = '',
  }) async {
    if (investment.id == null || investment.id!.isEmpty) {
      AppSnackBar.show(message: 'Investment ID is missing', isError: true);
      return;
    }
    if (shares <= 0 || shares % 10 != 0) {
      AppSnackBar.show(
        message: 'Exit shares must be a multiple of 10',
        isError: true,
      );
      return;
    }

    setBusy(true);
    try {
      final result = await _repo.requestPortfolioExit(
        investmentId: investment.id!,
        shares: shares,
        reason: reason,
      );
      if (result is DataSuccess) {
        AppSnackBar.show(message: 'Exit request submitted for approval');
      } else if (result is DataFailed) {
        AppSnackBar.show(
          message: result.error ?? 'Failed to request exit',
          isError: true,
        );
      }
    } catch (_) {
      AppSnackBar.show(
        message: 'Failed to request exit',
        isError: true,
      );
    } finally {
      setBusy(false);
    }
  }

  Future<void> submitPaymentApproval({
    required PortfolioInvestment investment,
    required String paymentReference,
    required String paymentMethod,
    required File document,
  }) async {
    if (investment.id == null || investment.id!.isEmpty) {
      AppSnackBar.show(message: 'Investment ID is missing', isError: true);
      return;
    }
    try {
      final result = await _repo.submitPaymentProof(
        investmentId: investment.id!,
        paymentReference: paymentReference,
        paymentMethod: paymentMethod,
        document: document,
      );
      if (result is DataSuccess) {
        AppSnackBar.show(message: 'Payment proof submitted for approval');
      } else if (result is DataFailed) {
        AppSnackBar.show(
          message: result.error ?? 'Failed to submit payment proof',
          isError: true,
        );
      }
    } catch (_) {
      AppSnackBar.show(
        message: 'Failed to submit payment proof',
        isError: true,
      );
    }
  }

  void retry() {
    fetchPortfolio();
  }
}
