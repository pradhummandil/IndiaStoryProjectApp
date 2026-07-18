import 'package:flutter/material.dart';

/// Icon token helpers.
class AppIcons {
  const AppIcons();

  // Centralized icon references (Material Icons fallbacks).
  // Note: current app visuals use Material Symbols via font; this is for widgets.
  static const IconData chevronDown = Icons.expand_more;
  static const IconData mail = Icons.mail_outline;
  static const IconData lock = Icons.lock_outline;
  static const IconData arrowBack = Icons.arrow_back_ios_new;
}
