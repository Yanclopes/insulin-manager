import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insulinmanager/core/widgets/user_role_dispatcher.dart';
import 'package:insulinmanager/loading_screen.dart';
import 'package:insulinmanager/login_page.dart';

import '../services/auth_service.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }
        if (snapshot.hasData) {
          return const UserRoleDispatcher();
        }
        return const LoginPage();
      },
    );
  }
}