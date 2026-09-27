import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/api_url_constants.dart';
import '../../../constants/shared_prefs_constants.dart';
import '../../../helper/app_logger.dart';
import '../../../helper/network_exception.dart';
import '../../../utils/data_state.dart';
import 'api_services.dart';

class ApiImpl extends ApiServices {
  bool _isRefreshing = false;
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiUrlsConstant.baseUrl,
      headers: <String, String>{'Content-type': 'application/json'},
      receiveDataWhenStatusError: true,
      validateStatus: (status) {
        if (status == null) return false;
        return status <= 800;
      },
    ),
  );

  ApiImpl() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.path.contains("auth/send-otp") ||
              options.path.contains("auth/verify-otp") ||
              options.path.contains("auth/resend-otp") ||
              options.path.contains("auth/refresh-token")) {
            return handler.next(options);
          }
          AppLogger.log("message");
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString(SharedPrefs.token);
          // final token =
          //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhNzA2MzJhNjMwMGQ5ZTQyODJlYzVmZiIsInJvbGUiOiJpbnZlc3RvciIsImlhdCI6MTc4NzU2NTE4MSwiZXhwIjoxNzg4MTY5OTgxfQ.llWRkqTBwMCnTR-ZjGySi1071vxyZQlBfXwJXKU0Mzo";

          AppLogger.log("TokenK: $token");

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onResponse: (response, handler) async {
          if (response.statusCode == 403 && !_isRefreshing) {
            AppLogger.log("Handling 403 in onResponse: ${response.data}");
            _isRefreshing = true;
          }

          handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          AppLogger.log("onError called: ${error.response?.statusCode}");
          AppLogger.log("onError data: ${error.response?.data}");

          if (error.response?.statusCode == 403 && !_isRefreshing) {
            _isRefreshing = true;
          }

          return handler.next(error);
        },
      ),
    );
  }

  final Dio _refreshDio = Dio(
    BaseOptions(
      baseUrl: ApiUrlsConstant.baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  @override
  Future<dynamic> sendOtp({required String email, required String name}) async {
    var data = jsonEncode({"email": email, "name": name,"mode":"signup",  "role": "investor"});
    try {
      String url = ApiUrlsConstant.sendOtp;
      AppLogger.log("POST: $url\n$data");
      Response response = await _dio.post(url, data: data);
      AppLogger.log("RESPONSE: $url\n$response");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      } else {
        return DataFailed(
          error: response.data?['message'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      print("error");
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> loginOtp({required String email}) async {
    var data = jsonEncode({"email": email,"mode":"login", "role": "investor"});
    try {
      String url = ApiUrlsConstant.sendOtp;
      AppLogger.log("POST: $url\n$data");
      Response response = await _dio.post(url, data: data);
      AppLogger.log("RESPONSE: $url\n$response");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      } else {
        return DataFailed(
          error: response.data?['message'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      print("error");
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final url = ApiUrlsConstant.verifyOtp;
      final response = await _dio.post(
        url,
        data: jsonEncode({'email': email, 'otp': otp, 'role': 'investor'}),
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      }
      return DataFailed(
        error: response.data?['message'] ?? 'Something went wrong',
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> resendOtp({required String email}) async {
    try {
      final url = ApiUrlsConstant.resendOtp;
      final response = await _dio.post(url, data: jsonEncode({'email': email}));
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      }
      return DataFailed(
        error: response.data?['message'] ?? 'Something went wrong',
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> submitKycBasic({
    required String fullName,
    required String email,
    required String dob,
    required String address,
  }) async {
    try {
      final url = ApiUrlsConstant.kycBasic;
      final response = await _dio.post(
        url,
        data: jsonEncode({
          'fullName': fullName,
          'email': email,
          'dob': dob,
          'address': address,
        }),
      );
      AppLogger.log("RESPONSCE: $url\n$response");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      }
      return DataFailed(
        error: response.data?['message'] ?? 'Something went wrong',
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> submitKycPan({
    required String panNumber,
    required File document,
  }) async {
    try {
      final url = ApiUrlsConstant.kycPan;
      final response = await _dio.post(
        url,
        data: FormData.fromMap({
          'panNumber': panNumber,
          'document': await MultipartFile.fromFile(document.path),
        }),
        options: Options(contentType: 'multipart/form-data'),
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      }
      return DataFailed(
        error: response.data?['message'] ?? 'Something went wrong',
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> submitKycAadhaar({
    required String aadhaarNumber,
    required File document,
  }) async {
    try {
      final url = ApiUrlsConstant.kycAadhaar;
      final response = await _dio.post(
        url,
        data: FormData.fromMap({
          'aadhaarNumber': aadhaarNumber,
          'document': await MultipartFile.fromFile(document.path),
        }),
        options: Options(contentType: 'multipart/form-data'),
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      }
      return DataFailed(
        error: response.data?['message'] ?? 'Something went wrong',
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> submitKycNominee({
    required String name,
    required String panNumber,
    required String aadhaarNumber,
    required String dob,
  }) async {
    try {
      final url = ApiUrlsConstant.kycNominee;
      final response = await _dio.post(
        url,
        data: jsonEncode({
          'name': name,
          'panNumber': panNumber,
          'aadhaarNumber': aadhaarNumber,
          'dob': dob,
        }),
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      }
      return DataFailed(
        error: response.data?['message'] ?? 'Something went wrong',
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> submitKycBank({
    required String beneficiaryName,
    required String accountNumber,
    required String ifsc,
    required String branch,
    required File document,
  }) async {
    try {
      final url = ApiUrlsConstant.kycBank;
      final response = await _dio.post(
        url,
        data: FormData.fromMap({
          'beneficiaryName': beneficiaryName,
          'accountNumber': accountNumber,
          'ifsc': ifsc,
          'branch': branch,
          'document': await MultipartFile.fromFile(document.path),
        }),
        options: Options(contentType: 'multipart/form-data'),
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      }
      return DataFailed(
        error: response.data?['message'] ?? 'Something went wrong',
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> kyc() async {
    try {
      final url = ApiUrlsConstant.kyc;
      final response = await _dio.get(url);
      AppLogger.log("RESPONSCE: $url\n$response");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      }
      return DataFailed(
        error: response.data?['message'] ?? 'Something went wrong',
        errorCode: response.statusCode,
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> submitKyc() async {
    try {
      final url = ApiUrlsConstant.submitKyc;
      final response = await _dio.post(url);
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      }
      return DataFailed(
        error: response.data?['message'] ?? 'Something went wrong',
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> exploreProperties({
    String? search,
    String? city,
    String? type,
    int? maxPrice,
    String? status,
    String sort = 'newest',
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _dio.get(
        ApiUrlsConstant.propertiesExplore,
        queryParameters: {
          'sort': sort,
          'page': page,
          'limit': limit,
          if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
          if (city != null && city.trim().isNotEmpty) 'city': city.trim(),
          if (type != null && type.trim().isNotEmpty) 'type': type.trim(),
          if (maxPrice != null) 'maxPrice': maxPrice,
          if (status != null && status.trim().isNotEmpty) 'status': status.trim(),
        },
      );
      AppLogger.log("RESPONSCE: ${ApiUrlsConstant.propertiesExplore}\n$response");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      }
      return DataFailed(
        error: response.data?['message'] ?? 'Something went wrong',
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> properties() async {
    AppLogger.log("Manik");
    try {
      String url = ApiUrlsConstant.properties;
      Response response = await _dio.get(url);
      AppLogger.log("RESPONSCE: $url\n$response");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      } else {
        return DataFailed(
          error: response.data?['message'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      print("error");
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> propertyDetail(String id) async {
    try {
      String url = ApiUrlsConstant.propertyDetail(id);
      Response response = await _dio.get(url);
      AppLogger.log("RESPONSCE: $url\n$response");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      } else {
        return DataFailed(
          error: response.data?['message'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      print("error");
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> relatedProperties(String id) async {
    try {
      final url = ApiUrlsConstant.relatedProperties(id);
      final response = await _dio.get(url);
      AppLogger.log("RESPONSCE: $url\n$response");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      }
      return DataFailed(
        error: response.data?['message'] ?? 'Something went wrong',
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> watchlist() async {
    try {
      final url = ApiUrlsConstant.watchlist;
      final response = await _dio.get(url);
      AppLogger.log("RESPONSCE: $url\n$response");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      } else {
        return DataFailed(
          error: response.data?['message'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> watchlistToggle(String propertyId) async {
    try {
      final url = ApiUrlsConstant.watchlistToggle(propertyId);
      final response = await _dio.post(url);
      AppLogger.log("RESPONSCE: $url\n$response");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      } else {
        return DataFailed(
          error: response.data?['message'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> portfolio() async {
    try {
      String url = ApiUrlsConstant.portfolio;
      Response response = await _dio.get(url);
      AppLogger.log("RESPONSCE: $url\n$response");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      } else {
        return DataFailed(
          error: response.data?['message'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> referral() async {
    try {
      final url = ApiUrlsConstant.userReferral;
      final response = await _dio.get(url);
      AppLogger.log('RESPONSCE: $url\n$response');
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      }
      return DataFailed(
        error: response.data?['message'] ?? 'Failed to load referral details',
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> referralRewards() async {
    try {
      final url = ApiUrlsConstant.userReferralRewards;
      final response = await _dio.get(url);
      AppLogger.log('RESPONSCE: $url\n$response');
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      }
      return DataFailed(
        error: response.data?['message'] ?? 'Failed to load referral rewards',
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> requestOwnership({required String investmentId}) async {
    try {
      final url = ApiUrlsConstant.ownershipRequest;
      final payload = {'investmentId': investmentId};
      final encodedPayload = jsonEncode(payload);
      AppLogger.log('POST: $url\n$payload');
      final response = await _dio.post(url, data: encodedPayload);
      AppLogger.log('RESPONSCE: $url\n$response');
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      }
      return DataFailed(
        error: response.data?['message'] ?? 'Failed to request ownership',
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> requestPortfolioExit({
    required String investmentId,
    required int shares,
    String reason = '',
  }) async {
    if (shares <= 0 || shares % 10 != 0) {
      return DataFailed(error: 'Exit shares must be a multiple of 10');
    }

    try {
      final url = ApiUrlsConstant.portfolioExit;
      final payload = {
        'investmentId': investmentId,
        'shares': shares,
        'reason': reason,
      };
      AppLogger.log('POST: $url\n$payload');
      final response = await _dio.post(url, data: jsonEncode(payload));
      AppLogger.log('RESPONSCE: $url\n$response');
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      }
      return DataFailed(
        error: response.data?['message'] ?? 'Failed to request exit',
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> portfolioDocuments() async {
    try {
      final url = ApiUrlsConstant.portfolioDocuments;
      final response = await _dio.get(url);
      AppLogger.log("RESPONSCE: $url\n$response");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      } else {
        return DataFailed(
          error: response.data?['message'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> createInvestment({
    required String propertyId,
    required int shares,
    String referralCode = '',
  }) async {
    try {
      final url = ApiUrlsConstant.createInvestment;
      final payload = {
        'propertyId': propertyId,
        'shares': shares,
        'referralCode': referralCode,
      };
      AppLogger.log("POST: $url\n$payload");
      final response = await _dio.post(url, data: jsonEncode(payload));
      AppLogger.log("RESPONSCE: $url\n$response");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      }
      return DataFailed(
        error: response.data?['message'] ?? 'Something went wrong',
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> validateReferral({required String referralCode}) async {
    try {
      final url = ApiUrlsConstant.validateReferral;
      final payload = {'referralCode': referralCode};
      AppLogger.log('POST: $url\n$payload');
      final response = await _dio.post(url, data: jsonEncode(payload));
      AppLogger.log('RESPONSCE: $url\n$response');
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      }
      return DataFailed(
        error: response.data?['message'] ?? 'Invalid referral code',
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> paymentSettings() async {
    try {
      final url = ApiUrlsConstant.paymentSettings;
      final response = await _dio.get(url);
      AppLogger.log("RESPONSCE: $url\n$response");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      }
      return DataFailed(
        error: response.data?['message'] ?? 'Something went wrong',
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> submitPaymentProof({
    required String investmentId,
    required String paymentReference,
    required String paymentMethod,
    required File document,
  }) async {
    try {
      final url = ApiUrlsConstant.paymentProof(investmentId);
      final fileName = document.path.split('/').last;
      final response = await _dio.post(
        url,
        data: FormData.fromMap({
          'paymentReference': paymentReference,
          'paymentMethod': paymentMethod,
          'document': await MultipartFile.fromFile(
            document.path,
            filename: fileName,
          ),
        }),
        options: Options(contentType: 'multipart/form-data'),
      );
      AppLogger.log("RESPONSCE: $url\n$response");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      }
      return DataFailed(
        error: response.data?['message'] ?? 'Something went wrong',
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> submitContact({
    required String name,
    required String email,
    required String phone,
    required String subject,
    required String type,
    required String message,
  }) async {
    try {
      final url = ApiUrlsConstant.contact;
      final payload = {
        'name': name,
        'email': email,
        'phone': phone,
        'subject': subject,
        'type': type,
        'message': message,
      };
      AppLogger.log('POST: $url\n$payload');
      final response = await _dio.post(url, data: jsonEncode(payload));
      AppLogger.log('RESPONSCE: $url\n$response');
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      }
      return DataFailed(
        error: response.data?['message'] ?? 'Something went wrong',
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> profile() async {
    try {
      final url = ApiUrlsConstant.profile;
      final response = await _dio.get(url);
      AppLogger.log("RESPONSCE: $url\n$response");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataSuccess(response.data);
      } else {
        return DataFailed(
          error: response.data?['message'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  dynamic _handleError(Object e) {
    var errorDescription = '';
    if (e is DioException) {
      AppLogger.log(e.type);
      errorDescription = DioExceptions.handleError(e.type);
      final responseMessage = e.response?.data is Map
          ? e.response?.data['message']?.toString()
          : null;
    } else {
      errorDescription = 'Unexpected error occurred';
    }
    return DataFailed(error: errorDescription);
  }
}
