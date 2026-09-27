import 'package:flutter/material.dart';
import 'package:pronex/core/helper/helper_imports.dart';
import '../../core/di/injector.dart';
import '../../core/models/base_view_model.dart';
import '../../core/models/portfolio_model.dart';
import '../../core/models/profile_model.dart';
import '../../core/repository/app_repository.dart';
import '../../core/utils/data_state.dart';
import '../onboarding/onboarding_view.dart';
import '../widgets/custom_widgets/custom_snackbar.dart';

class ProfileViewModel extends BaseViewModel {
  final AppRepository _repo = injector<AppRepository>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final messageController = TextEditingController();

  static const inquiryTypes = ['Investment', 'Support', 'KYC', 'General'];
  static const subjects = [
    'Property Investment Inquiry',
    'Account Support',
    'Documents & Statements',
    'General Inquiry',
  ];

  static const faqs = <(String, String)>[
    (
      'What is Pronex World?',
      'Pronex World is an AI-powered fractional real estate investment platform that enables investors to participate in selected real estate opportunities through professionally managed property-specific LLPs.',
    ),
    (
      'How does an investment opportunity work on Pronex World?',
      'Every investment opportunity follows a standardized presentation format. Investors can review the property snapshot, investment highlights, AI investment score, available documents, applicable fees and charges, risk factors and relevant investment documents before making an investment decision.',
    ),
    (
      'What information is available for each property?',
      'Depending on the opportunity, investors can review property information including Property Name, City, Asset Type, Developer, Status, Minimum Investment and LLP Name, along with supporting investment information and disclosures.',
    ),
    (
      'How does the LLP ownership model work?',
      'Each investment opportunity may be structured through a dedicated property-specific LLP. The applicable LLP Agreement governs rights, obligations, governance, voting, distributions and exit mechanisms for that investment opportunity.',
    ),
    (
      'What can I access through the investor dashboard?',
      'The investor dashboard provides access to portfolio overview, current investments, LLP holdings, capital contributed, property updates, financial statements, distribution history, tax documents, KYC status, notifications, support centre and download centre.',
    ),
    (
      'How does diversification help investors?',
      'Diversification does not eliminate investment risk, but it can help reduce concentration risk by allowing investors to build exposure across different cities, developers and asset classes as part of a broader investment strategy.',
    ),
    (
      'What is available in the Research Centre?',
      'The Research Centre includes market intelligence and educational content such as weekly market reports, city investment reports, infrastructure watch, developer insights, rental market analysis, commercial real estate updates, residential price trends, investment guides, economic commentary and AI research notes.',
    ),
    (
      'Are investments risk-free?',
      'No. Real estate and LLP investments are subject to market risks, liquidity risks, regulatory changes, vacancy risks and property-specific considerations. Investors should review the relevant LLP Agreement, investment documents and risk disclosures before making an investment decision.',
    ),
  ];

  InvestorProfile? _profile;
  InvestorProfile? get profile => _profile;

  PortfolioModel _portfolio = PortfolioModel.empty();
  PortfolioModel get portfolio => _portfolio;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSending = false;
  bool get isSending => _isSending;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  int? openFaq;
  String? selectedType;
  String? selectedSubject;

  String get displayName =>
      _profile == null || _profile!.name.trim().isEmpty
          ? 'Investor'
          : _profile!.name.trim();

  String get nameInitial {
    final first = displayName.trim();
    if (first.isEmpty) return 'I';
    return first[0].toUpperCase();
  }

  List<PortfolioDocument> get kycDocuments => _portfolio.documents
      .where((document) => document.url.trim().isNotEmpty)
      .toList();

  String get displayEmail => _profile?.email.trim() ?? '';

  String get displayPhone => _profile?.phone.trim() ?? '';

  bool get isPremium => _portfolio.investments.isNotEmpty;

  String get totalInvestedLabel => _portfolio.summary.formattedTotalInvested;

  String get propertiesOwnedLabel {
    final count = _portfolio.investments.isNotEmpty
        ? _portfolio.investments.length
        : 0;
    return count.toString();
  }

