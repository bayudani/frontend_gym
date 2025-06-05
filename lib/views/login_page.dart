import 'package:flutter/material.dart';
import 'package:gym_app/views/register_page.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController auth = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          ElevatedButton(
            onPressed: () async {
              final user = await auth.login(
                emailController.text,
                passwordController.text,
                context,
              );
              if (user != null) {
                // simpan token atau pindah halaman
                print('Login berhasil: ${user.token}');
              }
            },
            child: Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RegisterPage()),
              );
            },
            child: Text("Belum punya akun? Daftar di sini"),
          ),
        ],
      ),
    );
  }
}
