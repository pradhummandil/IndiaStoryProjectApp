import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/auth_scaffold.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AuthScaffold(
      title: 'Check Your Inbox',
      subtitle: null,
      showBrandInHeader: false,
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
              const SizedBox(height: 12),
              Icon(
                Icons.mail_outline,
                size: 64,
                color: scheme.primaryContainer,
              ),
              const SizedBox(height: 16),
              Text(
                'Check Your Inbox',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
              ),
              const SizedBox(height: 8),
              Text(
                'A verification link has been sent to\narnav.sharma@isp.org',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Please click the link in the email to activate your account and start your journey through history.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // visual-only open email
                },
                icon: const Icon(Icons.open_in_new, size: 20),
                label: const Text('OPEN EMAIL APP'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/register'),
                child: const Text('Change Email Address'),
              ),
              const SizedBox(height: 16),
              Divider(color: scheme.outlineVariant),
              const SizedBox(height: 12),
              Text(
                "Didn't receive the email? Check your spam folder or request a resend.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
