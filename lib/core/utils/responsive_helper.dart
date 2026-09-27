import 'package:flutter/material.dart';

class Responsive {
  static late Size size;

  static double xdHeight = 844;
  static double xdWidth = 390;

  static double setHeight({required num value}) {
    double percentage = (value / xdHeight * 100).roundToDouble() / 100;
    return size.height * percentage;
  }

  static double setWidth({required num value}) {
    double percentage = (value / xdWidth * 100).roundToDouble() / 100;
    return size.width * percentage;
  }
}
