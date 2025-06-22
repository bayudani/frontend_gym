import 'package:flutter/material.dart';
import 'package:gym_app/views/membership/membership_card_page.dart';

class ProfileMenu extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onSecurity;
  final VoidCallback onLogout;

  const ProfileMenu({
    super.key,
    required this.onEditProfile,
    required this.onSecurity,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.edit,
            title: 'Ubah Akun',
            onTap: onEditProfile,
          ),
          const Divider(color: Colors.grey),
          _buildMenuItem(
            icon: Icons.security,
            title: 'Keamanan',
            onTap: onSecurity,
          ),
          const Divider(color: Colors.grey),
          _buildMenuItem(
            icon: Icons.card_membership,
            title: 'Member Area',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MembershipCardPage(),
                ),
              );
            },
          ),
          const Divider(color: Colors.grey),
          _buildMenuItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: onLogout,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFC62828)),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
        size: 16,
      ),
      onTap: onTap,
    );
  }
}