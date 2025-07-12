import 'package:flutter/material.dart';
import 'package:gym_app/views/membership/membership.dart';
import 'package:gym_app/views/profile/member_card_menu_item.dart';
import 'package:gym_app/views/profile/attendance_history_menu_item.dart';

class ProfileMenu extends StatelessWidget {
  final bool isMemberActive;
  final VoidCallback onEditProfile;
  final VoidCallback onSecurity;
  final VoidCallback onLogout;

  const ProfileMenu({
    super.key,
    required this.isMemberActive,
    required this.onEditProfile,
    required this.onSecurity,
    required this.onLogout,
  });

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    final Color iconColor = enabled ? const Color(0xFFC62828) : Colors.grey;
    final Color textColor = enabled ? Colors.black87 : Colors.grey;

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor, fontSize: 16)),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: enabled ? Colors.grey : Colors.grey.withOpacity(0.5),
        size: 16,
      ),
      onTap: onTap,
      enabled: enabled,
    );
  }

  void _showMemberAreaMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(bottom: 15),
              ),
              const MemberCardMenuItem(),
              const Divider(color: Colors.grey),
              const AttendanceHistoryMenuItem(),
            ],
          ),
        );
      },
    );
  }

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
            title: 'Security',
            onTap: onSecurity,
          ),
          const Divider(color: Colors.grey),

          _buildMenuItem(
            icon: Icons.card_membership,
            title: 'Member Area',
            enabled: isMemberActive,
            onTap: () {
              if (isMemberActive) {
                _showMemberAreaMenu(context);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MembershipPage(),
                  ),
                );
              }
            },
          ),

          const Divider(color: Colors.grey),
          _buildMenuItem(icon: Icons.logout, title: 'Logout', onTap: onLogout),
        ],
      ),
    );
  }
}
