import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          : (!RegExp(r'^\S+@\S+\.\S+$').hasMatch(email)
                ? 'Enter a valid email.'
                : null);
    });
    return _emailError == null;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final formState = ref.watch(authFormProvider);

    _emailController.value = _emailController.value.copyWith(
      text: formState.email,
    );

    return AuthScaffold(
      title: 'Restore Access',
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
                'Enter your registered email to receive recovery instructions.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              AuthLabeledTextField(
                label: 'Email Address',
                hintText: 'e.g. curator@isp.org',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                errorText: _emailError,
                onChanged: (v) =>
                    ref.read(authFormProvider.notifier).setEmail(v),
              ),
              const SizedBox(height: 20),
              PrimaryAuthButton(
                label: 'Send Recovery Link',
                onPressed: () {
                  if (!_validate()) return;
                  context.go('/otp');
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/login'),
                child: Text(
                  'Back to Login',
                  style: TextStyle(color: scheme.primary),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
