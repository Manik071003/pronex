import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class RoutingHelper {


  static void buildAndShowModalBottomSheetFor({
    bool isScrollControlled = true,
    required Widget widget,
  }) {
    showModalBottomSheet(
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.white,
      context: AppConstants.globalNavKey.currentContext!,
      builder: (_) {
        return widget;
      },
    );
  }

  static void pushAndRemoveUntilToScreen({required Widget screen}) {
    final route = MaterialPageRoute(builder: (ctx) => screen);
    Navigator.pushAndRemoveUntil(
      AppConstants.globalNavKey.currentContext!,
      route,
      (route) => false,
    );
  }


  static Future<void> pushToScreen({
    bool fullscreenDialog = false,
    required Widget screen,
    Function()? onReturn,
  }) async {
    final route = MaterialPageRoute(
      builder: (ctx) => screen,
      fullscreenDialog: fullscreenDialog,
    );

    await Navigator.push(
      AppConstants.globalNavKey.currentContext!,
      route,
    );

    if (onReturn != null) {
      onReturn();
    }
  }

  static Future<T?> pushToScreenForResult<T>({
    bool fullscreenDialog = false,
    required Widget screen,
  }) {
    final route = MaterialPageRoute<T>(
      builder: (ctx) => screen,
      fullscreenDialog: fullscreenDialog,
    );
    return Navigator.push<T>(
      AppConstants.globalNavKey.currentContext!,
      route,
    );
  }






  static Future<void> pushReplacementToScreen({
    bool fullscreenDialog = false,
    required Widget screen,
  }) async {
    final route = MaterialPageRoute(
      builder: (_) => screen,
      fullscreenDialog: fullscreenDialog,
    );

    await AppConstants.globalNavKey.currentState!.pushReplacement(route);
  }




}
