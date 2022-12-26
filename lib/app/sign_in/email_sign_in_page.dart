import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:timetrackingapp_udemy/app/sign_in/email_sign_in_form.dart';
import 'package:timetrackingapp_udemy/app/sign_in/email_sing_in_form_bloc_based.dart';
import 'package:timetrackingapp_udemy/services/auth.dart';

class EmailSignInPage extends StatelessWidget {
  const EmailSignInPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Sign in')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInFormBlocBased.create(context),
          ),
        ),
      ),
    );
  }
}
