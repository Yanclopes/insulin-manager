import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insulinmanager/core/services/auth_service.dart';
import 'package:insulinmanager/features/doctor/presentation/patient_list_page.dart';

class DoctorHomePage extends StatelessWidget {
  const DoctorHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Painel do Médico"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Sair",
            onPressed: () {
              AuthService().signOut();
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Bem-vindo, Doutor!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (user != null)
              Text("Logado como: ${user.email}"),
            const SizedBox(height: 20),
            ElevatedButton(
             onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PatientListPage()),
                );
              },
              child: const Text("Ver Meus Pacientes"),
            )
          ],
        ),
      ),
    );
  }
}