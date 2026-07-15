import 'package:flutter/material.dart';

class IsAnimations {
  const IsAnimations();

  Duration get fast => const Duration(milliseconds: 150);
  Duration get normal => const Duration(milliseconds: 250);
  Duration get slow => const Duration(milliseconds: 400);

  Curve get standard => Curves.easeInOut;
}