  String get estimatedReturnsLabel {
    final gain =
        _portfolio.summary.currentValue - _portfolio.summary.totalInvested;
    return _formatInr(gain < 0 ? 0 : gain);
  }

  Future<void> init() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repo.profile();
      if (result is DataSuccess) {
        final raw = _unwrap(result.data);
        final response = InvestorProfileResponse.fromJson(raw);
        _profile = response.profile;
        _fillContactForm();
      } else if (result is DataFailed) {
        _errorMessage = result.error ?? 'Failed to load profile';
      }

      final portfolioResult = await _repo.portfolio();
      final documentsResult = await _repo.portfolioDocuments();
      final portfolio = portfolioResult is DataSuccess
          ? PortfolioModel.fromJson(portfolioResult.data)
          : PortfolioModel.empty();
      final documentSource = documentsResult is DataSuccess
          ? PortfolioModel.fromJson(documentsResult.data)
          : portfolio;
      if (portfolioResult is DataSuccess || documentsResult is DataSuccess) {
        _portfolio = PortfolioModel(
          summary: portfolio.summary,
          investments: portfolio.investments,
          pendingInvestments: portfolio.pendingInvestments,
          paymentHistory: portfolio.paymentHistory,
          documents: documentSource.documents,
          kycDetails: documentSource.kycDetails,
        );
      }
    } catch (_) {
      _errorMessage = 'Something went wrong. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _fillContactForm() {
    final profile = _profile;
    if (profile == null) return;
    if (nameController.text.trim().isEmpty) {
      nameController.text = profile.name;
    }
    if (emailController.text.trim().isEmpty) {
      emailController.text = profile.email;
    }
    if (phoneController.text.trim().isEmpty) {
      phoneController.text = profile.phone.replaceAll(RegExp(r'[^0-9]'), '');
    }
  }

  Map<String, dynamic> _unwrap(dynamic data) {
    if (data is Map<String, dynamic>) {
      final nested = data['data'];
      if (data['profile'] == null && nested is Map) {
        return Map<String, dynamic>.from(nested);
      }
      return data;
    }
    if (data is Map) return Map<String, dynamic>.from(data);
    return {};
  }

  void toggleFaq(int index) {
    openFaq = openFaq == index ? null : index;
    notifyListeners();
  }

  void setInquiryType(String? value) {
    selectedType = value;
    notifyListeners();
  }

  void setSubject(String? value) {
    selectedSubject = value;
    notifyListeners();
  }

  Future<void> sendMessage() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final subject = selectedSubject ?? '';
    final type = selectedType ?? '';
    final message = messageController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        subject.isEmpty ||
        type.isEmpty ||
        message.isEmpty) {
      AppSnackBar.show(message: 'Please fill in every field', isError: true);
      return;
    }

    _isSending = true;
    notifyListeners();
    try {
      final result = await _repo.submitContact(
        name: name,
        email: email,
        phone: phone,
        subject: subject,
        type: type,
        message: message,
      );
      if (result is DataSuccess) {
        final response = result.data;
        final successMessage = response is Map
            ? response['message']?.toString()
            : null;
        AppSnackBar.show(
          message: (successMessage == null || successMessage.isEmpty)
              ? 'Message sent successfully'
              : successMessage,
        );
        messageController.clear();
        selectedSubject = null;
        selectedType = null;
      } else if (result is DataFailed) {
        AppSnackBar.show(
          message: result.error ?? 'Unable to send message',
          isError: true,
        );
      }
    } catch (_) {
      AppSnackBar.show(
        message: 'Something went wrong. Please try again.',
        isError: true,
      );
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  void onLogout() {
    SharedPrefHelper.clear();
    RoutingHelper.pushAndRemoveUntilToScreen(screen: const OnboardingView());
  }

  String _formatInr(num val) {
    if (val >= 10000000) {
      return '₹${(val / 10000000).toStringAsFixed(1)}Cr';
    }
    if (val >= 100000) {
      return '₹${(val / 100000).toStringAsFixed(1)}L';
    }
    final rounded = val.round();
    final formatted = rounded.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
    return '₹$formatted';
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    messageController.dispose();
    super.dispose();
  }
}
