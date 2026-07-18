import 'package:flutter/material.dart';

/// Border token helpers extracted from Stitch.
class AppBorders {
  const AppBorders();

  // Default styles
  BorderSide get defaultBorder =>
      const BorderSide(width: 1, color: Color(0xFFDFBFBC));
  BorderSide get outline =>
      const BorderSide(width: 1, color: Color(0xFFDFBFBC));

  // Focused styles
  BorderSide get focused =>
      const BorderSide(width: 1, color: Color(0xFF6A020A));

  // Error styles
  BorderSide get error => const BorderSide(width: 1, color: Color(0xFFBA1A1A));

  // Disabled styles
  BorderSide get disabled =>
      const BorderSide(width: 1, color: Color(0xFF8B716E));

  // Divider styles
  BorderSide get divider =>
      const BorderSide(width: 1, color: Color(0xFFDFBFBC));

  // Card styles
  BorderSide get card => const BorderSide(width: 1, color: Color(0xFFDFBFBC));

  // Input outline style
  BorderSide get input => const BorderSide(width: 1, color: Color(0xFFDFBFBC));

  // Backward compatible names
  BorderSide get primary =>
      const BorderSide(width: 1, color: Color(0xFF6A020A));
  BorderSide get outlineVariant =>
      const BorderSide(width: 1, color: Color(0xFFDFBFBC));
}
