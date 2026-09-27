import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../core/helper/app_helper.dart';
import '../../core/constants/app_constants.dart';
import '../../core/helper/routing_helper.dart';
import '../../core/models/base_view_model.dart';
import '../../core/models/kyc_review_model.dart';
import '../../core/di/injector.dart';
import '../../core/repository/app_repository.dart';
import '../../core/utils/data_state.dart';
import '../review_investment/review_investment_view.dart';

class KYCViewModel extends BaseViewModel {
  final String propertyId;
  final int shares;
  final String referralCode;
  final AppRepository _repo = injector<AppRepository>();

  KYCViewModel(
    this.propertyId, {
    this.shares = 1,
    this.referralCode = '',
  });

  int _currentStep = 1;
  int get currentStep => _currentStep;

  KycReviewData? _reviewData;
  KycReviewData? get reviewData => _reviewData;
  bool _reviewAccepted = false;
  bool get reviewAccepted => _reviewAccepted;
  bool _isLoadingReview = false;
  bool get isLoadingReview => _isLoadingReview;
  bool _isSubmittingKyc = false;
  bool get isSubmittingKyc => _isSubmittingKyc;
  String? reviewError;

  // Step 1 — Personal
  final fullNameCtrl = TextEditingController();
  final dobCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  bool _isSubmittingBasic = false;
  bool get isSubmittingBasic => _isSubmittingBasic;
  String? _basicErrorMessage;
  String? get basicErrorMessage => _basicErrorMessage;

  String? fullNameError;
  String? dobError;
  String? emailError;
  String? addressError;

  bool emailVerified = true;

  void setDob(DateTime date) {
    dobCtrl.text =
        '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
    dobError = null;
    notifyListeners();
  }

  // Step 2 — PAN
  final panNumberCtrl = TextEditingController();
  String? panError;
  File? panDocument;
  bool panVerified = false;

  // Retained for the unused legacy identity widget below.
  bool? frontSideUploaded;
  bool? backSideUploaded;
  bool? addressProofUploaded;

  // Step 3 — Aadhaar
  final aadhaarNumberCtrl = TextEditingController();
  String? aadhaarError;
  File? aadhaarDocument;
  bool _isSubmittingAadhaar = false;
  bool get isSubmittingAadhaar => _isSubmittingAadhaar;
  String? _aadhaarSubmitError;
  String? get aadhaarSubmitError => _aadhaarSubmitError;

  // Step 4 — Nominee
  final nomineeNameCtrl = TextEditingController();
  final nomineePanCtrl = TextEditingController();
  final nomineeAadhaarCtrl = TextEditingController();
  final nomineeDobCtrl = TextEditingController();
  String? nomineeNameError;
  String? nomineePanError;
  String? nomineeAadhaarError;
  String? nomineeDobError;
  bool _isSubmittingNominee = false;
  bool get isSubmittingNominee => _isSubmittingNominee;
  String? _nomineeSubmitError;
  String? get nomineeSubmitError => _nomineeSubmitError;

  // Step 5 — Bank
  final beneficiaryNameCtrl = TextEditingController();
  final accountNumberCtrl = TextEditingController();
  final ifscCodeCtrl = TextEditingController();
  final branchCtrl = TextEditingController();
  File? cancelledChequeDocument;
  String? bankError;
  bool _isSubmittingBank = false;
  bool get isSubmittingBank => _isSubmittingBank;
  String? _bankSubmitError;
  String? get bankSubmitError => _bankSubmitError;

  void setCurrentStep(int step) {
    if (step < 1 || step > 6) return;
    _currentStep = step;
    notifyListeners();
  }

  void goBack() {
    if (_currentStep > 1) {
      _currentStep -= 1;
      notifyListeners();
    } else {
      Navigator.of(AppConstants.globalNavKey.currentContext!).pop();
    }
  }

  bool _validatePersonal() {
    fullNameError = fullNameCtrl.text.trim().isEmpty
        ? 'Full name is required'
        : null;
    dobError = _isValidDob(dobCtrl.text.trim())
        ? null
        : 'Select a valid date of birth';
    emailError = _isValidEmail(emailCtrl.text.trim())
        ? null
        : 'Enter a valid email address';
    addressError = addressCtrl.text.trim().isEmpty
        ? 'Address is required'
        : null;
    notifyListeners();
    return fullNameError == null &&
        dobError == null &&
        emailError == null &&
        addressError == null;
  }

