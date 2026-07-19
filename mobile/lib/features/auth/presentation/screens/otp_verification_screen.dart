import 'dart:async';

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
  bool _isSubmitting = false;
  bool _success = false;
  Timer? _timer;
  int _secondsRemaining = 45;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsRemaining = 45;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (_secondsRemaining <= 1) {
          _secondsRemaining = 0;
          t.cancel();
        } else {
          _secondsRemaining--;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final otpLen = ref.watch(otpLengthProvider);
    final formState = ref.watch(authFormProvider);

    final otp = formState.otp;
    final isValid = otp.length == otpLen && RegExp(r'^\d+$').hasMatch(otp);

    return AuthScaffold(
      showBrandInHeader: false,
      title: null,
      subtitle: null,
      appBarHeight: 0,
      child: Stack(
        children: [
          // Atmospheric background (procedural)
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      scheme.surfaceContainerHighest.withValues(alpha: 0.2),
                      scheme.surface.withValues(alpha: 1),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Crest
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: scheme.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Icon(
                        Icons.verified_user,
                        color: scheme.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Title + description
                    Text(
                      'Verification Required',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: scheme.primary),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'A code has been sent to your device. Please enter the archival key to continue your journey.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 26),

                    // OTP Card
                    Card(
                      elevation: 0,
                      color: scheme.surfaceContainerLowest,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: scheme.outlineVariant),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            OtpCodeField(
                              length: otpLen,
                              errorText: _otpError,
                              onChanged: (v) =>
                                  ref.read(authFormProvider.notifier).setOtp(v),
                            ),
                            const SizedBox(height: 20),
                            PrimaryAuthButton(
                              label: _isSubmitting
                                  ? 'Verifying...'
                                  : _success
                                  ? 'Identity Verified'
                                  : 'Verify & Proceed',
                              enabled: !_isSubmitting && !_success,
                              onPressed: _success
                                  ? null
                                  : () async {
                                      if (!isValid) {
                                        setState(() {
                                          _otpError = 'Enter the 4-digit code.';
                                        });
                                        return;
                                      }
                                      setState(() {
                                        _otpError = null;
                                        _isSubmitting = true;
                                      });

                                      await Future<void>.delayed(
                                        const Duration(milliseconds: 900),
                                      );
                                      if (!mounted) return;

                                      setState(() {
                                        _isSubmitting = false;
                                        _success = true;
                                      });

                                      // Match HTML: navigate after success.
                                      await Future<void>.delayed(
                                        const Duration(milliseconds: 450),
                                      );
                                      if (!mounted) return;
                                      context.go('/reset-password');
                                    },
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: TextButton(
                                onPressed: _secondsRemaining == 0 && !_success
                                    ? () {
                                        // UI-only resend.
                                        setState(() {
                                          _otpError = null;
                                        });
                                        _startTimer();
                                      }
                                    : null,
                                child: Text(
                                  _secondsRemaining == 0
                                      ? 'Resend Code'
                                      : 'Resend in 00:${_secondsRemaining.toString().padLeft(2, '0')}',
                                  style: TextStyle(color: scheme.primary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Decorative quotation border
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Divider(
                            color: scheme.outlineVariant.withValues(alpha: 0.5),
                            thickness: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 18, bottom: 4),
                            child: Text(
                              '"History is a set of lies agreed upon." — Bonaparte',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: scheme.onSurfaceVariant.withValues(
                                      alpha: 0.6,
                                    ),
                                    fontStyle: FontStyle.italic,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Footer identity (HTML asymmetry)
          Positioned(
            left: 16,
            right: 16,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: scheme.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
                color: scheme.surfaceContainerLowest,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HERITAGE',
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                color: scheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Archiving the Soul of India',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: scheme.onSurfaceVariant,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Every digit secured ensures the preservation of our collective narratives.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
