import 'package:flutter/material.dart';

/// Shadow tokens extracted from Stitch.
class AppShadows {
  const AppShadows();

  // Material 3 elevation-ish tokens (for consistent look).
  BoxShadow get z0 => const BoxShadow(color: Color(0x00000000));

  BoxShadow get z1 => const BoxShadow(
    color: Color(0x14000000),
    blurRadius: 4,
    offset: Offset(0, 1),
  );

  BoxShadow get z2 => const BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 8,
    offset: Offset(0, 2),
  );

  BoxShadow get z3 => const BoxShadow(
    color: Color(0x1F000000),
    blurRadius: 12,
    offset: Offset(0, 4),
  );

  // Editorial card shadow used across auth + editorial components.
  BoxShadow get editorial => const BoxShadow(
    color: Color(0x1A2D2926),
    blurRadius: 12,
    offset: Offset(0, 4),
  );

  BoxShadow get editorialSoft => const BoxShadow(
    color: Color(0x0D000000),
    blurRadius: 6,
    offset: Offset(0, 2),
  );
}
