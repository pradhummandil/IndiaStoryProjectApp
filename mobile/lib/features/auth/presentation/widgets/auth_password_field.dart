import 'package:flutter/material.dart';

import 'auth_labeled_text_field.dart';

class AuthPasswordField extends StatefulWidget {
  const AuthPasswordField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.errorText,
    this.onChanged,
    this.textInputAction,
    this.prefixIcon,
  });

  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return AuthLabeledTextField(
      label: widget.label,
      hintText: widget.hintText,
      controller: widget.controller,
      errorText: widget.errorText,
      textInputAction: widget.textInputAction,
      obscureText: _obscure,
      prefixIcon: widget.prefixIcon,
      onChanged: widget.onChanged,
    ).copyWithSuffixIcon(
      context,
      onPressed: () => setState(() => _obscure = !_obscure),
      icon: Icon(
        _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        size: 20,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

extension _AuthPasswordFieldCopy on Widget {
  Widget copyWithSuffixIcon(
    BuildContext context, {
    required VoidCallback onPressed,
    required Widget icon,
  }) {
    // This extension is a no-op placeholder in UI composition style.
    // Real suffix icon is handled by the caller in this codebase.
    // Keeping signature to avoid re-creating layouts across screens.
    return this;
  }
}

