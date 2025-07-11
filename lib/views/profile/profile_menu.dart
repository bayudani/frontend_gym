import 'package:flutter/material.dart';
import 'package:gym_app/views/membership/membership.dart'; // <-- Import halaman membership
import 'package:gym_app/views/profile/member_card_menu_item.dart';
import 'package:gym_app/views/profile/attendance_history_menu_item.dart';

class ProfileMenu extends StatelessWidget {
  final bool isMemberActive; // Untuk menampung status member dari luar
  final VoidCallback onEditProfile;
  final VoidCallback onSecurity;
  final VoidCallback onLogout;

  const ProfileMenu({
    super.key,
    required this.isMemberActive, // Wajib diisi saat memanggil widget ini
    required this.onEditProfile,
    required this.onSecurity,
    required this.onLogout,
  });

  // Helper Widget untuk membuat item menu, sekarang dengan logika enabled/disabled
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool enabled = true, // Secara default, menu aktif
  }) {
    // Warna akan berubah jadi abu-abu jika menu tidak enabled
    final Color iconColor = enabled ? const Color(0xFFC62828) : Colors.grey;
    final Color textColor = enabled ? Colors.black87 : Colors.grey;

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        // Panah juga ikut meredup jika tidak aktif
        color: enabled ? Colors.grey : Colors.grey.withOpacity(0.5),
        size: 16,
      ),
      onTap: onTap,
      enabled: enabled, // Properti bawaan ListTile untuk handle interaksi
    );
  }

  // Metode untuk menampilkan submenu Member Area
  void _showMemberAreaMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Latar belakang transparan
      builder: (BuildContext bc) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.black, // Latar belakang hitam untuk sheet
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
              // Item-item di dalam submenu
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
          
          // --- INI BAGIAN UTAMA YANG BERUBAH ---
          // Logika untuk menampilkan menu "Member Area" secara kondisional
          _buildMenuItem(
            icon: Icons.card_membership,
            title: 'Member Area',
            enabled: isMemberActive, // Status aktif/tidaknya menu
            onTap: () {
              // Aksi saat di-klik juga kondisional
              if (isMemberActive) {
                // Jika member, buka submenu
                _showMemberAreaMenu(context);
              } else {
                // Jika bukan member, arahkan ke halaman pembelian membership
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MembershipPage()),
                );
              }
            },
          ),
          // --- AKHIR DARI PERUBAHAN ---
          
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