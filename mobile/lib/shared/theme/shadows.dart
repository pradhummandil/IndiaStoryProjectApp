import 'package:flutter/material.dart';

/// Shadow tokens extracted from Stitch patterns.

class IsShadows {
  const IsShadows();

  BoxShadow get card => const BoxShadow(
    color: Color(0x193D2F2D),
    blurRadius: 12,
    offset: Offset(0, 4),
  );

  BoxShadow get cardSoft => const BoxShadow(
    color: Color(0x0D000000),
    blurRadius: 6,
    offset: Offset(0, 2),
  );
}
