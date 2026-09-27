import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../presentations/widgets/custom_widgets/custom_button.dart';
import '../constants/app_constants.dart';
import '../constants/constant_imports.dart';
import '../constants/icon_constants.dart';
import 'helper_imports.dart';

class AppHelper {
  static void dismissKeyboard() {
    final currentFocus = FocusScope.of(
      AppConstants.globalNavKey.currentContext!,
    );
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  /// parse only set availability time for show on ui
  static String parseTime(String time) {
    try {
      // Parse the input time string
      final inputFormat = DateFormat('HH:mm');
      final dateTime = inputFormat.parse(time);

      // Format the parsed time to 12-hour format with AM/PM
      final outputFormat = DateFormat('hh:mm a');
      return outputFormat.format(dateTime);
    } catch (e) {
      return 'Invalid time format';
    }
  }

  static void dismissSnackBar({required BuildContext ctx}) {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
  }

  static void showSnackBar({
    BuildContext? context,
    required String message,
    TextStyle? style,
    double? height,
  })
  {
    final effectiveContext =
        context ?? AppConstants.globalNavKey.currentState?.context ?? AppConstants.globalNavKey.currentContext;

    if (effectiveContext == null) return;

    final messenger = ScaffoldMessenger.of(effectiveContext);
    messenger.hideCurrentSnackBar();

    if (message.isNotEmpty) {
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: ColorConstants.primaryAppColor,
          content: SizedBox(
            height: height ?? Dimensions.px36,
            child: Text(
              message,
              style: AppTextStyles.regularText(
                fontSize: Dimensions.px12,
                color: ColorConstants.white,
              ),
            ),
          ),
        ),
      );
    }
  }







  static bool isAndroid() {
    return Platform.isAndroid;
  }

  static bool isIOS() {
    return Platform.isIOS;
  }

  static Future<File?> getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) {
        return null;
      }
      var imageTemporary = File(image.path);
      return imageTemporary;
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
      return null;
    }
  }

  static Future<void> showSimpleDialogue<T>({
    bool showOkayButton = false,
    bool showIcon = false,
    bool showNoButton = false,
    String cancelBtnTitle = 'cancel',
    String okBtnTitle = 'Ok',
    String title = 'Alert',
    String message = '',
    TextEditingController? textController,
    final VoidCallback? onTap,
  }) async {
    await showDialog<T>(
      barrierDismissible: false,
      context: AppConstants.globalNavKey.currentContext!,
      builder: (context) {
        return SingleChildScrollView(
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: SizeHelper.getDeviceWidth(context) / Dimensions.px1,
                  decoration: BoxDecoration(
                    color: ColorConstants.white,
                    borderRadius: BorderRadius.circular(Dimensions.px10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.px20,
                      horizontal: Dimensions.px20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: Dimensions.px20),
                        if (showIcon)
                          const Icon(
                            Icons.done,
                            size: Dimensions.px40,
                            color: ColorConstants.radicalRed,
                          ),
                        const SizedBox(height: Dimensions.px10),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.semiBoldText(
                            fontSize: Dimensions.px22,
                          ),
                        ),
                        const SizedBox(height: Dimensions.px10),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.regularText(
                            fontSize: Dimensions.px16,
                          ),
                        ),
                        const SizedBox(height: Dimensions.px15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            if (showNoButton)
                              Expanded(
                                child: CustomButton(
                                  height: Dimensions.px45,
                                  style: AppTextStyles.semiBoldText(
                                    fontSize: Dimensions.px16,
                                    color: ColorConstants.white,
                                  ),
                                  label: cancelBtnTitle,
                                  btnColor: ColorConstants.blue,
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            if (showOkayButton && showNoButton) SizeHelper.w2(),
                            if (showOkayButton)
                              Expanded(
                                child: CustomButton(
                                  height: Dimensions.px45,
                                  style: AppTextStyles.semiBoldText(
                                    fontSize: Dimensions.px16,
                                    color: ColorConstants.white,
                                  ),
                                  label: okBtnTitle,
                                  btnColor: ColorConstants.blue,
                                  onTap: onTap,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: Dimensions.px10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget imageWithLoader({
    required String imageUrl,
    double? height,
    double? width,
    double? radius,
    BoxFit? fit,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? Dimensions.px55),
      child: Image.network(
        imageUrl,
        loadingBuilder:
            (
              BuildContext context,
              Widget child,
              ImageChunkEvent? loadingProgress,
            ) {
              if (loadingProgress == null) {
                return child;
              } else {
                return SizedBox(
                  height: height ?? Dimensions.px75,
                  width: width ?? Dimensions.px75,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  ),
                );
              }
            },
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            IconConstants.profileIconMain,
            width: Dimensions.px75,
            height: Dimensions.px75,
          );
        },
        height: height ?? Dimensions.px75,
        width: width ?? Dimensions.px75,
        fit: fit ?? BoxFit.cover,
      ),
    );
  }

  static imageMemoryWithLoader({
    required Uint8List image,
    double? height,
    double? width,
    double? radius,
    BoxFit? fit,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? Dimensions.px55),
      child: Image.memory(
        image,
        // loadingBuilder: (BuildContext context, Widget child,
        //     ImageChunkEvent? loadingProgress) {
        //   if (loadingProgress == null) {
        //     return child;
        //   } else {
        //     return SizedBox(
        //       height: height ?? Dimensions.px75,
        //       width: width ?? Dimensions.px75,
        //       child: Center(
        //         child: CircularProgressIndicator(
        //           value: loadingProgress.expectedTotalBytes != null
        //               ? loadingProgress.cumulativeBytesLoaded /
        //                   (loadingProgress.expectedTotalBytes ?? 1)
        //               : null,
        //         ),
        //       ),
        //     );
        //   }
        // },
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
        height: height ?? Dimensions.px75,
        width: width ?? Dimensions.px75,
        fit: fit ?? BoxFit.cover,
      ),
    );
  }

  static calculateAge(String? dateOfBirth) {
    if (dateOfBirth != null) {
      DateTime dob = DateTime.parse(dateOfBirth).toLocal();

      DateTime today = DateTime.now();
      int age = today.year - dob.year;

      // Adjust if the birthday hasn't occurred yet this year
      if (today.month < dob.month ||
          (today.month == dob.month && today.day < dob.day)) {
        age--;
      }

      return age;
    }

    return '--';
  }

  static showTitleProfessional({required String title}) {
    String? titleText;
    Color? titleColor;

    switch (title) {
      case 'confirmed':
        titleText = 'Upcoming Appointment';
        titleColor = ColorConstants.black;
        break;
      case 'started':
        titleText = 'Ongoing Appointment';
        titleColor = ColorConstants.black;
        break;
      case 'Completed':
        titleText = 'Appointment Completed';
        titleColor = ColorConstants.secondaryColor;
        break;
      case 'user cancel':
        titleText = 'Appointment Cancelled';
        titleColor = ColorConstants.primaryAppColor;
        break;
      case 'professional cancel':
        titleText = 'Professional Cancelled';
        titleColor = ColorConstants.primaryAppColor;
        break;
      default:
        titleText = '';
        titleColor = ColorConstants.white;
    }
    return [titleText, titleColor];
  }

  static showTitleUser({required String title}) {
    String? titleText;
    Color? titleColor;

    switch (title) {
      case 'confirmed':
        titleText = 'Confirmed';
        titleColor = ColorConstants.secondaryColor;
        break;
      case 'started':
        titleText = 'Ongoing Appointment';
        titleColor = ColorConstants.blueGreyish;
        break;
      case 'completed':
        titleText = 'Appointment Completed';
        titleColor = ColorConstants.secondaryColor;
        break;
      case 'user cancel':
        titleText = 'Appointment Cancelled';
        titleColor = ColorConstants.primaryAppColor;
        break;
      case 'professional cancel':
        titleText = 'Professional Cancelled';
        titleColor = ColorConstants.primaryAppColor;
        break;

      case 'pending':
        titleText = 'Pending';
        titleColor = ColorConstants.primaryAppColor;
        break;

      case 're schedule':
        titleText = 'Rescheduled';
        titleColor = ColorConstants.black;
        break;
      default:
        titleText = '';
        titleColor = ColorConstants.white;
    }
    return [titleText, titleColor];
  }
}