  bool _isValidEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
  }

  bool _isValidDob(String value) {
    final parts = value.split('/');
    if (parts.length != 3 || parts[2].length != 4) return false;
    final date = DateTime.tryParse(_apiDate(value));
    if (date == null || date.isAfter(DateTime.now())) return false;
    return date.year.toString() == parts[2] &&
        date.month == int.tryParse(parts[0]) &&
        date.day == int.tryParse(parts[1]);
  }

  void clearPersonalError(String field) {
    switch (field) {
      case 'fullName':
        fullNameError = null;
      case 'dob':
        dobError = null;
      case 'email':
        emailError = null;
      case 'address':
        addressError = null;
    }
    if (_basicErrorMessage != null) _basicErrorMessage = null;
    notifyListeners();
  }

  bool _validatePan() {
    final value = panNumberCtrl.text.trim().toUpperCase();
    panError = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(value)
        ? null
        : 'Enter a valid 10-character PAN number';
    notifyListeners();
    return panError == null && panDocument != null;
  }

  bool _validateAadhaar() {
    final value = aadhaarNumberCtrl.text.trim();
    aadhaarError = RegExp(r'^\d{12}$').hasMatch(value)
        ? null
        : 'Enter a valid 12-digit Aadhaar number';
    notifyListeners();
    return aadhaarError == null && aadhaarDocument != null;
  }

  bool _validateBank() {
    bankError = beneficiaryNameCtrl.text.trim().isEmpty
        ? 'Beneficiary name is required'
        : accountNumberCtrl.text.trim().isEmpty
        ? 'Account number is required'
        : ifscCodeCtrl.text.trim().isEmpty
        ? 'IFSC code is required'
        : branchCtrl.text.trim().isEmpty
        ? 'Branch is required'
        : cancelledChequeDocument == null
        ? 'Cancelled cheque photo is required'
        : null;
    notifyListeners();
    return bankError == null;
  }

  bool _validateNominee() {
    nomineeNameError = nomineeNameCtrl.text.trim().isEmpty
        ? 'Nominee name is required'
        : null;
    nomineePanError =
        RegExp(
          r'^[A-Z]{5}[0-9]{4}[A-Z]$',
        ).hasMatch(nomineePanCtrl.text.trim().toUpperCase())
        ? null
        : 'Enter a valid 10-character PAN number';
    nomineeAadhaarError =
        RegExp(r'^\d{12}$').hasMatch(nomineeAadhaarCtrl.text.trim())
        ? null
        : 'Enter a valid 12-digit Aadhaar number';
    nomineeDobError = _isValidDob(nomineeDobCtrl.text.trim())
        ? null
        : 'Select a valid date of birth';
    notifyListeners();
    return nomineeNameError == null &&
        nomineePanError == null &&
        nomineeAadhaarError == null &&
        nomineeDobError == null;
  }

  Future<void> continueToIdentity() async {
    if (!_validatePersonal() || _isSubmittingBasic) return;

    _isSubmittingBasic = true;
    _basicErrorMessage = null;
    notifyListeners();

    try {
      final result = await _repo.submitKycBasic(
        fullName: fullNameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        dob: _apiDate(dobCtrl.text.trim()),
        address: addressCtrl.text.trim(),
      );
      if (result is DataSuccess) {
        _currentStep = 2;
      } else if (result is DataFailed) {
        _basicErrorMessage = result.error ?? 'Failed to save personal details';
      }
    } catch (e) {
      _basicErrorMessage = 'Something went wrong. Please try again.';
    } finally {
      _isSubmittingBasic = false;
      notifyListeners();
    }
  }

  String _apiDate(String value) {
    final parts = value.split('/');
    if (parts.length == 3 && parts[2].length == 4) {
      return '${parts[2]}-${parts[0].padLeft(2, '0')}-${parts[1].padLeft(2, '0')}';
    }
    return value;
  }

  Future<void> continueToPan() async {
    if (!_validatePan() || panDocument == null) return;

    final result = await _repo.submitKycPan(
      panNumber: panNumberCtrl.text.trim().toUpperCase(),
      document: panDocument!,
    );
    if (result is DataSuccess) {
      panVerified = true;
      _currentStep = 3;
      notifyListeners();
    }
  }

  Future<void> continueToAadhaar() async {
    if (!_validateAadhaar() ||
        aadhaarDocument == null ||
        _isSubmittingAadhaar) {
      return;
    }

    _isSubmittingAadhaar = true;
    _aadhaarSubmitError = null;
    notifyListeners();

    try {
      final result = await _repo.submitKycAadhaar(
        aadhaarNumber: aadhaarNumberCtrl.text.trim(),
        document: aadhaarDocument!,
      );
      if (result is DataSuccess) {
        _currentStep = 4;
      } else if (result is DataFailed) {
        _aadhaarSubmitError =
            result.error ?? 'Failed to submit Aadhaar verification';
      }
    } catch (e) {
      _aadhaarSubmitError = 'Something went wrong. Please try again.';
    } finally {
      _isSubmittingAadhaar = false;
      notifyListeners();
    }
  }

  void setNomineeDob(DateTime date) {
    nomineeDobCtrl.text =
        '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
    nomineeDobError = null;
    notifyListeners();
  }

  void clearNomineeError(String field) {
    switch (field) {
      case 'name':
        nomineeNameError = null;
      case 'pan':
        nomineePanError = null;
      case 'aadhaar':
        nomineeAadhaarError = null;
      case 'dob':
        nomineeDobError = null;
    }
    _nomineeSubmitError = null;
    notifyListeners();
  }

  Future<void> continueToNominee() async {
    if (!_validateNominee() || _isSubmittingNominee) return;

    _isSubmittingNominee = true;
    _nomineeSubmitError = null;
    notifyListeners();

    try {
      final result = await _repo.submitKycNominee(
        name: nomineeNameCtrl.text.trim(),
        panNumber: nomineePanCtrl.text.trim().toUpperCase(),
        aadhaarNumber: nomineeAadhaarCtrl.text.trim(),
        dob: _apiDate(nomineeDobCtrl.text.trim()),
      );
      if (result is DataSuccess) {
        _currentStep = 5;
      } else if (result is DataFailed) {
        _nomineeSubmitError = result.error ?? 'Failed to save nominee details';
      }
    } catch (e) {
      _nomineeSubmitError = 'Something went wrong. Please try again.';
    } finally {
      _isSubmittingNominee = false;
      notifyListeners();
    }
  }

  Future<void> submitKyc() async {
    if (!_validateBank() || _isSubmittingBank) return;

    _isSubmittingBank = true;
    _bankSubmitError = null;
    notifyListeners();

    try {
      final result = await _repo.submitKycBank(
        beneficiaryName: beneficiaryNameCtrl.text.trim(),
        accountNumber: accountNumberCtrl.text.trim(),
        ifsc: ifscCodeCtrl.text.trim().toUpperCase(),
        branch: branchCtrl.text.trim(),
        document: cancelledChequeDocument!,
      );
      if (result is DataSuccess) {
        await loadReview();
        _currentStep = 6;
        notifyListeners();
      } else if (result is DataFailed) {
        _bankSubmitError = result.error ?? 'Failed to save bank details';
      }
    } catch (e) {
      _bankSubmitError = 'Something went wrong. Please try again.';
    } finally {
      _isSubmittingBank = false;
      notifyListeners();
    }
  }

  Future<void> loadReview() async {
    _isLoadingReview = true;
    reviewError = null;
    notifyListeners();
    try {
      final result = await _repo.kyc();
      if (result is DataSuccess) {
        _reviewData = KycReviewData.fromJson(
          Map<String, dynamic>.from(result.data as Map),
        );
      } else if (result is DataFailed) {
        reviewError = result.error ?? 'Failed to load KYC details';
      }
    } catch (_) {
      reviewError = 'Something went wrong. Please try again.';
    } finally {
      _isLoadingReview = false;
      notifyListeners();
    }
  }

  void toggleReviewAccepted() {
    _reviewAccepted = !_reviewAccepted;
    notifyListeners();
  }

  Future<void> confirmKyc() async {
    if (!_reviewAccepted || _isSubmittingKyc) return;
    _isSubmittingKyc = true;
    reviewError = null;
    notifyListeners();
    try {
      final result = await _repo.submitKyc();
      if (result is DataSuccess) {
        RoutingHelper.pushToScreen(
          screen: ReviewInvestmentView(
            propertyId: propertyId,
            shares: shares,
            referralCode: referralCode,
          ),
        );
      } else if (result is DataFailed) {
        reviewError = result.error ?? 'Failed to submit KYC';
      }
    } catch (_) {
      reviewError = 'Something went wrong. Please try again.';
    } finally {
      _isSubmittingKyc = false;
      notifyListeners();
    }
  }

  Future<void> pickCancelledCheque() async {
    final file = await AppHelper.getImage(ImageSource.gallery);
    if (file != null) {
      cancelledChequeDocument = file;
      notifyListeners();
    }
  }

  Future<void> pickPanDocument() async {
    final file = await AppHelper.getImage(ImageSource.gallery);
    if (file != null) {
      panDocument = file;
      notifyListeners();
    }
  }

  Future<void> pickAadhaarDocument() async {
    final file = await AppHelper.getImage(ImageSource.gallery);
    if (file != null) {
      aadhaarDocument = file;
      notifyListeners();
    }
  }

  void toggleFrontUploaded() {
    frontSideUploaded = true;
    notifyListeners();
  }

  void toggleBackUploaded() {
    backSideUploaded = true;
    notifyListeners();
  }

  void toggleAddressProofUploaded() {
    addressProofUploaded = true;
    notifyListeners();
  }

  void clearPanError() {
    panError = null;
    notifyListeners();
  }

  void clearAadhaarError() {
    aadhaarError = null;
    notifyListeners();
  }

  void doLater() {}

  @override
  void dispose() {
    fullNameCtrl.dispose();
    dobCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    panNumberCtrl.dispose();
    aadhaarNumberCtrl.dispose();
    nomineeNameCtrl.dispose();
    nomineePanCtrl.dispose();
    nomineeAadhaarCtrl.dispose();
    nomineeDobCtrl.dispose();
    beneficiaryNameCtrl.dispose();
    accountNumberCtrl.dispose();
    ifscCodeCtrl.dispose();
    branchCtrl.dispose();
    super.dispose();
  }
}
