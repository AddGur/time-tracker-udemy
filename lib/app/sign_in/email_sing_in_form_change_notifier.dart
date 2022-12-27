import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetrackingapp_udemy/app/sign_in/email_sign_in_bloc.dart';
import 'package:timetrackingapp_udemy/app/sign_in/email_sign_in_change_model.dart';
import 'package:timetrackingapp_udemy/app/sign_in/email_sign_in_model.dart';
import 'package:timetrackingapp_udemy/app/sign_in/validators.dart';
import 'package:timetrackingapp_udemy/common_widgets/form_submit_button.dart';
import 'package:timetrackingapp_udemy/common_widgets/show_eception_alert_dialog.dart';
import 'package:timetrackingapp_udemy/services/auth.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  final EmailSignInChangeModel model;
  EmailSignInFormChangeNotifier({super.key, required this.model});

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignInFormChangeNotifier(
          model: model,
        ),
      ),
    );
  }

  @override
  State<EmailSignInFormChangeNotifier> createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  EmailSignInChangeModel get model => widget.model;

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
    widget.model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  Future<void> _submit() async {
    try {
      await widget.model.submit();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChidlren(),
      ),
    );
  }

  List<Widget> _buildChidlren() {
    return [
      TextField(
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        controller: _emailController,
        decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'test@test.com',
            errorText: model.emailErrorText,
            enabled: model.isLoading == false),
        onChanged: model.updateEmail,
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
            errorText: model.passwordErrorText,
            enabled: model.isLoading == false),
        onChanged: model.updatePassword,
        onEditingComplete: model.canSubmit ? _submit : null,
      ),
      const SizedBox(
        height: 8,
      ),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: () => model.canSubmit ? _submit() : null,
        isDisabled: model.canSubmit,
      ),
      const SizedBox(
        height: 8,
      ),
      TextButton(
        onPressed: !model.isLoading ? _toggleFormType : null,
        child: Text(model.secondaryButtonText),
      )
    ];
  }
}
