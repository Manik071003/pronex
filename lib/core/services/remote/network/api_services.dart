import 'dart:io';

abstract class ApiServices {
  Future<dynamic> sendOtp({required String email, required String name});
  Future<dynamic> verifyOtp({required String email, required String otp});
  Future<dynamic> resendOtp({required String email});
  Future<dynamic> submitKycBasic({
    required String fullName,
    required String email,
    required String dob,
    required String address,
  });
  Future<dynamic> submitKycPan({
    required String panNumber,
    required File document,
  });
  Future<dynamic> submitKycAadhaar({
    required String aadhaarNumber,
    required File document,
  });
  Future<dynamic> submitKycNominee({
    required String name,
    required String panNumber,
    required String aadhaarNumber,
    required String dob,
  });
  Future<dynamic> submitKycBank({
    required String beneficiaryName,
    required String accountNumber,
    required String ifsc,
    required String branch,
    required File document,
  });
  Future<dynamic> kyc();
  Future<dynamic> submitKyc();
  Future<dynamic> properties();
  Future<dynamic> exploreProperties({
    String? search,
    String? city,
    String? type,
    int? maxPrice,
    String? status,
    String sort = 'newest',
    int page = 1,
    int limit = 50,
  });
  Future<dynamic> propertyDetail(String id);
  Future<dynamic> relatedProperties(String id);
  Future<dynamic> watchlist();
  Future<dynamic> watchlistToggle(String propertyId);
  Future<dynamic> portfolio();
  Future<dynamic> requestOwnership({required String investmentId});
  Future<dynamic> requestPortfolioExit({
    required String investmentId,
    required int shares,
    String reason = '',
  });
  Future<dynamic> portfolioDocuments();
  Future<dynamic> profile();
  Future<dynamic> submitContact({
    required String name,
    required String email,
    required String phone,
    required String subject,
    required String type,
    required String message,
  });
  Future<dynamic> referral();
  Future<dynamic> referralRewards();
  Future<dynamic> loginOtp({required String email});
  Future<dynamic> createInvestment({
    required String propertyId,
    required int shares,
    String referralCode = '',
  });
  Future<dynamic> validateReferral({required String referralCode});
  Future<dynamic> paymentSettings();
  Future<dynamic> submitPaymentProof({
    required String investmentId,
    required String paymentReference,
    required String paymentMethod,
    required File document,
  });
}
