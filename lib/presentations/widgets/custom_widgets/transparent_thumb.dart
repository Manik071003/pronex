import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';

class TransparentThumbShape extends RangeSliderThumbShape {
  final double thumbRadius;

  const TransparentThumbShape({this.thumbRadius = 10});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        Animation<double>? activationAnimation,
        Animation<double>? enableAnimation,
        bool? isDiscrete,
        bool? isEnabled,
        bool? isOnTop,
        SliderThemeData? sliderTheme,
        TextDirection? textDirection,
        Thumb? thumb,
        bool? isPressed,
      }) {
    final Canvas canvas = context.canvas;

    final Paint borderPaint = Paint()
      ..color = sliderTheme?.activeTrackColor ?? Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final Paint fillPaint = Paint()
      ..color = ColorConstants.secondaryColor
      ..style = PaintingStyle.fill;

    /// transparent center
    canvas.drawCircle(center, thumbRadius, fillPaint);

    /// border
    canvas.drawCircle(center, thumbRadius, borderPaint);
  }
}