import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth_form_providers.dart';
import '../controllers/otp_provider.dart';
import '../widgets/otp_code_field.dart';
import '../widgets/primary_auth_button.dart';
import '../widgets/auth_scaffold.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  String? _otpError;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final otpLen = ref.watch(otpLengthProvider);
    final formState = ref.watch(authFormProvider);

    final otp = formState.otp;

    final isValid = otp.length == otpLen && RegExp(r'^\d+$').hasMatch(otp);

    return AuthScaffold(
      title: 'Verification Required',
      subtitle: null,
      child: Card(
        elevation: 0,
        color: scheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'A code has been sent to your device. Please enter the archival key to continue your journey.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              OtpCodeField(
                length: otpLen,
                errorText: _otpError,
                onChanged: (v) => ref.read(authFormProvider.notifier).setOtp(v),
              ),
              const SizedBox(height: 20),
              PrimaryAuthButton(
                label: 'Verify & Proceed',
                enabled: true,
                onPressed: () {
                  if (!isValid) {
                    setState(() {
                      _otpError = 'Enter the 4-digit code.';
                    });
                    return;
                  }
                  setState(() => _otpError = null);
                  context.go('/reset-password');
                },
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {
                    // visual-only resend
                  },
                  child: Text(
                    'Resend Code',
                    style: TextStyle(color: scheme.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
