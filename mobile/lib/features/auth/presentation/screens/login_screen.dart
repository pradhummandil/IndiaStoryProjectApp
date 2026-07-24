import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/auth_state_provider.dart';
import '../controllers/auth_form_providers.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_password_input.dart';
import '../widgets/primary_auth_button.dart';
import '../widgets/auth_link_button.dart';
import '../widgets/auth_card.dart';
import '../widgets/google_apple_social_button.dart';

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
  bool _isLoading = false;
  bool _isNavigating = false; // Guard against duplicate navigation
  String? _errorMessage;
  bool _isGoogleSigningIn = false;

  static final _emailPattern = RegExp(r'^\S+@\S+\.\S+$');

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
          : (!_emailPattern.hasMatch(email) ? 'Enter a valid email.' : null);
      _passwordError = pass.isEmpty ? 'Password is required.' : null;
    });

    return _emailError == null && _passwordError == null;
  }

  /// Safe navigation guard to prevent duplicate navigations.
  void _navigateToHome() {
    if (_isNavigating || !mounted) return;
    setState(() => _isNavigating = true);
    context.go('/home');
  }

  Future<void> _handleLogin() async {
    if (!_validate() || _isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(authStateProvider.notifier)
          .signInWithEmailPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      if (!mounted) return;

      final authState = ref.read(authStateProvider);
      if (authState.isAuthenticated) {
        _navigateToHome();
      } else if (authState.error != null) {
        setState(() {
          _isLoading = false;
          _errorMessage = authState.error!.replaceFirst('Exception: ', '');
        });
      } else {
        // Still loading or not authenticated — wait briefly then check again
        await Future.delayed(const Duration(milliseconds: 300));
        if (!mounted) return;
        final updatedState = ref.read(authStateProvider);
        if (updatedState.isAuthenticated) {
          _navigateToHome();
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isGoogleSigningIn || _isLoading) return;

    setState(() {
      _isGoogleSigningIn = true;
      _isLoading = true;
      _errorMessage = null;
    });

    developer.log('LoginScreen: Google sign-in button tapped', name: 'AuthUI');

    try {
      await ref.read(authStateProvider.notifier).signInWithGoogle();

      if (!mounted) return;

      final authState = ref.read(authStateProvider);
      if (authState.isAuthenticated) {
        developer.log(
          'LoginScreen: Google sign-in successful, navigating to /home',
          name: 'AuthUI',
        );
        _navigateToHome();
      } else if (authState.error != null) {
        setState(() {
          _isGoogleSigningIn = false;
          _isLoading = false;
          _errorMessage = authState.error!.replaceFirst('Exception: ', '');
        });
      } else {
        // Wait briefly and recheck
        await Future.delayed(const Duration(milliseconds: 300));
        if (!mounted) return;
        final updatedState = ref.read(authStateProvider);
        if (updatedState.isAuthenticated) {
          _navigateToHome();
        } else {
          setState(() {
            _isGoogleSigningIn = false;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isGoogleSigningIn = false;
          _isLoading = false;
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final formState = ref.watch(authFormProvider);

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
              fontWeight: FontWeight.w600,
              height: 0.98,
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Text(
              "Continue your journey through the tapestry of India's history. Access the digital archives, preserved manuscripts, and the collective wisdom of centuries.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.55,
              ),
            ),
          ),
          const SizedBox(height: 32),
          _HeroImagePanel(scheme: scheme, desktop: true),
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
            // Error banner
            if (_errorMessage != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: scheme.errorContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: scheme.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: scheme.error, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: scheme.error),
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() => _errorMessage = null),
                      child: Icon(Icons.close, color: scheme.error, size: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            AuthTextField(
              label: 'Email Address',
              hintText: 'scholar@isp.org',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              errorText: _emailError,
              enabled: !_isLoading,
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
              enabled: !_isLoading,
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
              label: _isLoading && !_isGoogleSigningIn
                  ? 'SIGNING IN...'
                  : 'SIGN IN',
              enabled: !_isLoading,
              onPressed: (_isLoading || _isGoogleSigningIn)
                  ? null
                  : _handleLogin,
              isLoading: _isLoading && !_isGoogleSigningIn,
            ),
            if (_isLoading && _isGoogleSigningIn)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: LinearProgressIndicator(),
              ),
            const SizedBox(height: 20),
            _ContinueDivider(scheme: scheme),
            const SizedBox(height: 20),
            _SocialRow(
              onGoogleTap: _handleGoogleSignIn,
              googleLoading: _isGoogleSigningIn,
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Wrap(
                  spacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    Text(
                      'New to the Project? ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => context.go('/register'),
                      child: Text(
                        'Apply for Access',
                        style: TextStyle(color: scheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            _FooterLinks(scheme: scheme),
          ],
        ),
      ),
    );

    Widget content;
    if (isDesktop) {
      content = Center(
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
      );
    } else {
      content = LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _HeroImagePanel(scheme: scheme, compact: true),
                const SizedBox(height: 22),
                formPanel,
              ],
            ),
          );
        },
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
  const _HeroImagePanel({
    required this.scheme,
    this.compact = false,
    this.desktop = false,
  });

  final ColorScheme scheme;
  final bool compact;
  final bool desktop;

  @override
  Widget build(BuildContext context) {
    final height = compact ? 220.0 : (desktop ? 250.0 : 250.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.9),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              color: Colors.black.withValues(alpha: 0.04),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      scheme.primaryContainer.withValues(alpha: 0.08),
                      const Color(0xFFF8F5EF),
                      scheme.primaryContainer.withValues(alpha: 0.04),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: _PaperTexturePainter(color: scheme.outlineVariant),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    center: Alignment(0.18, -0.35),
                    radius: 1.05,
                    colors: [
                      Color(0xFFFFE6B8),
                      Color(0x00FFE6B8),
                      Color(0x00FFD2A8),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: _JaliRayPainter(
                  color: scheme.primaryContainer.withValues(alpha: 0.22),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0.55, 0.15),
                    radius: 1.1,
                    colors: [
                      const Color(0x00000000),
                      Colors.black.withValues(alpha: 0.05),
                    ],
                  ),
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
  final _seed = 1337;

  double _hash(int x, int y) {
    final n = x * 374761393 + y * 668265263 ^ _seed;
    final nn = (n ^ (n >> 13)) * 1274126177;
    return ((nn ^ (nn >> 16)) & 0xFFFF) / 0xFFFF;
  }

  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 10.0;
    for (double yy = 0; yy < size.height; yy += spacing) {
      for (double xx = 0; xx < size.width; xx += spacing) {
        final r = _hash(xx.toInt(), yy.toInt());
        if (r < 0.55) continue;
        final alpha = 0.025 + (r - 0.55) * 0.06;
        final dot = Paint()
          ..style = PaintingStyle.fill
          ..color = color.withValues(alpha: alpha);
        final rad = 0.6 + r * 0.9;
        canvas.drawCircle(
          Offset(xx + spacing * 0.4, yy + spacing * 0.35),
          rad,
          dot,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PaperTexturePainter oldDelegate) =>
      oldDelegate.color != color;
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
  const _SocialRow({this.onGoogleTap, this.googleLoading = false});
  final VoidCallback? onGoogleTap;
  final bool googleLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GoogleAppleSocialButton(
            label: googleLoading ? 'CONTINUING...' : 'GOOGLE',
            assetPath: 'assets/icons/google.svg',
            isGoogle: true,
            onPressed: onGoogleTap ?? () {},
            isLoading: googleLoading,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GoogleAppleSocialButton(
            label: 'APPLE',
            assetPath: 'assets/icons/apple.svg',
            isGoogle: false,
            onPressed: () {},
          ),
        ),
      ],
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
          const Text('\u2022'),
          TextButton(
            onPressed: () {},
            child: Text(
              'Terms of Access',
              style: TextStyle(color: scheme.primary),
            ),
          ),
          const Text('\u2022'),
          TextButton(
            onPressed: () {},
            child: Text('Archives', style: TextStyle(color: scheme.primary)),
          ),
        ],
      ),
    );
  }
}
