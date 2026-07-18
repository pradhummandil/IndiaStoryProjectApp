import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/auth_form_providers.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_password_input.dart';
import '../widgets/primary_auth_button.dart';
import '../widgets/auth_link_button.dart';
import '../widgets/auth_card.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validate() {
    final email = _emailController.text.trim();
    final pass = _passwordController.text;

    setState(() {
      _emailError = email.isEmpty
          ? 'Email is required.'
          : (!RegExp(r'^\\S+@\\S+\\.\\S+$').hasMatch(email)
                ? 'Enter a valid email.'
                : null);
      _passwordError = pass.isEmpty ? 'Password is required.' : null;
    });

    return _emailError == null && _passwordError == null;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final formState = ref.watch(authFormProvider);

    // Keep controllers in sync with provider (UI-only).
    _emailController.value = _emailController.value.copyWith(
      text: formState.email,
    );
    _passwordController.value = _passwordController.value.copyWith(
      text: formState.password,
    );

    final labelUpper = Theme.of(context).textTheme.labelLarge?.copyWith(
      color: scheme.onSurfaceVariant,
      letterSpacing: 2,
    );

    final isDesktop = MediaQuery.of(context).size.width >= 900;

    Widget leftEditorialPanel = Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text('Archival Entry', style: labelUpper),
          const SizedBox(height: 10),
          Text(
            'Welcome Back, Scholar',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w700,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 14),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              'Continue your journey through the tapestry of India\'s history. Access the digital archives, preserved manuscripts, and the collective wisdom of centuries.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.55,
              ),
            ),
          ),
          const SizedBox(height: 22),
          _HeroImagePanel(scheme: scheme),
        ],
      ),
    );

    Widget formPanel = AuthCard(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Access Portal',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: scheme.onSurface),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 48,
                        height: 6,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: scheme.primary,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            AuthTextField(
              label: 'Email Address',
              hintText: 'scholar@isp.org',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              errorText: _emailError,
              onChanged: (v) => ref.read(authFormProvider.notifier).setEmail(v),
              prefixIcon: Icon(
                Icons.mail_outline,
                color: scheme.outlineVariant,
              ),
            ),
            const SizedBox(height: 16),
            AuthPasswordInput(
              label: 'Password',
              hintText: '••••••••',
              controller: _passwordController,
              errorText: _passwordError,
              onChanged: (v) =>
                  ref.read(authFormProvider.notifier).setPassword(v),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: scheme.outlineVariant,
              ),
              trailingWidget: AuthLinkButton(
                label: 'Forgot?',
                onPressed: () => context.go('/forgot-password'),
              ),
            ),
            const SizedBox(height: 18),
            PrimaryAuthButton(
              label: 'SIGN IN',
              enabled: true,
              onPressed: () {
                if (!_validate()) return;
                context.go('/otp');
              },
            ),
            const SizedBox(height: 20),
            _ContinueDivider(scheme: scheme),
            const SizedBox(height: 20),
            _SocialRow(scheme: scheme),
            const SizedBox(height: 20),
            _RegisterRow(
              scheme: scheme,
              onRegister: () => context.go('/register'),
            ),
            const SizedBox(height: 6),
            _FooterLinks(scheme: scheme),
          ],
        ),
      ),
    );

    Widget content;
    if (isDesktop) {
      content = SizedBox(
        height: double.infinity,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: leftEditorialPanel),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: formPanel,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // Mobile/tablet: keep editorial on top, card below.
      content = SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          children: [
            _HeroImagePanel(scheme: scheme, compact: true),
            const SizedBox(height: 22),
            formPanel,
          ],
        ),
      );
    }

    return AuthScaffold(
      showBrandInHeader: false,
      title: null,
      subtitle: null,
      appBarHeight: 0,
      child: content,
    );
  }
}

class _HeroImagePanel extends StatelessWidget {
  const _HeroImagePanel({required this.scheme, this.compact = false});

  final ColorScheme scheme;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    // Offline replacement for the editorial photo: warm paper gradient + subtle shadow.
    final height = compact ? 220.0 : 250.0;

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.9)),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 4),
          ),
        ],
        image: DecorationImage(
          // Local placeholder: use a gradient as "image" layer via overlay containers.
          image: const AssetImage(''),
          fit: BoxFit.cover,
          onError: (_, __) => null,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    scheme.primaryContainer.withValues(alpha: 0.10),
                    scheme.surface.withValues(alpha: 1),
                    scheme.primaryContainer.withValues(alpha: 0.06),
                  ],
                ),
              ),
            ),
          ),
          // Jali-like rays (stylized)
          Positioned.fill(
            child: CustomPaint(
              painter: _JaliRayPainter(
                color: scheme.primaryContainer.withValues(alpha: 0.18),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const RadialGradient(
                  center: Alignment(0.2, -0.3),
                  radius: 0.9,
                  colors: [Color(0xFFFFF0D0), Color(0x00FFF0D0)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JaliRayPainter extends CustomPainter {
  _JaliRayPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    final step = size.width / 10;
    // Simple crossing rays.
    for (int i = -2; i < 12; i++) {
      final x = i * step / 2;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height * 0.5, size.height),
        paint,
      );
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height * 0.5, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _JaliRayPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _ContinueDivider extends StatelessWidget {
  const _ContinueDivider({required this.scheme});
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Divider(
              height: 1,
              thickness: 1,
              color: scheme.outlineVariant,
            ),
          ),
        ),
        Center(
          child: DecoratedBox(
            decoration: BoxDecoration(color: scheme.surfaceContainerHighest),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                'or continue with',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialRow extends StatelessWidget {
  const _SocialRow({required this.scheme});
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.1,
      children: [
        _FakeSocialButton(label: 'GOOGLE', scheme: scheme),
        _FakeSocialButton(label: 'APPLE', scheme: scheme),
      ],
    );
  }
}

class _FakeSocialButton extends StatelessWidget {
  const _FakeSocialButton({required this.label, required this.scheme});
  final String label;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        foregroundColor: scheme.onSurfaceVariant,
        side: BorderSide(color: scheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {},
      icon: Icon(
        Icons.circle_outlined,
        size: 18,
        color: scheme.onSurfaceVariant,
      ),
      label: Text(label, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}

class _RegisterRow extends StatelessWidget {
  const _RegisterRow({required this.scheme, required this.onRegister});
  final ColorScheme scheme;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'New to the Project? ',
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
    );
  }
}

class _FooterLinks extends StatelessWidget {
  const _FooterLinks({required this.scheme});
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Wrap(
        spacing: 10,
        alignment: WrapAlignment.center,
        children: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Privacy Policy',
              style: TextStyle(color: scheme.primary),
            ),
          ),
          const Text('•'),
          TextButton(
            onPressed: () {},
            child: Text(
              'Terms of Access',
              style: TextStyle(color: scheme.primary),
            ),
          ),
          const Text('•'),
          TextButton(
            onPressed: () {},
            child: Text('Archives', style: TextStyle(color: scheme.primary)),
          ),
        ],
      ),
    );
  }
}
