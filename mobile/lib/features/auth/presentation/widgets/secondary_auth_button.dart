import 'package:flutter/material.dart';

import '../../../../../shared/widgets/buttons/secondary_button.dart';

class SecondaryAuthButton extends StatelessWidget {
  const SecondaryAuthButton({
    super.key,
    required this.label,
    this.onPressed,
    this.enabled = true,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return SecondaryButton(
      label: label,
      onPressed: onPressed,
      enabled: enabled,
      leftIcon: icon,
    );
  }
}
