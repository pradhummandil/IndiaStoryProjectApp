import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth_form_providers.dart';
import '../widgets/auth_labeled_text_field.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/primary_auth_button.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _newError;
  String? _confirmError;

  bool _validate() {
    final newPass = _newPasswordController.text;
    final confirm = _confirmPasswordController.text;

    setState(() {
      _newError = newPass.isEmpty ? 'New password is required.' : null;
      _confirmError = confirm.isEmpty
          ? 'Confirm password is required.'
          : (confirm != newPass ? 'Passwords do not match.' : null);
    });

    return _newError == null && _confirmError == null;
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final formState = ref.watch(authFormProvider);

    _newPasswordController.value = _newPasswordController.value.copyWith(
      text: formState.newPassword,
    );
    _confirmPasswordController.value = _confirmPasswordController.value
        .copyWith(text: formState.confirmPassword);

    return AuthScaffold(
      title: 'Security Update',
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
                'Update your credentials to ensure your account remains a protected piece of our shared history.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              AuthLabeledTextField(
                label: 'New Password',
                controller: _newPasswordController,
                obscureText: true,
                errorText: _newError,
                onChanged: (v) =>
                    ref.read(authFormProvider.notifier).setNewPassword(v),
                hintText: '••••••••',
              ),
              const SizedBox(height: 16),
              AuthLabeledTextField(
                label: 'Confirm Password',
                controller: _confirmPasswordController,
                obscureText: true,
                errorText: _confirmError,
                onChanged: (v) =>
                    ref.read(authFormProvider.notifier).setConfirmPassword(v),
                hintText: '••••••••',
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainer,
                  border: Border.all(color: scheme.outlineVariant),
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
                    _guideline(scheme, 'At least 12 characters'),
                    _guideline(scheme, 'Include symbols and numbers'),
                    _guideline(scheme, 'Avoid using personal names or dates'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PrimaryAuthButton(
                label: 'Save & Sign In',
                onPressed: () {
                  if (!_validate()) return;
                  context.go('/login');
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Contact Support',
                    style: TextStyle(color: scheme.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _guideline(ColorScheme scheme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 18, color: scheme.primary),
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
}
