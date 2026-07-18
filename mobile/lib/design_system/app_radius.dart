import 'package:flutter/material.dart';

/// Radius token helpers extracted from Stitch.
class AppRadius {
  const AppRadius();

  // Standard radius constants (avoid magic numbers in widgets).
  static const double xsValue = 4;
  static const double smValue = 8;
  static const double mdValue = 12;
  static const double lgValue = 16;
  static const double xlValue = 20;
  static const double pillValue = 999;

  BorderRadius get xs => BorderRadius.circular(xsValue);
  BorderRadius get sm => BorderRadius.circular(smValue);
  BorderRadius get md => BorderRadius.circular(mdValue);
  BorderRadius get lg => BorderRadius.circular(lgValue);
  BorderRadius get xl => BorderRadius.circular(xlValue);
  BorderRadius get pill => BorderRadius.circular(pillValue);
}
