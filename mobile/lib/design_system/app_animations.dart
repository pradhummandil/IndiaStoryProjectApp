import 'package:flutter/material.dart';

class AppAnimations {
  const AppAnimations();

  // Standard curves.
  Curve get standard => Curves.easeInOut;
  Curve get decelerate => Curves.decelerate;
  Curve get accelerate => Curves.fastOutSlowIn;

  // Standard durations.
  Duration get fast => const Duration(milliseconds: 150);
  Duration get normal => const Duration(milliseconds: 250);
  Duration get slow => const Duration(milliseconds: 400);
}
