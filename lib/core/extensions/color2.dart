import 'package:flutter/material.dart';

extension Color2 on Color {
  Color withMultipliedOpacity(double opacity) {
    double result = this.opacity * opacity;
    if (result > 1) result = 1.0;
    return withAlpha((255.0 * result).round());
  }
}
