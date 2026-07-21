import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ignore_for_file: use_build_context_synchronously

import '../../../../core/services/auth_state_provider.dart';
import '../controllers/auth_form_providers.dart';
import '../widgets/auth_labeled_text_field.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/primary_auth_button.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  String? _emailError;
  bool _isSubmitting = false;
  String? _successMessage;

  static final _emailPattern = RegExp(r'^\S+@\S+\.\S+$');

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _validate() {
    final email = _emailController.text.trim();
    setState(() {
      _emailError = email.isEmpty
          ? 'Email is required.'
          : (!_emailPattern.hasMatch(email) ? 'Enter a valid email.' : null);
    });
    return _emailError == null;
  }

  Future<void> _handleSendResetLink() async {
    if (_isSubmitting) return;
    if (!_validate()) return;

    setState(() {
      _isSubmitting = true;
      _successMessage = null;
      _emailError = null;
    });

    try {
      final email = _emailController.text.trim();
      await ref.read(authStateProvider.notifier).sendPasswordResetEmail(email);
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _successMessage = 'Recovery link sent! Check your inbox.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _emailError = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;
    final formState = ref.watch(authFormProvider);

    _emailController.value = _emailController.value.copyWith(
      text: formState.email,
    );

    final cardBorder = BorderSide(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.9),
    );

    return AuthScaffold(
      showBrandInHeader: false,
      title: null,
      subtitle: null,
      appBarHeight: 0,
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      scheme.surface.withValues(alpha: 1),
                      scheme.surfaceContainerHighest.withValues(alpha: 0.35),
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.history_edu,
                            size: 36,
                            color: scheme.primary,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Restore Access',
                            textAlign: TextAlign.center,
                            style: typography.displaySmall?.copyWith(
                              color: scheme.primary,
                              height: 1.05,
                              letterSpacing: -0.2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: 64,
                            height: 2,
                            decoration: BoxDecoration(
                              color: scheme.primary.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 0,
                      color: scheme.surfaceContainerLowest,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: cardBorder,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_successMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  _successMessage!,
                                  style: typography.bodyMedium?.copyWith(
                                    color: scheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            else
                              Text(
                                'Enter your registered email to receive recovery instructions.',
                                style: typography.bodyMedium?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            const SizedBox(height: 22),
                            AuthLabeledTextField(
                              label: 'Email Address',
                              hintText: 'e.g. curator@heritage.org',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              errorText: _emailError,
                              onChanged: (v) => ref
                                  .read(authFormProvider.notifier)
                                  .setEmail(v),
                            ),
                            const SizedBox(height: 22),
                            PrimaryAuthButton(
                              label: _isSubmitting
                                  ? 'Sending...'
                                  : 'Send Recovery Link',
                              enabled: !_isSubmitting,
                              onPressed: _handleSendResetLink,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 22),
                      child: Column(
                        children: [
                          TextButton.icon(
                            onPressed: () => context.go('/login'),
                            icon: Icon(
                              Icons.keyboard_backspace,
                              color: scheme.primary,
                              size: 18,
                            ),
                            label: Text(
                              'Back to Login',
                              style: TextStyle(color: scheme.primary),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '© 2024 The India Story Project • Archival Access',
                            style: typography.labelSmall?.copyWith(
                              color: scheme.onSurfaceVariant.withValues(
                                alpha: 0.38,
                              ),
                              letterSpacing: 2,
                              fontSize: 10,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
