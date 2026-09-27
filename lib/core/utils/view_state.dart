import '../enums/response_state_enum.dart';

class ViewState<T> {
  ResponseState state;
  T? data;
  String? exception;

  ViewState({required this.state, this.data, this.exception});

  static ViewState<T> empty<T>() {
    return ViewState(state: ResponseState.empty);
  }

  static ViewState<T> loading<T>() {
    return ViewState(state: ResponseState.loading);
  }

  static ViewState<T> complete<T>(T data) {
    return ViewState(state: ResponseState.complete, data: data);
  }

  static ViewState<T> error<T>(String exception) {
    return ViewState(state: ResponseState.error, exception: exception);
  }
}
