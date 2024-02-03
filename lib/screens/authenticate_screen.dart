import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:dispensary/providers/auth_provider.dart';
import 'package:flutter/material.dart';

class AuthenticateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: null,
          backgroundColor: const Color(0xff6750a4),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
          title: const TitelWidget(),
          actions: appbarActions,
        ),
        body: SingleChildScrollView(child: _buildBody()));
  }

  Widget _buildBody() {
    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      GoogleSignInAccount? user = authProvider.currentUser;
      if (user != null) {
        debugPrint("_buildBody inoved- The user is Authenticated");
        // The user is Authenticated
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ListTile(
              leading: GoogleUserCircleAvatar(
                identity: user,
              ),
              title: Text(user.displayName ?? ''),
              subtitle: Text(user.email),
            ),
            const Text('Signed in successfully.'),
            if (authProvider.isAuthorised) ...<Widget>[
              Text(user.email),
            ],
            if (!authProvider.isAuthorised) ...<Widget>[
              // The user has NOT Authorized all required scopes.
              // (Mobile users may never see this button!)
              const Text('You have to Login'),
            ],
            ElevatedButton(
              onPressed: authProvider.signOut,
              child: const Text('SIGN OUT'),
            ),
          ],
        );
      } else {
        // The user is NOT Authenticated
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text('You are not currently signed in.'),
            // This method is used to separate mobile from web code with conditional exports.
            // See: src/sign_in_button.dart
            ElevatedButton(
              child: const Text('Sign in button'),
                onPressed: () async {
                  bool flag = await authProvider.signIn();
                  if (flag == true) {
                    Navigator.pushReplacementNamed(context, '/');
                  }
                }
            ),
          ],
        );
      }
    });
  }

  List<Widget> get appbarActions {
    return const [
      Icon(Icons.login, color: Colors.white, size: 26),
      SizedBox(
        width: 11,
      ),
      Icon(Icons.settings, color: Colors.white, size: 26),
      SizedBox(
        width: 11,
      )
    ];
  }
}

class TitelWidget extends StatelessWidget {
  const TitelWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AuthProvider authPro = Provider.of<AuthProvider>(context, listen: false);
    bool flag = authPro.isAuthorised;
    String titleText = "Welcome guest!";
    if (authPro != null && authPro.currentUser != null) {
      titleText = 'Hi, ${authPro.currentUser!.displayName!}';
    }
    return Container(
        constraints: const BoxConstraints(minWidth: 80),
        child: Text(
          titleText,
          style: const TextStyle(color: Colors.white),
        ));
  }
}
