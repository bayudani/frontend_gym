import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  final _authController = AuthController();

  void _handleRegister() {
    _authController.register(
      name: _name.text,
      email: _email.text,
      password: _password.text,
      passwordConfirmation: _confirm.text,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _name, decoration: InputDecoration(labelText: "Nama")),
            TextField(controller: _email, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: _password, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            TextField(controller: _confirm, decoration: InputDecoration(labelText: "Konfirmasi Password"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _handleRegister, child: Text("Daftar")),
          ],
        ),
      ),
    );
  }
}
