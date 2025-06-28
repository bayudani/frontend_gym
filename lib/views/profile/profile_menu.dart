import 'package:flutter/material.dart';
// Import halaman-halaman sub-menu yang baru
import 'package:gym_app/views/profile/member_card_menu_item.dart';
import 'package:gym_app/views/profile/attendance_history_menu_item.dart';

// Hapus impor MembershipCardPage dan AttendanceHistoryPage dari sini
// karena sekarang diimpor langsung oleh widget item menu mereka

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

  // Helper Widget untuk item menu utama profil
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

  // Metode untuk menampilkan menu Member Area
  void _showMemberAreaMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Latar belakang transparan
      builder: (BuildContext bc) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.black, // Latar belakang hitam untuk sheet
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Sudut membulat di atas
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Mengambil ruang seminimal mungkin
            children: <Widget>[
              // Handle (garis) di bagian atas sheet
              Container(
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(bottom: 15),
              ),
              // Memanggil widget-widget item menu yang baru
              const MemberCardMenuItem(), // Menggunakan widget terpisah
              const Divider(color: Colors.grey),
              const AttendanceHistoryMenuItem(), // Menggunakan widget terpisah
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
            icon: Icons.card_membership, // Ikon untuk Member Area
            title: 'Member Area', // Mengubah teks
            onTap: () => _showMemberAreaMenu(context), // Memanggil metode untuk menampilkan submenu
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
}
