typedef ApiErrorMessageListener = void Function(String? message);

ApiErrorMessageListener? onApiErrorMessage;

void notifyApiErrorMessage(String? message) {
  onApiErrorMessage?.call(message);
}
