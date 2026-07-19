import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/gestures.dart';

import 'package:go_router/go_router.dart';

import '../controllers/auth_form_providers.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_password_input.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/primary_auth_button.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _fullNameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _termsError;

  final _strengthAnimation = ValueNotifier<double>(0);

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _strengthAnimation.dispose();
    super.dispose();
  }

  bool _validate({required bool termsAccepted}) {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      _fullNameError = fullName.isEmpty ? 'Full name is required.' : null;
      _emailError = email.isEmpty
          ? 'Email is required.'
          : (!_emailPattern.hasMatch(email) ? 'Enter a valid email.' : null);
      _passwordError = password.isEmpty ? 'Password is required.' : null;
      _confirmPasswordError =
          confirmPassword.isEmpty || confirmPassword != password
          ? 'Confirm password must match password.'
          : null;
      _termsError = termsAccepted ? null : 'You must accept the terms.';
    });

    return _fullNameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _termsError == null;
  }

  static final _emailPattern = RegExp(r'^\\S+@\\S+\\.\\S+$');

  // HTML strength is not fully specified as exact algorithm; implement a deterministic
  // score based on common requirements.
  // Still UI-only: no backend.
  double _computeStrength(String password) {
    if (password.isEmpty) return 0;

    final hasLower = password.contains(RegExp(r'[a-z]'));
    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasDigit = password.contains(RegExp(r'\d'));
    final hasSpecial = password.contains(RegExp(r'[^A-Za-z0-9]'));
    final lengthScore = (password.length / 12).clamp(0, 1);

    int points = 0;
    if (hasLower) points++;
    if (hasUpper) points++;
    if (hasDigit) points++;
    if (hasSpecial) points++;

    final base = points / 4; // 0..1
    final score = 0.45 * base + 0.55 * lengthScore;
    return score.clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final formState = ref.watch(authFormProvider);

    // Sync controllers.
    _fullNameController.value = _fullNameController.value.copyWith(
      text: formState.fullName,
    );
    _emailController.value = _emailController.value.copyWith(
      text: formState.email,
    );
    _passwordController.value = _passwordController.value.copyWith(
      text: formState.password,
    );

    // No confirmPassword in existing provider => keep local confirm text.
    // Validation uses confirm controller.

    final password = formState.password;
    final strength = _computeStrength(password);

    return AuthScaffold(
      showBrandInHeader: false,
      title: null,
      subtitle: null,
      appBarHeight: 0,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 900;

            final header = _RegisterHeader(scheme: scheme);

            final card = AuthCard(
              maxWidth: 480,
              padding: 32,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthTextField(
                    label: 'Full Name',
                    hintText: 'E.g., Vikram Seth',
                    controller: _fullNameController,
                    errorText: _fullNameError,
                    onChanged: (v) =>
                        ref.read(authFormProvider.notifier).setFullName(v),
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    label: 'Email Address',
                    hintText: 'name@archive.in',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    errorText: _emailError,
                    onChanged: (v) =>
                        ref.read(authFormProvider.notifier).setEmail(v),
                  ),
                  const SizedBox(height: 16),

                  // Password
                  AuthPasswordInput(
                    label: 'Password',
                    hintText: '••••••••',
                    controller: _passwordController,
                    errorText: _passwordError,
                    onChanged: (v) {
                      ref.read(authFormProvider.notifier).setPassword(v);
                      // live updates
                      _strengthAnimation.value = strength;
                    },
                  ),

                  const SizedBox(height: 12),

                  // Password strength UI (HTML has a strength indicator + requirements list)
                  _PasswordStrengthPanel(
                    scheme: scheme,
                    password: password,
                    strength: strength,
                  ),

                  const SizedBox(height: 16),

                  // Confirm password (needs same styling + toggle)
                  AuthPasswordInput(
                    label: 'Confirm Password',
                    hintText: '••••••••',
                    controller: _confirmPasswordController,
                    errorText: _confirmPasswordError,
                    onChanged: (_) {
                      // Live validation when confirm changes.
                      if (_confirmPasswordController.text.isEmpty) {
                        setState(() => _confirmPasswordError = null);
                        return;
                      }
                      setState(() {
                        _confirmPasswordError =
                            _confirmPasswordController.text == password
                            ? null
                            : 'Confirm password must match password.';
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  // Terms & conditions rich inline text.
                  // Provider only stores boolean; text is static UI.
                  _TermsPrivacyRichText(
                    scheme: scheme,
                    checked: formState.termsAccepted,
                    onChanged: (v) {
                      ref.read(authFormProvider.notifier).setTermsAccepted(v);
                    },
                  ),

                  if (_termsError != null) ...[
                    const SizedBox(height: 8),
                    Text(_termsError!, style: TextStyle(color: scheme.error)),
                  ],

                  const SizedBox(height: 20),

                  PrimaryAuthButton(
                    label: 'Create Account',
                    enabled: true,
                    onPressed: () {
                      if (!_validate(termsAccepted: formState.termsAccepted)) {
                        return;
                      }
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
            );

            // Desktop composition: editorial quote panel (left) + right archival visual composition.
            // No external images: build with gradients/overlays.
            Widget desktop = Stack(
              children: [
                // Left quote panel
                Positioned(
                  left: 0,
                  bottom: 160,
                  child: Opacity(
                    opacity: 0.55,
                    child: Container(
                      width: 280,
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: scheme.primary.withValues(alpha: 0.2),
                            width: 2,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '"History is not a burden on the memory, but an illumination of the soul."',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: scheme.primary.withValues(alpha: 0.6),
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Lord Acton',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Right archival composition
                Positioned.fill(
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: 0.10,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: constraints.maxWidth * 0.22,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                scheme.primary.withValues(alpha: 0.35),
                                scheme.surface.withValues(alpha: 1),
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(32),
                              bottomLeft: Radius.circular(32),
                            ),
                          ),
                          child: CustomPaint(
                            painter: _DustMotesPainter(color: scheme.primary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Center content
                Align(
                  alignment: Alignment.center,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [header, card, const SizedBox(height: 24)],
                    ),
                  ),
                ),
              ],
            );

            if (isMobile) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [header, card, const SizedBox(height: 24)],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: desktop,
            );
          },
        ),
      ),
    );
  }
}

class _RegisterHeader extends StatelessWidget {
  const _RegisterHeader({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: scheme.primary,
              height: 1.1,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Join our community of historians, storytellers, and archivists preserving India's rich cultural lineage.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordStrengthPanel extends StatelessWidget {
  const _PasswordStrengthPanel({
    required this.scheme,
    required this.password,
    required this.strength,
  });

  final ColorScheme scheme;
  final String password;
  final double strength;

  bool get _hasLower => password.contains(RegExp(r'[a-z]'));
  bool get _hasUpper => password.contains(RegExp(r'[A-Z]'));
  bool get _hasDigit => password.contains(RegExp(r'\d'));
  bool get _hasSpecial => password.contains(RegExp(r'[^A-Za-z0-9]'));
  bool get _hasMinLength => password.length >= 10;

  @override
  Widget build(BuildContext context) {
    final requirements = [
      _StrengthRequirement(text: '10+ characters', ok: _hasMinLength),
      _StrengthRequirement(text: 'Uppercase', ok: _hasUpper),
      _StrengthRequirement(text: 'Lowercase', ok: _hasLower),
      _StrengthRequirement(text: 'Number', ok: _hasDigit),
      _StrengthRequirement(text: 'Symbol', ok: _hasSpecial),
    ];

    final barColor = scheme.primary;
    final barBackground = scheme.outlineVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'Password Strength',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: scheme.onSurfaceVariant,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          height: 10,
          decoration: BoxDecoration(
            color: barBackground,
            borderRadius: BorderRadius.circular(999),
          ),
          child: LayoutBuilder(
            builder: (context, c) => Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: strength,
                  child: Container(
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            ...requirements.map(
              (r) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Icon(
                      r.ok ? Icons.check_circle : Icons.circle,
                      size: 18,
                      color: r.ok
                          ? scheme.primary
                          : scheme.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        r.text,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: r.ok
                              ? scheme.onSurface
                              : scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StrengthRequirement {
  const _StrengthRequirement({required this.text, required this.ok});
  final String text;
  final bool ok;
}

class _TermsPrivacyRichText extends StatelessWidget {
  const _TermsPrivacyRichText({
    required this.scheme,
    required this.checked,
    required this.onChanged,
  });

  final ColorScheme scheme;
  final bool checked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final bodyStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant);

    final linkStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: scheme.primary,
      decoration: TextDecoration.underline,
      decorationThickness: 1.2,
      decorationStyle: TextDecorationStyle.solid,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(value: checked, onChanged: (v) => onChanged(v ?? false)),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: bodyStyle,
                  children: [
                    const TextSpan(text: 'I agree to the '),
                    TextSpan(
                      text: 'Terms & Conditions',
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                    const TextSpan(text: ' of the India Story Project.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DustMotesPainter extends CustomPainter {
  _DustMotesPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(42);
    final paint = Paint()..color = color.withValues(alpha: 0.25);

    for (int i = 0; i < 120; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      final r = 0.5 + rnd.nextDouble() * 1.8;
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
