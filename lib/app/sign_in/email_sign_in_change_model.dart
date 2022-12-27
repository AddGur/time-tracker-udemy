import 'package:flutter/cupertino.dart';
import 'package:timetrackingapp_udemy/app/sign_in/email_sign_in_model.dart';
import 'package:timetrackingapp_udemy/app/sign_in/validators.dart';
import 'package:timetrackingapp_udemy/services/auth.dart';

class EmailSignInChangeModel with EmailAndPasswordValidartors, ChangeNotifier {
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;
  final AuthBase auth;
  EmailSignInChangeModel(
      {this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signin,
      this.isLoading = false,
      this.submitted = false,
      required this.auth});

  void toggleFormType() {
    final formType = this.formType == EmailSignInFormType.signin
        ? EmailSignInFormType.resgister
        : EmailSignInFormType.signin;
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (formType == EmailSignInFormType.signin) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
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
