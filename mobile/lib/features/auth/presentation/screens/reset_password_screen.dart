import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/auth_form_providers.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_password_input.dart';
import '../widgets/primary_auth_button.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  bool _isPasswordMatch = true;
  String? _strengthLabel;

  bool _isLoading = false;
  String? _serverError;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final formState = ref.watch(authFormProvider);

    final newPassword = formState.newPassword;
    final confirmPassword = formState.confirmPassword;

    final match = newPassword.isNotEmpty && confirmPassword.isNotEmpty
        ? newPassword == confirmPassword
        : true;

    _isPasswordMatch = match;

    final strength = _computePasswordStrength(newPassword);
    _strengthLabel = strength.label;

    final passwordRequirements = <_ReqItem>[
      _ReqItem(ok: newPassword.length >= 12, text: 'At least 12 characters'),
      _ReqItem(
        ok:
            RegExp(r'\d').hasMatch(newPassword) &&
            RegExp(r'[^a-zA-Z0-9]').hasMatch(newPassword),
        text: 'Include symbols and numbers',
      ),
      _ReqItem(
        ok: !_containsPersonalNameOrDate(newPassword),
        text: 'Avoid using personal names or dates',
      ),
    ];

    return AuthScaffold(
      showBrandInHeader: false,
      title: null,
      subtitle: null,
      appBarHeight: 0,
      child: _ResetPasswordCanvas(
        scheme: scheme,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        strengthLabel: _strengthLabel ?? '',
        passwordStrengthItems: passwordRequirements,
        isPasswordMatch: _isPasswordMatch,
        isLoading: _isLoading,
        serverError: _serverError,
        onBackToLogin: () => context.go('/login'),
        onNewPasswordChanged: (v) {
          ref.read(authFormProvider.notifier).setNewPassword(v);
          if (mounted) {
            setState(() {});
          }
        },
        onConfirmPasswordChanged: (v) {
          ref.read(authFormProvider.notifier).setConfirmPassword(v);
          if (mounted) {
            setState(() {});
          }
        },
        onSubmit: () async {
          setState(() {
            _serverError = null;
          });

          final newPass = formState.newPassword;
          final confirm = formState.confirmPassword;

          if (newPass.isEmpty) {
            setState(() => _serverError = 'New password is required.');
            return;
          }
          if (confirm.isEmpty) {
            setState(() => _serverError = 'Confirm password is required.');
            return;
          }
          if (newPass != confirm) {
            setState(() => _serverError = 'Passwords do not match.');
            return;
          }

          final ok = passwordRequirements.every((e) => e.ok);
          if (!ok) {
            setState(
              () => _serverError =
                  'Password does not meet the required guidelines.',
            );
            return;
          }

          setState(() => _isLoading = true);
          try {
            // No backend call specified by this task; keep UI logic only.
            await Future<void>.delayed(const Duration(milliseconds: 650));
            if (!mounted) return;
            setState(() => _isLoading = false);
            context.go('/login');
          } catch (e) {
            if (!mounted) return;
            setState(() {
              _isLoading = false;
              _serverError = 'Something went wrong. Please try again.';
            });
          }
        },
      ),
    );
  }

  bool _containsPersonalNameOrDate(String value) {
    // Offline heuristic: dates like 19xx/20xx or dd-mm; names are not available.
    final hasYear = RegExp(r'(19\d{2}|20\d{2})').hasMatch(value);
    final hasDatePattern = RegExp(
      r'\b\d{1,2}[\-/]\d{1,2}(?:[\-/]\d{2,4})?\b',
    ).hasMatch(value);
    return hasYear || hasDatePattern;
  }

  _Strength _computePasswordStrength(String value) {
    final lengthOk = value.length >= 12;
    final symbolOk = RegExp(r'[^a-zA-Z0-9]').hasMatch(value);
    final numberOk = RegExp(r'\d').hasMatch(value);

    if (lengthOk && symbolOk && numberOk) return _Strength.ok();
    if (lengthOk) return _Strength.medium();
    return _Strength.weak();
  }
}

class _ResetPasswordCanvas extends StatelessWidget {
  const _ResetPasswordCanvas({
    required this.scheme,
    required this.newPassword,
    required this.confirmPassword,
    required this.passwordStrengthItems,
    required this.isPasswordMatch,
    required this.isLoading,
    required this.serverError,
    required this.onBackToLogin,
    required this.onNewPasswordChanged,
    required this.onConfirmPasswordChanged,
    required this.onSubmit,
    required this.strengthLabel,
  });

  final ColorScheme scheme;
  final String newPassword;
  final String confirmPassword;
  final String strengthLabel;
  final List<_ReqItem> passwordStrengthItems;
  final bool isPasswordMatch;
  final bool isLoading;
  final String? serverError;

