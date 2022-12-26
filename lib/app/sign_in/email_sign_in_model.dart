import 'package:timetrackingapp_udemy/app/sign_in/validators.dart';

enum EmailSignInFormType { signin, resgister }

class EmailSignInModel with EmailAndPasswordValidartors {
  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool submitted;

  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signin,
    this.isLoading = false,
    this.submitted = false,
  });

  EmailSignInModel copyWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }

  String get primaryButtonText {
    return formType == EmailSignInFormType.signin
        ? 'Sign in'
        : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signin
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String? get passwordErrorText {
    bool _showPasswordErrorText =
        submitted && !passwordValidator.isValid(password);
    return _showPasswordErrorText ? invalidPasswordErrorText : null;
  }

  String? get emailErrorText {
    bool _showEmailErrorText = submitted && !passwordValidator.isValid(email);
    return _showEmailErrorText ? invalidEmailErrorText : null;
  }
}
