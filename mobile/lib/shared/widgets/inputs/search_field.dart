import 'package:flutter/material.dart';

/// Search field extracted from Stitch overlays.

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    this.hintText,
    this.controller,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
  });

  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: scheme.surfaceContainerHighest,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
      ),
    );
  }
}