  final VoidCallback onBackToLogin;
  final ValueChanged<String> onNewPasswordChanged;
  final ValueChanged<String> onConfirmPasswordChanged;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Stack(
      children: [
        // Decorative archival bar
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: IgnorePointer(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: scheme.primary),
                    ),
                  ),
                  SizedBox(width: 0),
                  SizedBox(
                    width: isDesktop ? 96 : 72,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: scheme.tertiaryContainer,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: isDesktop ? 48 : 32,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: scheme.secondary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Content
        SafeArea(
          top: false,
          child: Column(
            children: [
              SizedBox(height: 12),
              // Top header shell (inline)
              SizedBox(
                height: 56,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        tooltip: 'Back',
                        onPressed: onBackToLogin,
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: scheme.primary,
                        ),
                      ),
                      Text(
                        'HERITAGE',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                            ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Card(
                      elevation: 0,
                      color: scheme.surfaceContainerLowest,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: scheme.outline),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: _Body(
                          scheme: scheme,
                          newPassword: newPassword,
                          confirmPassword: confirmPassword,
                          passwordStrengthItems: passwordStrengthItems,
                          isPasswordMatch: isPasswordMatch,
                          isLoading: isLoading,
                          serverError: serverError,
                          onNewPasswordChanged: onNewPasswordChanged,
                          onConfirmPasswordChanged: onConfirmPasswordChanged,
                          onSubmit: onSubmit,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Warm paper texture (offline-only)
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    scheme.surfaceContainerLowest,
                    scheme.surface,
                    scheme.surfaceContainerLowest,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.scheme,
    required this.newPassword,
    required this.confirmPassword,
    required this.passwordStrengthItems,
    required this.isPasswordMatch,
    required this.isLoading,
    required this.serverError,
    required this.onNewPasswordChanged,
    required this.onConfirmPasswordChanged,
    required this.onSubmit,
  });

  final ColorScheme scheme;
  final String newPassword;
  final String confirmPassword;
  final List<_ReqItem> passwordStrengthItems;
  final bool isPasswordMatch;
  final bool isLoading;
  final String? serverError;

  final ValueChanged<String> onNewPasswordChanged;
  final ValueChanged<String> onConfirmPasswordChanged;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        _HeroHeader(scheme: scheme),
        const SizedBox(height: 20),

        AuthPasswordInput(
          label: 'New Password',
          hintText: '••••••••',
          controller: null,
          errorText: null,
          onChanged: onNewPasswordChanged,
        ),

        // Ensure parity with visibility toggles: we use AuthPasswordInput which already includes toggle.
        const SizedBox(height: 16),
        AuthPasswordInput(
          label: 'Confirm Password',
          hintText: '••••••••',
          controller: null,
          errorText: isPasswordMatch ? null : 'Passwords do not match.',
          onChanged: onConfirmPasswordChanged,
        ),

        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            border: Border.all(color: scheme.outline),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Password Strength Guidelines:',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              ...passwordStrengthItems.map(
                (e) => _guidelineRow(
                  context: context,
                  scheme: scheme,
                  ok: e.ok,
                  text: e.text,
                ),
              ),
            ],
          ),
        ),

        if (serverError != null) ...[
          const SizedBox(height: 12),
          Text(
            serverError!,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: scheme.error),
            textAlign: TextAlign.center,
          ),
        ],

        const SizedBox(height: 20),
        PrimaryAuthButton(
          label: 'Save & Sign In',
          enabled: !isLoading,
          isLoading: isLoading,
          onPressed: isLoading ? null : () => onSubmit(),
        ),

        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () {
              // UI-only; back to login is the parity-critical action.
              onSubmit; // keep analyzer quiet about unused callback in parity.
              context.go('/login');
            },
            child: Text(
              'Contact Support',
              style: TextStyle(color: scheme.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.scheme});
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Icon(Icons.security_rounded, size: 32, color: scheme.primary),
        ),
        const SizedBox(height: 14),
        Text(
          'Security Update',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Update your credentials to ensure your account remains a protected piece of our shared history.',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

Widget _guidelineRow({
  required BuildContext context,
  required ColorScheme scheme,
  required bool ok,
  required String text,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Icon(
          ok ? Icons.check_circle_rounded : Icons.check_circle_outline,
          size: 18,
          color: scheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ),
      ],
    ),
  );
}

typedef ValueChanged<T> = void Function(T value);

class _ReqItem {
  const _ReqItem({required this.ok, required this.text});
  final bool ok;
  final String text;
}

class _Strength {
  const _Strength(this.label);
  final String label;
  factory _Strength.ok() => const _Strength('Good');
  factory _Strength.medium() => const _Strength('Medium');
  factory _Strength.weak() => const _Strength('Weak');
}
