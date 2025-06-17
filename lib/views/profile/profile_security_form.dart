import 'package:flutter/material.dart';

class ProfileSecurityForm extends StatelessWidget {
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmNewPasswordController;
  final VoidCallback onSave;

  const ProfileSecurityForm({
    super.key,
    required this.oldPasswordController,
    required this.newPasswordController,
    required this.confirmNewPasswordController,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Change Password',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildProfileFormField(
            controller: oldPasswordController,
            hintText: 'Enter old password',
            labelText: 'Old Password',
            obscureText: true,
          ),
          const SizedBox(height: 20),
          _buildProfileFormField(
            controller: newPasswordController,
            hintText: 'Enter new password',
            labelText: 'New Password',
            obscureText: true,
          ),
          const SizedBox(height: 20),
          _buildProfileFormField(
            controller: confirmNewPasswordController,
            hintText: 'Confirm new password',
            labelText: 'Confirm New Password',
            obscureText: true,
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSave,
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
                'Simpan Password',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileFormField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
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
    );
  }
}