import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/profile_controller.dart';
import 'package:gym_app/views/profile/profile_header.dart';
import 'package:gym_app/views/profile/profile_menu.dart';
import 'package:gym_app/views/profile/profile_edit_form.dart';
import 'package:gym_app/views/profile/profile_security_form.dart';
import 'package:gym_app/widget/custom_bottom_nav_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // === PERUBAHAN 1: HAPUS SEMUA TEXTEDITINGCONTROLLER DARI SINI ===
  // Mereka akan di-handle oleh widget form-nya masing-masing.
  // bool _isProfileInitialized juga tidak diperlukan lagi.

  // State untuk mengontrol tampilan UI, ini tetap di sini.
  bool _showEditForm = false;
  bool _showSecurityForm = false;
  int _selectedIndex = 3; // Profile index di bottom nav

  @override
  void initState() {
    super.initState();
    // Panggil fetchProfile sekali saat halaman pertama kali dibuka.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // listen: false karena ini hanya trigger, tidak perlu me-rebuild initState.
      context.read<ProfileController>().fetchProfile(context);
    });
  }

  // dispose() sekarang jadi kosong karena controller sudah pindah.
  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Kita tetap pakai Consumer untuk mendapatkan update dari ProfileController
    return Consumer<ProfileController>(
      builder: (context, controller, child) {
        // === PERUBAHAN 2: HAPUS LOGIKA SINKRONISASI CONTROLLER DARI SINI ===
        // Build method sekarang jadi jauh lebih bersih.
        
        return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            backgroundColor: const Color(0xFFC62828),
            elevation: 0,
            title: Text(
              _showEditForm
                  ? 'Set Profile'
                  : (_showSecurityForm ? 'Security' : 'Akun'),
              style: const TextStyle(color: Colors.white),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () {
                if (_showEditForm || _showSecurityForm) {
                  setState(() {
                    _showEditForm = false;
                    _showSecurityForm = false;
                  });
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeader(
                  userProfile: controller.userProfile,
                  isLoading: controller.isLoading,
                ),
                const SizedBox(height: 10),

                // --- Tampilan Menu Utama ---
                Visibility(
                  visible: !_showEditForm && !_showSecurityForm,
                  child: ProfileMenu(
                    onEditProfile: () => setState(() => _showEditForm = true),
                    onSecurity: () => setState(() => _showSecurityForm = true),
                    onLogout: () => controller.logout(context),
                  ),
                ),

                // --- Tampilan Form Edit Profile ---
                Visibility(
                  visible: _showEditForm,
                  // Tampilkan form hanya jika userProfile tidak null
                  child: controller.userProfile != null
                      ? ProfileEditForm(
                          // === PERUBAHAN 3: PASSING DATA USER, BUKAN CONTROLLER ===
                          userProfile: controller.userProfile!,
                          onSave: (String newName, String newEmail) {
                            // Panggil fungsi controller untuk menyimpan
                            controller.saveProfileChanges(
                              context: context,
                              name: newName,
                              email: newEmail,
                            );
                            // Kembali ke menu utama
                            setState(() => _showEditForm = false);
                          },
                        )
                      : const SizedBox.shrink(), // atau tampilkan loading
                ),

                // --- Tampilan Form Security ---
                Visibility(
                  visible: _showSecurityForm,
                  child: ProfileSecurityForm(
                    onSave: (String oldPass, String newPass, String confirmPass) {
                      // Panggil fungsi controller untuk menyimpan
                      controller.changePassword(
                        context: context,
                        oldPassword: oldPass,
                        newPassword: newPass,
                        confirmNewPassword: confirmPass,
                      );
                      // Kembali ke menu utama
                      setState(() => _showSecurityForm = false);
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNavBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        );
      },
    );
  }
}