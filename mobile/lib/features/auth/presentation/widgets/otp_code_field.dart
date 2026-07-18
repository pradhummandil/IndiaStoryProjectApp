import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpCodeField extends StatefulWidget {
  const OtpCodeField({
    super.key,
    required this.length,
    required this.onChanged,
    this.errorText,
  });

  final int length;
  final ValueChanged<String> onChanged;
  final String? errorText;

  @override
  State<OtpCodeField> createState() => _OtpCodeFieldState();
}

class _OtpCodeFieldState extends State<OtpCodeField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (i) => TextEditingController());
    _focusNodes = List.generate(widget.length, (i) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _emit() {
    final value = _controllers.map((c) => c.text).join();
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.length, (i) {
            return SizedBox(
              width: 52,
              child: TextField(
                controller: _controllers[i],
                focusNode: _focusNodes[i],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 1,
                style: Theme.of(context).textTheme.headlineSmall,
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: scheme.surface,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: scheme.error),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: scheme.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: scheme.primary),
                  ),
                ),
                onChanged: (v) {
                  if (v.isNotEmpty) {
                    _emit();
                    if (i < widget.length - 1) {
                      _focusNodes[i + 1].requestFocus();
                    } else {
                      FocusScope.of(context).unfocus();
                    }
                  } else {
                    _emit();
                  }
                },
                onSubmitted: (_) {
                  _emit();
                },
                onTap: () {
                  // Ensure cursor is at end; TextField default.
                },
              ),
            );
          }),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.errorText!,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: scheme.error),
          ),
        ],
      ],
    );
  }
}
