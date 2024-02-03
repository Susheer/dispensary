import 'dart:ffi';
import 'dart:ui';

import 'package:dispensary/appConfig.dart';
import 'package:dispensary/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class UserGreet extends StatelessWidget {
  const UserGreet({super.key});

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: true);
    GoogleSignInAccount? user = authProvider.currentUser;
    if (user != null) {
      return Text(
        "We're glad you're back ${authProvider.currentUser!.displayName!?.split(" ")[0]}!",
        style: const TextStyle(fontSize: 19),
      );
    } else {
      return const Text(
        "Hello! Feel free to look around.",
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w400),
      );
    }
  }
}

class UserName extends StatelessWidget {
  const UserName({super.key});

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: true);
    GoogleSignInAccount? user = authProvider.currentUser;
    if (user != null) {
      return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const SizedBox(
          height: 10,
        ),
        GoogleUserCircleAvatar(
          identity: user,
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          '${authProvider.currentUser!.displayName}',
          style: const TextStyle(
            fontSize: 19,
            color: Colors.white,
          ),
        ),
        Text(
          AppConfig.nameOfClinic,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        )
      ]);
    } else {
      return Column(children: [
        IconButton(
          icon: const Icon(
            color: Colors.white,
            Icons.account_circle,
            size: 40,
          ),
          onPressed: () async {
            await authProvider.signIn();
          },
        ),
        const SizedBox(
          height: 4,
        ),
        const Text(
          'Visitor',
          style: TextStyle(
            fontSize: 19,
            color: Colors.white,
          ),
        ),
        Text(
          AppConfig.nameOfClinic,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        )
      ]);
    }
  }
}

/**
 * 
 * 
 * 
 * Row(
                      children: [
                        Icon(
                          Icons.auto_awesome_mosaic,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                  'SAI CLINIC',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
 */
