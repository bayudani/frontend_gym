import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Untuk icon SVG
import 'package:gym_app/views/auth/login_page.dart'; // Import halaman login_page untuk logout
import 'package:gym_app/views/home/home_page.dart'; // Import HomePage untuk navigasi bottom bar
import 'package:gym_app/views/membership/membership_card_page.dart'; // Import halaman MembershipCardPage
import 'package:gym_app/views/membership/membership_card_page.dart'; // Import MembershipCardPage
import 'package:gym_app/widget/custom_bottom_nav_bar.dart';

// Asumsikan ada file konstanta atau utility untuk ikon SVG jika Anda memiliki lebih banyak
// dan ingin mereka terpusat. Untuk saat ini, saya akan menyertakannya di sini.
const _profilePlaceholderLarge = 'assets/images/profile_avatar_large.png'; // Ganti dengan path gambar profil besar Anda

// Style border input field yang sama
const _profileOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.white70), // White border
  borderRadius: BorderRadius.all(Radius.circular(10)), // Slightly less rounded for a modern look
);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Controller untuk inputan user
  final TextEditingController _nameController = TextEditingController(text: 'Nama Pengguna'); // Contoh data
  final TextEditingController _emailController = TextEditingController(text: 'nomor@example.com'); // Contoh data
  
  // Controllers khusus untuk form ubah password
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();

  // State untuk mengontrol tampilan antara menu dan form edit/security
  bool _showEditForm = false; // Jika true, tampilkan form edit Nama & Email
  bool _showSecurityForm = false; // Jika true, tampilkan form ubah password

  // Untuk mengelola indeks item navigasi bawah yang dipilih
  // Note: Berdasarkan CustomBottomNavBar, urutan adalah Home (0), Membership (1), Profile (2), Blog (3).
  // Jadi, untuk ProfilePage, selectedIndex harus 2.
  int _selectedIndex = 3; // Default ke indeks Profile (2)

  void _onItemTapped(int index) {
    // Navigasi ini dipicu dari CustomBottomNavBar
    // Karena navigasi ditangani oleh CustomBottomNavBar, kita hanya perlu update _selectedIndex
    setState(() {
      _selectedIndex = index;
    });
    // Logika navigasi sebenarnya ada di CustomBottomNavBar, jadi tidak perlu Navigator.pushReplacement di sini.
  }

  void _logout() {
    // Logika logout Anda di sini
    // Contoh: clear session/token, lalu navigasi ke halaman login
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()), // Kembali ke login
      (Route<dynamic> route) => false, // Hapus semua route sebelumnya
    );
  }

  void _saveProfileChanges() {
    // Logika untuk menyimpan perubahan nama dan email
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perubahan profil disimpan! (Logika simpan belum diimplementasikan)')),
    );
    setState(() {
      _showEditForm = false; // Kembali ke tampilan menu setelah menyimpan
    });
  }

  void _changePassword() {
    // Logika untuk mengubah password
    if (_newPasswordController.text != _confirmNewPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konfirmasi password tidak cocok!')),
      );
      return;
    }
    // Tambahkan validasi password lama, panggil API ubah password, dll.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password berhasil diubah! (Logika ubah belum diimplementasikan)')),
    );
    setState(() {
      _showSecurityForm = false; // Kembali ke tampilan menu setelah mengubah password
    });
    // Clear password fields
    _oldPasswordController.clear();
    _newPasswordController.clear();
    _confirmNewPasswordController.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Latar belakang utama abu-abu muda
      appBar: AppBar(
        backgroundColor: const Color(0xFFC62828), // Warna MERAH lebih gelap untuk AppBar
        elevation: 0,
        title: Text(
          _showEditForm ? 'Set Profile' : (_showSecurityForm ? 'Security' : 'Akun'), // Ubah judul AppBar berdasarkan tampilan
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white), // Tombol kembali putih
          onPressed: () {
            if (_showEditForm) {
              setState(() {
                _showEditForm = false; // Kembali ke tampilan menu jika di form edit
              });
            } else if (_showSecurityForm) {
              setState(() {
                _showSecurityForm = false; // Kembali ke tampilan menu jika di form security
              });
            } else {
              Navigator.pop(context); // Kembali ke halaman sebelumnya jika di menu utama
            }
          },
        ),
      ),
      body: SingleChildScrollView( // Tambahkan SingleChildScrollView untuk konten agar bisa di-scroll
        child: Column(
          children: [
            // Header Profile (seperti gambar pertama)
            Container(
              // Latar belakang MERAH lebih gelap untuk bagian atas
              color: const Color(0xFFC62828),
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    // Icon profil MERAH lebih gelap
                    child: Icon(Icons.person, size: 40, color: const Color(0xFFC62828)),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _nameController.text, // Nama Pengguna
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _emailController.text, // Email Pengguna
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), // Jarak antara header dan konten
            
            // Konten: Menu, Form Edit, atau Form Security
            Visibility(
              visible: !_showEditForm && !_showSecurityForm, // Tampilkan menu jika tidak ada form yang aktif
              child: _buildProfileMenu(),
            ),
            Visibility(
              visible: _showEditForm, // Tampilkan form edit jika _showEditForm true
              child: _buildEditForm(),
            ),
            Visibility(
              visible: _showSecurityForm, // Tampilkan form security jika _showSecurityForm true
              child: _buildSecurityForm(),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar menggunakan widget terpisah
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // Widget untuk daftar menu profil (tampilan awal)
  Widget _buildProfileMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.edit,
            title: 'Ubah Akun',
            onTap: () {
              setState(() {
                _showEditForm = true; // Beralih ke tampilan form edit
                _showSecurityForm = false; // Pastikan form security tidak tampil
              });
            },
          ),
          const Divider(color: Colors.grey), // Garis pemisah
          _buildMenuItem(
            icon: Icons.security, // Mengubah ikon
            title: 'Security', // Mengubah teks dari "Prosedur Pelaporan"
            onTap: () {
              setState(() {
                _showSecurityForm = true; // Beralih ke tampilan form security
                _showEditForm = false; // Pastikan form edit tidak tampil
              });
            },
          ),
          const Divider(color: Colors.grey),
          _buildMenuItem(
            icon: Icons.card_membership, // Mengubah ikon menjadi kartu membership
            title: 'Kartu Membership', // Mengubah teks dari "Tentang Aplikasi"
            onTap: () {
              // Navigasi langsung ke MembershipCardPage menggunakan Navigator.push
              // Ini membuka halaman kartu keanggotaan di atas stack navigasi saat ini
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MembershipCardPage()),
              );
            },
          ),
          const Divider(color: Colors.grey),
          _buildMenuItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  // Widget untuk item menu
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      // Icon berwarna MERAH lebih gelap
      leading: Icon(icon, color: const Color(0xFFC62828)),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black87, fontSize: 16), // Teks hitam
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: onTap,
    );
  }

  // Widget untuk form edit profil (tampilan ubah Nama dan Email)
  Widget _buildEditForm() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage Account',
            style: TextStyle(
              color: Colors.black, // Warna teks hitam
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildProfileFormField(
            controller: _nameController,
            hintText: 'Jhon doe',
            labelText: 'Name',
            readOnly: false, // Bisa diedit
          ),
          const SizedBox(height: 20),
          _buildProfileFormField(
            controller: _emailController,
            hintText: 'Jhon@gmail.com',
            labelText: 'Email',
            keyboardType: TextInputType.emailAddress,
            readOnly: false, // Email bisa diedit di sini
          ),
          const SizedBox(height: 40), // Jarak sebelum tombol
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveProfileChanges, // Memanggil fungsi save profile changes
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
    );
  }

  // Widget baru untuk form ubah password (Security)
  Widget _buildSecurityForm() {
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
            controller: _oldPasswordController,
            hintText: 'Enter old password',
            labelText: 'Old Password',
            obscureText: true,
          ),
          const SizedBox(height: 20),
          _buildProfileFormField(
            controller: _newPasswordController,
            hintText: 'Enter new password',
            labelText: 'New Password',
            obscureText: true,
          ),
          const SizedBox(height: 20),
          _buildProfileFormField(
            controller: _confirmNewPasswordController,
            hintText: 'Confirm new password',
            labelText: 'Confirm New Password',
            obscureText: true,
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _changePassword, // Memanggil fungsi ubah password
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

  // Helper widget untuk TextFormField di halaman profil
  Widget _buildProfileFormField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false, // Properti baru untuk read-only
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      readOnly: readOnly, // Menggunakan properti readOnly
      style: const TextStyle(color: Colors.black87), // Input text color
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: const TextStyle(color: Color(0xFF757575)), // Warna hint sesuai gambar
        labelStyle: const TextStyle(color: Colors.black87), // Warna label sesuai gambar
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        border: _profileOutlineInputBorder,
        enabledBorder: _profileOutlineInputBorder.copyWith(
          borderSide: const BorderSide(color: Color(0xFF757575)), // Border abu-abu
        ),
        focusedBorder: _profileOutlineInputBorder.copyWith(
          borderSide: const BorderSide(color: Color(0xFFC62828)), // MERAH lebih gelap focus border
        ),
        fillColor: Colors.white, // Background color for the input field
        filled: true,
      ),
    );
  }
}
