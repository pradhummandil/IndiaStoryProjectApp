import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/auth_form_providers.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/primary_auth_button.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  static const Duration _resendDuration = Duration(seconds: 45);

  Timer? _timer;
  Duration _remaining = _resendDuration;

  bool _isOpeningEmail = false;
  bool _isResending = false;
  bool _isContinuing = false;

  String? _error;

  bool get _resendEnabled => _remaining == Duration.zero;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    if (!mounted) return;

    final start = DateTime.now();
    _remaining = _resendDuration;

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;

      final elapsed = DateTime.now().difference(start);
      final nextRemaining = _resendDuration - elapsed;

      if (nextRemaining <= Duration.zero) {
        setState(() => _remaining = Duration.zero);
        t.cancel();
        return;
      }

      setState(() => _remaining = nextRemaining);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatRemaining(Duration d) {
    final totalSeconds = d.inSeconds;
    final mm = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final ss = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final formState = ref.watch(authFormProvider);
    final displayedEmail = formState.email.isNotEmpty
        ? formState.email
        : 'arnav.sharma@heritage.in';

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(color: scheme.surface),
              ),
            ),
            // Paper texture (offline)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _PaperTexturePainter(
                    color: scheme.onSurfaceVariant.withValues(alpha: 0.06),
                  ),
                ),
              ),
            ),

            // Fixed top bar (matches transactional HTML)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: scheme.surface.withValues(alpha: 0.6),
                  border: Border(
                    bottom: BorderSide(
                      color: scheme.outlineVariant.withValues(alpha: 0.15),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'HERITAGE',
                      style: Theme.of(
                        context,
                      ).textTheme.displaySmall?.copyWith(color: scheme.primary),
                    ),
                    IconButton(
                      onPressed: () => context.go('/login'),
                      icon: Icon(Icons.close, color: scheme.primary),
                    ),
                  ],
                ),
              ),
            ),

            // Main content canvas
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 72,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 450),
                          opacity: 1,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 480),
                            child: Container(
                              decoration: BoxDecoration(
                                color: scheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: scheme.surfaceContainerHighest,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 14,
                                    color: Colors.black.withValues(alpha: 0.04),
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Illustration
                                    SizedBox(
                                      width: 192,
                                      height: 192,
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        alignment: Alignment.center,
                                        children: [
                                          Positioned.fill(
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: scheme.primary
                                                    .withValues(alpha: 0.06),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            child: Transform.rotate(
                                              angle: -0.08,
                                              child: Container(
                                                width: 128,
                                                height: 128,
                                                decoration: BoxDecoration(
                                                  color: scheme.surface,
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  border: Border.all(
                                                    color: scheme
                                                        .surfaceContainerHighest,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.mail,
                                                    size: 56,
                                                    color: scheme.primary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: -16,
                                            right: -2,
                                            child: Transform.rotate(
                                              angle: 0.2,
                                              child: Container(
                                                width: 48,
                                                height: 48,
                                                decoration: BoxDecoration(
                                                  color: scheme.primary,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 18,
                                                      color: Colors.black
                                                          .withValues(
                                                            alpha: 0.18,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 26,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    Text(
                                      'Check Your Inbox',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(color: scheme.onSurface),
                                    ),

                                    const SizedBox(height: 12),

                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              color: scheme.onSurfaceVariant,
                                            ),
                                        children: [
                                          const TextSpan(
                                            text:
                                                'A verification link has been sent to\n',
                                          ),
                                          TextSpan(
                                            text: displayedEmail,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  color: scheme.primary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 14),

                                    Text(
                                      'Please click the link in the email to activate your account and start your journey through history.',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: scheme.onSurfaceVariant
                                                .withValues(alpha: 0.7),
                                          ),
                                    ),

                                    const SizedBox(height: 20),

                                    PrimaryAuthButton(
                                      label: _isOpeningEmail
                                          ? 'REDIRECTING...'
                                          : 'OPEN EMAIL APP',
                                      enabled:
                                          !_isOpeningEmail && !_isContinuing,
                                      onPressed: _isOpeningEmail
                                          ? null
                                          : () async {
                                              setState(
                                                () => _isOpeningEmail = true,
                                              );
                                              await Future<void>.delayed(
                                                const Duration(
                                                  milliseconds: 1500,
                                                ),
                                              );
                                              if (!mounted) return;
                                              setState(
                                                () => _isOpeningEmail = false,
                                              );
                                            },
                                    ),

                                    const SizedBox(height: 12),

                                    TextButton(
                                      onPressed: _isContinuing
                                          ? null
                                          : () => context.go('/register'),
                                      child: Text(
                                        'Change Email Address',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(color: scheme.primary),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    Divider(
                                      color: scheme.surfaceContainerHighest,
                                    ),

                                    const SizedBox(height: 14),

                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: 4,
                                      runSpacing: 4,
                                      children: [
                                        Text(
                                          "Didn't receive the email? Check your spam folder or ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                color: scheme.onSurfaceVariant
                                                    .withValues(alpha: 0.6),
                                                height: 1.4,
                                              ),
                                        ),
                                        TextButton(
                                          onPressed:
                                              (!_resendEnabled || _isResending)
                                              ? null
                                              : () async {
                                                  setState(
                                                    () => _isResending = true,
                                                  );
                                                  await Future<void>.delayed(
                                                    const Duration(
                                                      milliseconds: 900,
                                                    ),
                                                  );
                                                  if (!mounted) return;
                                                  setState(() {
                                                    _isResending = false;
                                                    _error = null;
                                                  });
                                                  _startCountdown();
                                                },
                                          child: Text(
                                            _resendEnabled
                                                ? 'request a resend'
                                                : 'request a resend (${_formatRemaining(_remaining)})',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge
                                                ?.copyWith(
                                                  color: scheme.primary,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor:
                                                      scheme.primary,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    if (_error != null) ...[
                                      const SizedBox(height: 10),
                                      Text(
                                        _error!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: scheme.error),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        '© India Story Project 2024 • Archiving the Soul of a Nation',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant.withValues(alpha: 0.5),
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaperTexturePainter extends CustomPainter {
  _PaperTexturePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final rand = Random(1);

    for (int i = 0; i < 750; i++) {
      final x = rand.nextDouble() * size.width;
      final y = rand.nextDouble() * size.height;
      final r = rand.nextDouble() * 1.6 + 0.25;
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PaperTexturePainter oldDelegate) =>
      oldDelegate.color != color;
}
