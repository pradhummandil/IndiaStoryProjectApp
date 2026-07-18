import 'package:flutter/material.dart';

/// Gradient tokens extracted from Stitch.
class AppGradients {
  const AppGradients();

  // Warm paper subtle gradient.
  LinearGradient get royalGradient => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color.fromARGB(0, 139, 30, 30), Color.fromARGB(8, 139, 30, 30)],
  );
}
