import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetrackingapp_udemy/app/sign_in/email_sign_in_bloc.dart';
import 'package:timetrackingapp_udemy/app/sign_in/email_sign_in_model.dart';
import 'package:timetrackingapp_udemy/app/sign_in/validators.dart';
import 'package:timetrackingapp_udemy/common_widgets/form_submit_button.dart';
import 'package:timetrackingapp_udemy/common_widgets/show_eception_alert_dialog.dart';
import 'package:timetrackingapp_udemy/services/auth.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  final EmailSignInBloc bloc;
  EmailSignInFormBlocBased({super.key, required this.bloc});

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignInFormBlocBased(
          bloc: bloc,
        ),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  State<EmailSignInFormBlocBased> createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

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
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
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
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel model = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildChidlren(model),
            ),
          );
        });
  }

  List<Widget> _buildChidlren(EmailSignInModel model) {
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
        onChanged: widget.bloc.updateEmail,
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
        onChanged: widget.bloc.updatePassword,
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
