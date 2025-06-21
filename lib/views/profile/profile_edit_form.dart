// lib/views/profile/profile_edit_form.dart

import 'package:flutter/material.dart';
import 'package:gym_app/models/user_models.dart';

class ProfileEditForm extends StatefulWidget {
  final User userProfile;
  final Function(String newName, String newEmail) onSave;

  const ProfileEditForm({
    super.key,
    required this.userProfile,
    required this.onSave,
  });


  @override
  State<ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userProfile.name);
    _emailController = TextEditingController(text: widget.userProfile.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage Account',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildProfileFormField(
              controller: _nameController,
              labelText: 'Name',
              hintText: 'Enter your name', // <-- TAMBAHKAN hintText YANG HILANG
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name cannot be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildProfileFormField(
              controller: _emailController,
              labelText: 'Email',
              hintText: 'Enter your email', // <-- TAMBAHKAN hintText YANG HILANG
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || !RegExp(r".+@.+\..+").hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSave(
                      _nameController.text.trim(),
                      _emailController.text.trim(),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Simpan perubahan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- DEFINISI FUNGSI HELPER YANG DIPERBAIKI ---
  Widget _buildProfileFormField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    String? Function(String?)? validator, // <-- TERIMA FUNGSI VALIDATOR DI SINI
  }) {
    const profileOutlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white70),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    );

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      readOnly: readOnly,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: const TextStyle(color: Color(0xFF757575)),
        labelStyle: const TextStyle(color: Colors.black87),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        border: profileOutlineInputBorder,
        enabledBorder: profileOutlineInputBorder.copyWith(
          borderSide: const BorderSide(color: Color(0xFF757575)),
        ),
        focusedBorder: profileOutlineInputBorder.copyWith(
          borderSide: const BorderSide(color: Color(0xFFC62828)),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
      validator: validator, // <-- OPER validator-NYA KE SINI
    );
  }
}