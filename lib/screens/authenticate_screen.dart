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
              onPressed: authProvider.signIn,
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


//
//
// class AuthenticateScreen extends StatefulWidget {
//
//   AuthenticateScreen({super.key});
//   @override
//   State<AuthenticateScreen> createState() => _AuthenticateScreenState();
// }
//
// class _AuthenticateScreenState extends State<AuthenticateScreen> {
//   GoogleSignInAccount? _currentUser;
//   String _contactText = "";
//   bool _isAuthorized = false; // has granted permissions?
//
//   bool _loginStatus = false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     debugPrint("initState - invoked");
//     widget.googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) async {
//       bool isAuthorized = account != null;
//
//       setState(() {
//         _currentUser = account;
//         _isAuthorized = isAuthorized;
//       });
//       if (isAuthorized) {
//         debugPrint("isAuthorized: True");
//         unawaited(_handleGetContact(account!));
//       }
//     });
//   }
//


//   Widget _createBody(BuildContext context) {
//     final signIn = ElevatedButton(
//       onPressed: () {
//         _signIn();
//       },
//       child: Text("Sing in"),
//     );
//     final signOut = ElevatedButton(
//       onPressed: () {
//         _signOut();
//       },
//       child: Text("Sing out"),
//     );
//     final uploadToHidden = ElevatedButton(
//       onPressed: () {
//         _uploadToHidden();
//       },
//       child: Text("Upload to app folder (hidden)"),
//     );
//     final uploadToNormal = ElevatedButton(
//       onPressed: () {
//         _uploadToNormal();
//       },
//       child: Text("Upload to normal folder"),
//     );
//     final showList = ElevatedButton(
//       onPressed: () {
//         _showList();
//       },
//       child: Text("Show the data list"),
//     );
//
//     return Column(
//       children: [
//         Center(child: Text("Sign in status: ${_loginStatus ? "In" : "Out"}")),
//         Center(child: signIn),
//         Center(child: signOut),
//         Divider(),
//         Center(child: uploadToHidden),
//         Center(child: uploadToNormal),
//         Center(child: showList),
//       ],
//     );
//   }
//
//   Future<void> _signIn() async {
//     final googleUser = await widget.googleSignIn.signIn();
//
//     try {
//       if (googleUser != null) {
//         //final googleAuth = await googleUser.authentication;
//         // final credential = GoogleAuthProvider.credential(
//         //   accessToken: googleAuth.accessToken,
//         //   idToken: googleAuth.idToken,
//         // );
//         // final UserCredential loginUser = await FirebaseAuth.instance.signInWithCredential(credential);
//
//         // assert(loginUser.user?.uid == FirebaseAuth.instance.currentUser?.uid);
//         // print("Sign in");
//         // setState(() {
//         //   _loginStatus = true;
//         // });
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
//
// }




class TitelWidget extends StatelessWidget {
  const TitelWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(minWidth: 80),
        decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 1)),
        child: const Text(
          "Auth Screen",
          style: TextStyle(color: Colors.white),
        ));
  }
}
