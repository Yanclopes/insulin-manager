import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insulinmanager/core/models/user_model.dart';
import 'package:insulinmanager/core/services/auth_service.dart';
import 'package:insulinmanager/features/doctor/presentation/doctor_home_page.dart';
import 'package:insulinmanager/features/patient/presentation/patient_home_page.dart';
import 'package:insulinmanager/loading_screen.dart';

class UserRoleDispatcher extends StatelessWidget {
  const UserRoleDispatcher({Key? key}) : super(key: key);

  // Busca os dados do Firestore
  Future<UserModel?> _getUserData(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const LoadingScreen();
    }

    return FutureBuilder<UserModel?>(
      future: _getUserData(currentUser.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          AuthService().signOut(); 
          return Scaffold(
            body: Center(
              child: Text("Erro: Perfil de usuário não encontrado no banco de dados."),
            ),
          );
        }

        final user = snapshot.data!;

        if (user.type == UserType.doctor) {
          return const DoctorHomePage();
        } else {
          return const PatientHomePage();
        }
      },
    );
  }
}