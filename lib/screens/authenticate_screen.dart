import 'package:flutter/material.dart';

class AuthenticateScreen extends StatefulWidget {
  const AuthenticateScreen({super.key});

  @override
  State<AuthenticateScreen> createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  bool _loginStatus = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Google Drive Test"),
        ),
        body: _createBody(context),
      ),
    );
  }

  Widget _createBody(BuildContext context) {
    final signIn = ElevatedButton(
      onPressed: () {
        _signIn();
      },
      child: Text("Sing in"),
    );
    final signOut = ElevatedButton(
      onPressed: () {
        _signOut();
      },
      child: Text("Sing out"),
    );
    final uploadToHidden = ElevatedButton(
      onPressed: () {
        _uploadToHidden();
      },
      child: Text("Upload to app folder (hidden)"),
    );
    final uploadToNormal = ElevatedButton(
      onPressed: () {
        _uploadToNormal();
      },
      child: Text("Upload to normal folder"),
    );
    final showList = ElevatedButton(
      onPressed: () {
        _showList();
      },
      child: Text("Show the data list"),
    );

    return Column(
      children: [
        Center(child: Text("Sign in status: ${_loginStatus ? "In" : "Out"}")),
        Center(child: signIn),
        Center(child: signOut),
        Divider(),
        Center(child: uploadToHidden),
        Center(child: uploadToNormal),
        Center(child: showList),
      ],
    );
  }

  _signIn() {}

  _signOut() {}

  _uploadToHidden() {}

  _uploadToNormal() {}
  _showList() {}
}
