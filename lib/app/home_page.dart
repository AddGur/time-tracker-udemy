import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetrackingapp_udemy/common_widgets/show_alert_dialog.dart';

import '../services/auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequsetSignOut = await showAlertDialog(context,
        title: 'Logout',
        content: 'Are you sure that you want to logout',
        defaultActionText: 'Logout',
        cancelActionText: 'Cancel');
    if (didRequsetSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          TextButton(
            onPressed: () => _confirmSignOut(context),
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ],
      ),
      body: Center(),
    );
  }
}
