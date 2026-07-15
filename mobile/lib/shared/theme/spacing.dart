import 'package:flutter/material.dart';

/// Spacing scale token helpers.

class IsSpacing {
  const IsSpacing();

  // Basic scale (8px grid) as required by Stitch tokens.
  double get unit => 8.0;
  double get xs => 4.0;
  double get sm => 8.0;
  double get md => 16.0;
  double get lg => 24.0;
  double get xl => 32.0;
  double get xxl => 48.0;

  EdgeInsets pAll(double v) => EdgeInsets.all(v);
  EdgeInsets pSym({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  EdgeInsets pOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
}
