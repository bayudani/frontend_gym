import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/profile_controller.dart';
import 'package:gym_app/views/profile/profile_header.dart';
import 'package:gym_app/views/profile/profile_menu.dart';
import 'package:gym_app/views/profile/profile_edit_form.dart';
import 'package:gym_app/views/profile/profile_security_form.dart';
import 'package:gym_app/widget/custom_bottom_nav_bar.dart';
import 'package:gym_app/views/home/home_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _showEditForm = false;
  bool _showSecurityForm = false;
  int _selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<ProfileController>();
      controller.fetchProfile(context);
      controller.fetchMemberData(context);
    });
  }

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
    return Consumer<ProfileController>(
      builder: (context, controller, child) {
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
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
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
                    isMemberActive: controller.isMemberActive,
                    onEditProfile: () => setState(() => _showEditForm = true),
                    onSecurity: () => setState(() => _showSecurityForm = true),
                    onLogout: () => controller.logout(context),
                  ),
                ),

                //Tampilan Form Edit Profile
                Visibility(
                  visible: _showEditForm,
                  child:
                      controller.userProfile != null
                          ? ProfileEditForm(
                            userProfile: controller.userProfile!,
                            onSave: (String newName, String newEmail) {
                              controller.saveProfileChanges(
                                context: context,
                                name: newName,
                                email: newEmail,
                              );
                              setState(() => _showEditForm = false);
                            },
                          )
                          : const SizedBox.shrink(),
                ),

                //Tampilan Form Security
                Visibility(
                  visible: _showSecurityForm,
                  child: ProfileSecurityForm(
                    onSave: (
                      String oldPass,
                      String newPass,
                      String confirmPass,
                    ) {
                      controller.changePassword(
                        context: context,
                        oldPassword: oldPass,
                        newPassword: newPass,
                        confirmNewPassword: confirmPass,
                      );
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
