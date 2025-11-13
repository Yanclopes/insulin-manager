import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 

import 'package:insulinmanager/features/patient_list_page.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final Color corPrimaria = Colors.teal;
    
    return MaterialApp(
      title: 'SBD-Assist',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: corPrimaria,
          brightness: Brightness.light,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: corPrimaria,
          foregroundColor: Colors.white,
          elevation: 2,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: corPrimaria,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
          titleLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
          bodyMedium: TextStyle(fontSize: 14.0),
        ),
      ),
      
      home: const PatientListPage(),
    );
  }
}