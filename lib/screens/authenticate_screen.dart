import 'dart:async';
import 'package:provider/provider.dart';
import 'package:dispensary/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';



class AuthenticateScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Scaffold(
            appBar: AppBar(
              leading: null,
              backgroundColor: Color(0xff6750a4),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),

              title: Container(
              constraints: BoxConstraints(minWidth: 80),
              decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 1)),
              child: Text("Auth Screen", style: TextStyle(color: Colors.white),)),
              actions: [Icon(Icons.login, color:  Colors.white, size: 26), SizedBox(width: 11,),
                Icon(Icons.settings, color:  Colors.white, size: 26), SizedBox(width: 11,)],),
              body:  SingleChildScrollView(child: Column(
                  children: [Text('isAuthenticated ${authProvider.isAuthorised} ')])
                )) ;
        });
  }

  //   Widget _buildBody() {
//     final GoogleSignInAccount? user = _currentUser;
//     if (user != null) {
//       debugPrint("_buildBody inoved- The user is Authenticated");
//       // The user is Authenticated
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           ListTile(
//             leading: GoogleUserCircleAvatar(
//               identity: user,
//             ),
//             title: Text(user.displayName ?? ''),
//             subtitle: Text(user.email),
//           ),
//           const Text('Signed in successfully.'),
//           if (_isAuthorized) ...<Widget>[
//             // The user has Authorized all required scopes
//             Text(_contactText),
//             ElevatedButton(
//               child: const Text('REFRESH'),
//               onPressed: () => _handleGetContact(user),
//             ),
//           ],
//           if (!_isAuthorized) ...<Widget>[
//             // The user has NOT Authorized all required scopes.
//             // (Mobile users may never see this button!)
//             const Text('Additional permissions needed to read your contacts.'),
//             ElevatedButton(
//               onPressed: _handleAuthorizeScopes,
//               child: const Text('REQUEST PERMISSIONS'),
//             ),
//           ],
//           ElevatedButton(
//             onPressed: _handleSignOut,
//             child: const Text('SIGN OUT'),
//           ),
//         ],
//       );
//     } else {
//       // The user is NOT Authenticated
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           const Text('You are not currently signed in.'),
//           // This method is used to separate mobile from web code with conditional exports.
//           // See: src/sign_in_button.dart
//           ElevatedButton(
//             child: Text('Sign in button'),
//             onPressed: _handleSignIn,
//           ),
//         ],
//       );
//     }
//   }
//
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

//   @override
//   Widget build(BuildContext context) {
//     debugPrint("build inoved");
//
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Google Drive Test"),
//         ),
//         body: _buildBody(),
//       ),
//     );
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
//   _signOut() {}
//
//   _uploadToHidden() {}
//
//   _uploadToNormal() {}
//   _showList() {}
//   Future<void> _handleSignIn() async {
//     debugPrint("_handleSignIn- invoked");
//     try {
//       await widget.googleSignIn.signIn();
//       debugPrint("_handleSignIn- completed");
//     } catch (error) {
//       debugPrint("_handleSignIn- error");
//       print(error);
//     }
//   }
//
//   // Calls the People API REST endpoint for the signed-in user to retrieve information.
//   Future<void> _handleGetContact(GoogleSignInAccount user) async {
//     setState(() {
//       _contactText = 'Loading contact info...';
//     });
//   }
//
//   Future<void> _handleSignOut() => widget.googleSignIn.disconnect();
//   Future<void> _handleAuthorizeScopes() async {
//     final bool isAuthorized = await widget.googleSignIn.requestScopes(widget.scopes);
//     // #enddocregion RequestScopes
//     setState(() {
//       _isAuthorized = isAuthorized;
//     });
//     // #docregion RequestScopes
//     if (isAuthorized) {
//       unawaited(_handleGetContact(_currentUser!));
//     }
//     // #enddocregion RequestScopes
//   }
// }
