import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insulinmanager/core/models/user_model.dart';
import 'package:insulinmanager/core/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _authService = AuthService();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  UserType _selectedUserType = UserType.patient; 

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'As senhas não coincidem';
      });
      return;
    }

    if (_nameController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, insira seu nome completo';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.signUp(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        userType: _selectedUserType,
      );
      
      if (!mounted) return;
      
      Navigator.pop(context); 

    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? "Ocorreu um erro";
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Ocorreu um erro desconhecido: $e";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome Completo'),
              keyboardType: TextInputType.name,
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirmar Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            /**
             * adicionar futuramente
             * 
             * Text("Você é:", style: Theme.of(context).textTheme.titleMedium),
            RadioListTile<UserType>(
              title: const Text("Paciente"),
              value: UserType.patient,
              groupValue: _selectedUserType,
              onChanged: (value) {
                if (value != null) setState(() => _selectedUserType = value);
              },
            ),
            RadioListTile<UserType>(
              title: const Text("Médico"),
              value: UserType.doctor,
              groupValue: _selectedUserType,
              onChanged: (value) {
                if (value != null) setState(() => _selectedUserType = value);
              },
            ),
             */

            const SizedBox(height: 20),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _register,
                    child: const Text('Criar Conta'),
                  ),
          ],
        ),
      ),
    );
  }
}