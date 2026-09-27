import '../../presentations/complete_payment/complete_payment_view.dart';
import '../../presentations/kyc/kyc_view.dart';
import '../../presentations/review_investment/review_investment_view.dart';
import '../../presentations/widgets/custom_widgets/custom_snackbar.dart';
import '../di/injector.dart';
import '../models/created_investment_model.dart';
import '../models/kyc_review_model.dart';
import '../repository/app_repository.dart';
import '../utils/data_state.dart';
import 'routing_helper.dart';

class InvestmentPaymentFlow {
  static Future<void> onProceedToPayment({
    required String propertyId,
    required int shares,
    String referralCode = '',
  }) async {
    try {
      final repo = injector<AppRepository>();
      final result = await repo.kyc();

      if (result is DataSuccess) {
        if (hasKycDetails(result.data)) {
          RoutingHelper.pushToScreen(
            screen: ReviewInvestmentView(
              propertyId: propertyId,
              shares: shares,
              referralCode: referralCode,
            ),
          );
          return;
        }
        RoutingHelper.pushToScreen(
          screen: KYCView(
            propertyId: propertyId,
            shares: shares,
            referralCode: referralCode,
          ),
        );
        return;
      }

      if (result is DataFailed && _looksLikeMissingKyc(result)) {
        RoutingHelper.pushToScreen(
          screen: KYCView(
            propertyId: propertyId,
            shares: shares,
            referralCode: referralCode,
          ),
        );
        return;
      }

      AppSnackBar.show(
        message: result is DataFailed
            ? (result.error ?? 'Failed to load KYC details')
            : 'Failed to load KYC details',
        isError: true,
      );
    } catch (_) {
      AppSnackBar.show(
        message: 'Failed to load KYC details',
        isError: true,
      );
    }
  }

  static Future<void> createInvestmentAndOpenPayment({
    required String propertyId,
    required int shares,
    String referralCode = '',
  }) async {
    try {
      final repo = injector<AppRepository>();
      final result = await repo.createInvestment(
        propertyId: propertyId,
        shares: shares,
        referralCode: referralCode,
      );

      if (result is DataSuccess) {
        final data = result.data;
        if (data is Map) {
          final investment = CreatedInvestment.fromJson(
            Map<String, dynamic>.from(data),
          );
          if (investment.id.isEmpty) {
            AppSnackBar.show(
              message: 'Investment created, but payment details are missing',
              isError: true,
            );
            return;
          }
          RoutingHelper.pushToScreen(
            screen: CompletePaymentView(investment: investment),
            fullscreenDialog: true,
          );
          return;
        }
        AppSnackBar.show(
          message: 'Unexpected investment response',
          isError: true,
        );
        return;
      }

      AppSnackBar.show(
        message: result is DataFailed
            ? (result.error ?? 'Failed to create investment')
            : 'Failed to create investment',
        isError: true,
      );
    } catch (_) {
      AppSnackBar.show(
        message: 'Failed to create investment',
        isError: true,
      );
    }
  }

  static bool hasKycDetails(dynamic data) {
    if (data == null) return false;
    if (data is! Map) return false;

    final map = Map<String, dynamic>.from(data);
    if (map.containsKey('data') && map['data'] == null) return false;
    if (map.containsKey('kyc') && map['kyc'] == null) return false;

    final parsed = KycReviewData.fromJson(map);
    return parsed.personal.fullName.trim().isNotEmpty ||
        parsed.pan.number.trim().isNotEmpty ||
        parsed.aadhaar.number.trim().isNotEmpty ||
        parsed.bank.accountNumber.trim().isNotEmpty;
  }

  static bool _looksLikeMissingKyc(DataFailed result) {
    final message = (result.error ?? '').toLowerCase();
    return result.errorCode == 404 ||
        message.contains('not found') ||
        message.contains('no kyc') ||
        message.contains('kyc not');
  }
}
