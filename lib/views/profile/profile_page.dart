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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();

  bool _showEditForm = false;
  bool _showSecurityForm = false;
  bool _isProfileInitialized = false;

  int _selectedIndex = 3; // Profile index di bottom nav

  @override
  void initState() {
    super.initState();
    // Fetch profile ketika halaman dimuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileController>().fetchProfile(context);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, controller, child) {
        // Update controller hanya sekali setelah data profile berhasil diambil
        if (controller.userProfile != null && !_isProfileInitialized) {
          _nameController.text = controller.userProfile!.name ?? 'Nama Pengguna';
          _emailController.text = controller.userProfile!.email ?? 'nomor@example.com';
          _isProfileInitialized = true;
        }

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
                if (_showEditForm) {
                  setState(() {
                    _showEditForm = false;
                  });
                } else if (_showSecurityForm) {
                  setState(() {
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
                Visibility(
                  visible: !_showEditForm && !_showSecurityForm,
                  child: ProfileMenu(
                    onEditProfile: () {
                      setState(() {
                        _showEditForm = true;
                        _showSecurityForm = false;
                      });
                    },
                    onSecurity: () {
                      setState(() {
                        _showSecurityForm = true;
                        _showEditForm = false;
                      });
                    },
                    onLogout: () => controller.logout(context),
                  ),
                ),
                Visibility(
                  visible: _showEditForm,
                  child: ProfileEditForm(
                    nameController: _nameController,
                    emailController: _emailController,
                    onSave: () {
                      controller.saveProfileChanges(
                        context,
                        _nameController.text,
                        _emailController.text,
                      );
                      setState(() {
                        _showEditForm = false;
                        _isProfileInitialized = false; // Refresh data saat kembali
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: _showSecurityForm,
                  child: ProfileSecurityForm(
                    oldPasswordController: _oldPasswordController,
                    newPasswordController: _newPasswordController,
                    confirmNewPasswordController: _confirmNewPasswordController,
                    onSave: () {
                      controller.changePassword(
                        context,
                        _oldPasswordController.text,
                        _newPasswordController.text,
                        _confirmNewPasswordController.text,
                      );
                      setState(() {
                        _showSecurityForm = false;
                      });
                      _oldPasswordController.clear();
                      _newPasswordController.clear();
                      _confirmNewPasswordController.clear();
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
