import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/auth_form_providers.dart';
import '../widgets/auth_labeled_text_field.dart';
import '../widgets/auth_password_input.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/primary_auth_button.dart';

/// Register (UI-only) - based on Stitch export.
/// No backend integration.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _termsError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validate(bool termsAccepted) {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final pass = _passwordController.text;

    setState(() {
      _nameError = name.isEmpty ? 'Full name is required.' : null;
      _emailError = email.isEmpty
          ? 'Email is required.'
          : (!RegExp(r'^\\S+@\\S+\\.\\S+$').hasMatch(email)
                ? 'Enter a valid email.'
                : null);
      _passwordError = pass.isEmpty ? 'Password is required.' : null;
      _termsError = termsAccepted ? null : 'You must accept the terms.';
    });

    return _nameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _termsError == null;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final formState = ref.watch(authFormProvider);

    // Keep controllers synced with Riverpod values.
    _nameController.value = _nameController.value.copyWith(
      text: formState.fullName,
    );
    _emailController.value = _emailController.value.copyWith(
      text: formState.email,
    );
    _passwordController.value = _passwordController.value.copyWith(
      text: formState.password,
    );

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Archive Membership',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Begin Your Intellectual Journey',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: scheme.primary,
                      height: 1.1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Join our community of historians, storytellers, and archivists preserving India's rich cultural lineage.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: scheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthTextField(
                          label: 'Full Name',
                          hintText: 'E.g., Vikram Seth',
                          controller: _nameController,
                          errorText: _nameError,
                          onChanged: (v) => ref
                              .read(authFormProvider.notifier)
                              .setFullName(v),
                        ),
                        const SizedBox(height: 16),
                        AuthLabeledTextField(
                          label: 'Email Address',
                          hintText: 'name@archive.in',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          errorText: _emailError,
                          onChanged: (v) =>
                              ref.read(authFormProvider.notifier).setEmail(v),
                        ),
                        const SizedBox(height: 16),
                        AuthPasswordInput(
                          label: 'Password',
                          hintText: '••••••••',
                          controller: _passwordController,
                          errorText: _passwordError,
                          onChanged: (v) => ref
                              .read(authFormProvider.notifier)
                              .setPassword(v),
                        ),
                        const SizedBox(height: 12),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          value: formState.termsAccepted,
                          onChanged: (v) {
                            ref
                                .read(authFormProvider.notifier)
                                .setTermsAccepted(v ?? false);
                          },
                          title: Text(
                            'I agree to the Terms & Conditions and Privacy Policy of the India Story Project.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ),
                        if (_termsError != null) ...[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              _termsError!,
                              style: TextStyle(color: scheme.error),
                            ),
                          ),
                        ],

                        PrimaryAuthButton(
                          label: 'Create Account',
                          onPressed: () {
                            final ok = _validate(formState.termsAccepted);
                            if (!ok) return;
                            context.go('/email-verification');
                          },
                        ),

                        const SizedBox(height: 14),
                        Center(
                          child: TextButton(
                            onPressed: () => context.go('/login'),
                            child: Text(
                              'Sign In',
                              style: TextStyle(color: scheme.primary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
