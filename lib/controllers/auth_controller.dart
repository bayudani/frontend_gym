import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/user_models.dart';
import '../service/api_service.dart';

class AuthController {
 Future<void> register({
  required String name,
  required String email,
  required String password,
  required String passwordConfirmation,
  required BuildContext context,
}) async {
  final res = await ApiService.register(name, email, password, passwordConfirmation);
  if (res.statusCode == 201) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Register berhasil')));
    Navigator.pop(context); // Balik ke login
  } else {
    _showError(context, res.body);
  }
}


  Future<User?> login(String email, String password, BuildContext context) async {
  final res = await ApiService.login(email, password);
  
  if (res.statusCode == 200) {
    final user = User.fromJson(jsonDecode(res.body));

    return user;
  } else {
    _showError(context, res.body);
    return null;
  }
}


  void _showError(BuildContext context, String message) {
    final error = jsonDecode(message)['message'];
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }
}
