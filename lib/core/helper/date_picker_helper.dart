import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../constants/color_constants.dart';

class DatePickerHelper {
  DatePickerHelper._();

  static Future<DateTime?> show({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    Color? primaryColor,
  }) {
    final size = MediaQuery.sizeOf(context);
    final isCompact = size.height < 700 || size.width < 380;
    final primary = primaryColor ?? ColorConstants.primaryAppColor;

    return showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,

      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,

      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();

        final theme = Theme.of(context);

        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(primary: primary),
            dialogTheme: theme.dialogTheme.copyWith(
              insetPadding: EdgeInsets.symmetric(
                horizontal: math.max(8.0, size.width * 0.04),
                vertical: math.max(12.0, size.height * 0.03),
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              headerHeadlineStyle: TextStyle(
                fontSize: isCompact ? 18 : 22,
                fontWeight: FontWeight.w600,
              ),
              dayStyle: TextStyle(fontSize: isCompact ? 12 : 14),
              weekdayStyle: TextStyle(fontSize: isCompact ? 11 : 13),
              yearStyle: TextStyle(fontSize: isCompact ? 14 : 16),
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: MediaQuery.textScalerOf(context).clamp(
                minScaleFactor: 0.85,
                maxScaleFactor: 1.0,
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: size.width * 0.9,
                  maxHeight: size.height * (isCompact ? 0.55 : 0.72),
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
