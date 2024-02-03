import 'package:dispensary/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: true);
    GoogleSignInAccount? user = authProvider.currentUser;
    if (user != null) {
      return GoogleUserCircleAvatar(
        identity: user,
      );
    } else {
      return IconButton(
        icon: const Icon(
          color: Colors.white,
          Icons.account_circle,
          size: 35,
        ),
        onPressed: () async {
          await authProvider.signIn();
        },
      );
    }
  }
}
