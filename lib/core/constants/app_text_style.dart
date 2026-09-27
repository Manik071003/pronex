import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constant_imports.dart';

class AppTextStyles {
  static TextStyle header() {
    return AppTextStyles.boldText(fontSize: Dimensions.px30);
  }

  static TextStyle regularText({
    double? height,
    Color color = ColorConstants.black,
    bool isUnderline = false,
    double fontSize = Dimensions.px12,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
  }

  static TextStyle mediumText({
    double? height,
    Color color = ColorConstants.black,
    bool isUnderline = false,
    double fontSize = Dimensions.px15,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
  }

  static TextStyle semiBoldText({
    double? height,

    Color color = ColorConstants.white,
    bool isUnderline = false,
    double fontSize = Dimensions.px16,
    FontWeight fontWeight = FontWeight.w700,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: isUnderline
          ? TextDecoration.lineThrough
          : TextDecoration.none,
    );
  }

  static TextStyle boldText({
    double? height,
    Color color = ColorConstants.black,
    bool isUnderline = false,
    double fontSize = Dimensions.px15,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
      height: height,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
  }
}
