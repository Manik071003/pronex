import 'dart:io';

import '../di/injector.dart';
import '../services/remote/network/api_impl.dart';

class AppRepository {
  final ApiImpl _apiImpl = injector<ApiImpl>();

  Future<dynamic> sendOtp({required String email, required String name}) =>
      _apiImpl.sendOtp(email: email, name: name);

  Future<dynamic> loginOtp({required String email}) =>
      _apiImpl.loginOtp(email: email);

  Future<dynamic> verifyOtp({required String email, required String otp}) =>
      _apiImpl.verifyOtp(email: email, otp: otp);

  Future<dynamic> resendOtp({required String email}) =>
      _apiImpl.resendOtp(email: email);

  Future<dynamic> submitKycBasic({
    required String fullName,
    required String email,
    required String dob,
    required String address,
  }) => _apiImpl.submitKycBasic(
    fullName: fullName,
    email: email,
    dob: dob,
    address: address,
  );

  Future<dynamic> submitKycPan({
    required String panNumber,
    required File document,
  }) => _apiImpl.submitKycPan(panNumber: panNumber, document: document);

  Future<dynamic> submitKycAadhaar({
    required String aadhaarNumber,
    required File document,
  }) => _apiImpl.submitKycAadhaar(
    aadhaarNumber: aadhaarNumber,
    document: document,
  );

  Future<dynamic> submitKycNominee({
    required String name,
    required String panNumber,
    required String aadhaarNumber,
    required String dob,
  }) => _apiImpl.submitKycNominee(
    name: name,
    panNumber: panNumber,
    aadhaarNumber: aadhaarNumber,
    dob: dob,
  );

  Future<dynamic> submitKycBank({
    required String beneficiaryName,
    required String accountNumber,
    required String ifsc,
    required String branch,
    required File document,
  }) => _apiImpl.submitKycBank(
    beneficiaryName: beneficiaryName,
    accountNumber: accountNumber,
    ifsc: ifsc,
    branch: branch,
    document: document,
  );

  Future<dynamic> kyc() => _apiImpl.kyc();
  Future<dynamic> submitKyc() => _apiImpl.submitKyc();

  Future<dynamic> properties() => _apiImpl.properties();

  Future<dynamic> exploreProperties({
    String? search,
    String? city,
    String? type,
    int? maxPrice,
    String? status,
    String sort = 'newest',
    int page = 1,
    int limit = 50,
  }) => _apiImpl.exploreProperties(
    search: search,
    city: city,
    type: type,
    maxPrice: maxPrice,
    status: status,
    sort: sort,
    page: page,
    limit: limit,
  );

  Future<dynamic> propertyDetail(String id) => _apiImpl.propertyDetail(id);

  Future<dynamic> relatedProperties(String id) => _apiImpl.relatedProperties(id);

  Future<dynamic> watchlist() => _apiImpl.watchlist();

  Future<dynamic> watchlistToggle(String propertyId) =>
      _apiImpl.watchlistToggle(propertyId);

  Future<dynamic> portfolio() => _apiImpl.portfolio();

  Future<dynamic> requestOwnership({required String investmentId}) =>
      _apiImpl.requestOwnership(investmentId: investmentId);

  Future<dynamic> requestPortfolioExit({
    required String investmentId,
    required int shares,
    String reason = '',
  }) => _apiImpl.requestPortfolioExit(
    investmentId: investmentId,
    shares: shares,
    reason: reason,
  );

  Future<dynamic> portfolioDocuments() => _apiImpl.portfolioDocuments();
  Future<dynamic> profile() => _apiImpl.profile();

  Future<dynamic> submitContact({
    required String name,
    required String email,
    required String phone,
    required String subject,
    required String type,
    required String message,
  }) => _apiImpl.submitContact(
    name: name,
    email: email,
    phone: phone,
    subject: subject,
    type: type,
    message: message,
  );
  Future<dynamic> referral() => _apiImpl.referral();
  Future<dynamic> referralRewards() => _apiImpl.referralRewards();

  Future<dynamic> createInvestment({
    required String propertyId,
    required int shares,
    String referralCode = '',
  }) => _apiImpl.createInvestment(
    propertyId: propertyId,
    shares: shares,
    referralCode: referralCode,
  );

  Future<dynamic> validateReferral({required String referralCode}) =>
      _apiImpl.validateReferral(referralCode: referralCode);

  Future<dynamic> paymentSettings() => _apiImpl.paymentSettings();

  Future<dynamic> submitPaymentProof({
    required String investmentId,
    required String paymentReference,
    required String paymentMethod,
    required File document,
  }) => _apiImpl.submitPaymentProof(
    investmentId: investmentId,
    paymentReference: paymentReference,
    paymentMethod: paymentMethod,
    document: document,
  );
}
