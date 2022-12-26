import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:timetrackingapp_udemy/app/sign_in/email_sign_in_model.dart';
import 'package:timetrackingapp_udemy/app/sign_in/validators.dart';
import 'package:timetrackingapp_udemy/common_widgets/form_submit_button.dart';
import 'package:timetrackingapp_udemy/common_widgets/show_alert_dialog.dart';
import 'package:timetrackingapp_udemy/common_widgets/show_eception_alert_dialog.dart';
import 'package:timetrackingapp_udemy/services/auth.dart';

class EmailSignInFormStatefull extends StatefulWidget
    with EmailAndPasswordValidartors {
  EmailSignInFormStatefull({super.key});

  @override
  State<EmailSignInFormStatefull> createState() =>
      _EmailSignInFormStatefullState();
}

class _EmailSignInFormStatefullState extends State<EmailSignInFormStatefull> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  EmailSignInFormType _formType = EmailSignInFormType.signin;
  bool _isLoading = false;
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signin
          ? EmailSignInFormType.resgister
          : EmailSignInFormType.signin;
      _submitted = false;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  bool _submitted = false;

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);

      if (_formType == EmailSignInFormType.signin) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final primaryText = _formType == EmailSignInFormType.signin
        ? 'Sign in'
        : 'Create an account';
    final sceondaryText = _formType == EmailSignInFormType.signin
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
    bool sumbitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;
    bool _showEmailErrorText =
        _submitted && !widget.emailValidator.isValid(_email);
    bool _showPasswordErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            controller: _emailController,
            decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'test@test.com',
                errorText:
                    _showEmailErrorText ? widget.invalidEmailErrorText : null,
                enabled: _isLoading == false),
            onChanged: (email) => _updateState(),
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            autocorrect: false,
            obscureText: true,
            textInputAction: TextInputAction.done,
            controller: _passwordController,
            decoration: InputDecoration(
                labelText: 'Password',
                errorText: _showPasswordErrorText
                    ? widget.invalidPasswordErrorText
                    : null,
                enabled: _isLoading == false),
            onChanged: (password) => _updateState(),
            onEditingComplete: sumbitEnabled ? _submit : null,
          ),
          const SizedBox(
            height: 8,
          ),
          FormSubmitButton(
            text: primaryText,
            onPressed: () => sumbitEnabled ? _submit() : null,
            isDisabled: sumbitEnabled,
          ),
          const SizedBox(
            height: 8,
          ),
          TextButton(
            onPressed: !_isLoading ? _toggleFormType : null,
            child: Text(sceondaryText),
          )
        ],
      ),
    );
  }
}
