import 'package:flutter/material.dart';

/// Global spacing tokens extracted from Stitch.
class AppSpacing {
  const AppSpacing();

  // Spacing scale (8px grid inspired by Stitch exports).
  static const double s2 = 2;
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s40 = 40;
  static const double s48 = 48;
  static const double s56 = 56;
  static const double s64 = 64;

  // Aliases (for readability in layouts).
  double get unit => s8;
  double get xs => s4;
  double get sm => s8;
  double get md => s16;
  double get lg => s24;
  double get xl => s32;
  double get xxl => s48;

  double get s2_ => s2;
  double get s4_ => s4;
  double get s8_ => s8;
  double get s12_ => s12;
  double get s16_ => s16;
  double get s20_ => s20;
  double get s24_ => s24;
  double get s32_ => s32;
  double get s40_ => s40;
  double get s48_ => s48;
  double get s56_ => s56;
  double get s64_ => s64;

  EdgeInsets all(double v) => EdgeInsets.all(v);
  EdgeInsets sym({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
}
