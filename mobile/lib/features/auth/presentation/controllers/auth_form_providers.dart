import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthFormState {
  const AuthFormState({
    this.email = '',
    this.password = '',
    this.fullName = '',
    this.otp = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.termsAccepted = false,
  });

  final String email;
  final String password;
  final String fullName;
  final String otp;
  final String newPassword;
  final String confirmPassword;
  final bool termsAccepted;

  AuthFormState copyWith({
    String? email,
    String? password,
    String? fullName,
    String? otp,
    String? newPassword,
    String? confirmPassword,
    bool? termsAccepted,
  }) {
    return AuthFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      otp: otp ?? this.otp,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      termsAccepted: termsAccepted ?? this.termsAccepted,
    );
  }
}

class AuthValidationErrors {
  const AuthValidationErrors({
    this.email,
    this.password,
    this.fullName,
    this.otp,
    this.newPassword,
    this.confirmPassword,
    this.termsAccepted,
  });

  final String? email;
  final String? password;
  final String? fullName;
  final String? otp;
  final String? newPassword;
  final String? confirmPassword;
  final String? termsAccepted;

  AuthValidationErrors copyWith({
    String? email,
    bool clearEmail = false,
    String? password,
    bool clearPassword = false,
    String? fullName,
    bool clearFullName = false,
    String? otp,
    bool clearOtp = false,
    String? newPassword,
    bool clearNewPassword = false,
    String? confirmPassword,
    bool clearConfirmPassword = false,
    String? termsAccepted,
    bool clearTermsAccepted = false,
  }) {
    return AuthValidationErrors(
      email: clearEmail ? null : email ?? this.email,
      password: clearPassword ? null : password ?? this.password,
      fullName: clearFullName ? null : fullName ?? this.fullName,
      otp: clearOtp ? null : otp ?? this.otp,
      newPassword: clearNewPassword ? null : newPassword ?? this.newPassword,
      confirmPassword: clearConfirmPassword
          ? null
          : confirmPassword ?? this.confirmPassword,
      termsAccepted: clearTermsAccepted
          ? null
          : termsAccepted ?? this.termsAccepted,
    );
  }
}

class AuthFormStateNotifier extends StateNotifier<AuthFormState> {
  AuthFormStateNotifier() : super(const AuthFormState());

  void setEmail(String v) => state = state.copyWith(email: v);
  void setPassword(String v) => state = state.copyWith(password: v);
  void setFullName(String v) => state = state.copyWith(fullName: v);
  void setOtp(String v) => state = state.copyWith(otp: v);
  void setNewPassword(String v) => state = state.copyWith(newPassword: v);
  void setConfirmPassword(String v) =>
      state = state.copyWith(confirmPassword: v);
  void setTermsAccepted(bool v) => state = state.copyWith(termsAccepted: v);
}

final authFormProvider =
    StateNotifierProvider<AuthFormStateNotifier, AuthFormState>((ref) {
      return AuthFormStateNotifier();
    });
