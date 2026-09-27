import '../constants/app_error_constants.dart';
import '../utils/data_state.dart';
import 'api_paywall_bridge.dart';

class ApiResponseHelper {
  static bool isEntryPlanRequired(String? message) =>
      message == AppErrorConstants.entryPlanRequired;

  static void handleEntryPlanError(String? message) {
    if (isEntryPlanRequired(message)) {
      notifyApiErrorMessage(message);
    }
  }

  static void handleDataState(dynamic result) {
    if (result is DataFailed) {
      handleEntryPlanError(result.error);
    }
  }

  static String errorMessage(dynamic result, {String fallback = 'Something went wrong'}) {
    if (result is DataFailed) {
      return result.error ?? fallback;
    }
    return fallback;
  }
}
