class ApiUrlsConstant {
  // static String baseUrl = 'https://property-invest-platform.onrender.com/api/';
  static String baseUrl = 'https://api.pronexworld.com/api/';
  static String sendOtp = 'auth/send-otp';
  static String verifyOtp = 'auth/verify-otp';
  static String resendOtp = 'auth/resend-otp';
  static String kycBasic = 'kyc/basic';
  static String kycPan = 'kyc/pan';
  static String kycAadhaar = 'kyc/aadhaar';
  static String kycNominee = 'kyc/nominee';
  static String kycBank = 'kyc/bank';
  static String kyc = 'kyc';
  static String submitKyc = 'kyc/submit';
  static String properties = 'properties';
  static String propertiesExplore = 'properties/explore';
  static String portfolio = 'portfolio';
  static String portfolioExit = 'portfolio/exit';
  static String ownershipRequest = 'ownership/request';
  static String portfolioDocuments = 'portfolio/documents';
  static String profile = 'profile';
  static String contact = 'contact';
  static String userReferral = 'user/referral';
  static String userReferralRewards = 'user/referral/rewards';
  static String propertyDetail(String id) => 'properties/$id';
  static String relatedProperties(String id) => 'properties/related/$id';
  static String watchlist = 'user/watchlist';
  static String watchlistToggle(String propertyId) =>
      'user/watchlist/toggle/$propertyId';
  static String createInvestment = 'investments/create';
    static String validateReferral = 'investments/validate-referral';
  static String paymentSettings = 'investments/payment-settings';
  static String paymentProof(String investmentId) =>
      'investments/$investmentId/payment-proof';
}
