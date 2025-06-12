import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';   
// Kalo mau navigasi balik ke SignInScreen secara eksplisit, uncomment dan sesuaikan path
// import 'sign_in_screen.dart';

// === DEFINISI ICON SVG & STYLE BORDER ===
// Kamu bisa pindahin ini ke file constants.dart biar lebih rapi

// Icon buat field nama (contoh)
const userIcon = '''<svg width="16" height="18" viewBox="0 0 16 18" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M8 9C10.2091 9 12 7.20914 12 5C12 2.79086 10.2091 1 8 1C5.79086 1 4 2.79086 4 5C4 7.20914 5.79086 9 8 9Z" stroke="#757575" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M15 17C15 13.134 11.866 10 8 10C4.13401 10 1 13.134 1 17" stroke="#757575" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

// Icon mail & lock dari halaman login
const mailIcon = '''<svg width="18" height="13" viewBox="0 0 18 13" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M15.3576 3.39368C15.5215 3.62375 15.4697 3.94447 15.2404 4.10954L9.80876 8.03862C9.57272 8.21053 9.29421 8.29605 9.01656 8.29605C8.7406 8.29605 8.4638 8.21138 8.22775 8.04204L2.76041 4.11039C2.53201 3.94618 2.47851 3.62546 2.64154 3.39454C2.80542 3.16362 3.12383 3.10974 3.35223 3.27566L8.81872 7.20645C8.93674 7.29112 9.09552 7.29197 9.2144 7.20559L14.6469 3.27651C14.8753 3.10974 15.1937 3.16447 15.3576 3.39368ZM16.9819 10.7763C16.9819 11.4366 16.4479 11.9745 15.7932 11.9745H2.20765C1.55215 11.9745 1.01892 11.4366 1.01892 10.7763V2.22368C1.01892 1.56342 1.55215 1.02632 2.20765 1.02632H15.7932C16.4479 1.02632 16.9819 1.56342 16.9819 2.22368V10.7763ZM15.7932 0H2.20765C0.990047 0 0 0.998092 0 2.22368V10.7763C0 12.0028 0.990047 13 2.20765 13H15.7932C17.01 13 18 12.0028 18 10.7763V2.22368C18 0.998092 17.01 0 15.7932 0Z" fill="#757575"/>
</svg>''';

const lockIcon = '''<svg width="15" height="18" viewBox="0 0 15 18" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M9.24419 11.5472C9.24419 12.4845 8.46279 13.2453 7.5 13.2453C6.53721 13.2453 5.75581 12.4845 5.75581 11.5472C5.75581 10.6098 6.53721 9.84906 7.5 9.84906C8.46279 9.84906 9.24419 10.6098 9.24419 11.5472ZM13.9535 14.0943C13.9535 15.6863 12.6235 16.9811 10.9884 16.9811H4.01163C2.37645 16.9811 1.04651 15.6863 1.04651 14.0943V9C1.04651 7.40802 2.37645 6.11321 4.01163 6.11321H10.9884C12.6235 6.11321 13.9535 7.40802 13.9535 9V14.0943ZM4.53488 3.90566C4.53488 2.31368 5.86483 1.01887 7.5 1.01887C8.28488 1.01887 9.03139 1.31943 9.59477 1.86028C10.1564 2.41387 10.4651 3.14066 10.4651 3.90566V5.09434H4.53488V3.90566ZM11.5116 5.12745V3.90566C11.5116 2.87151 11.0956 1.89085 10.3352 1.14028C9.5686 0.405 8.56221 0 7.5 0C5.2875 0 3.48837 1.7516 3.48837 3.90566V5.12745C1.52267 5.37792 0 7.01915 0 9V14.0943C0 16.2484 1.79913 18 4.01163 18H10.9884C13.2 18 15 16.2484 15 14.0943V9C15 7.01915 13.4773 5.37792 11.5116 5.12745Z" fill="#757575"/>
</svg>''';

// Style border input field yang sama
const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFF757575)),
  borderRadius: BorderRadius.all(Radius.circular(100)),
);
// === END OF DEFINITIONS ===

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Ganti nama controller biar lebih deskriptif dikit
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _authController = AuthController();
  final _formKey = GlobalKey<FormState>(); // Kunci buat validasi form

  void _handleRegister() {
    // Cek dulu form-nya valid apa enggak sebelum manggil API
    if (_formKey.currentState!.validate()) {
      _authController.register(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        context: context, // Buat nampilin snackbar atau notif lain
      );
    }
  }

  @override
  void dispose() {
    // Jangan lupa di-dispose controller-nya biar gak memory leak
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Biar gak ada bayangan
        title: const Text("Sign Up"), // Judul AppBar
        leading: IconButton( // Tombol back otomatis
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView( // Biar bisa di-scroll kalo kontennya panjang
              child: Form( // Bungkus pake Form widget buat validasi
                key: _formKey, // Pasang GlobalKey ke Form
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      "Register Account",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Complete your details to create \nyour account", // Sedikit ubah teksnya
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF757575)),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                    // Field buat Nama
                    _buildTextFormField(
                      controller: _nameController,
                      hintText: "Enter your name",
                      labelText: "Name",
                      iconSvg: userIcon, // Pake icon user
                      textInputAction: TextInputAction.next, // Pindah ke field berikutnya
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null; // Return null kalo valid
                      },
                    ),
                    const SizedBox(height: 24), // Jarak antar field

                    // Field buat Email
                    _buildTextFormField(
                      controller: _emailController,
                      hintText: "Enter your email",
                      labelText: "Email",
                      iconSvg: mailIcon, // Pake icon mail
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        // Validasi email sederhana
                        if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Field buat Password
                    _buildTextFormField(
                      controller: _passwordController,
                      hintText: "Enter your password",
                      labelText: "Password",
                      iconSvg: lockIcon, // Pake icon lock
                      obscureText: true, // Sembunyiin inputan password
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) { // Contoh: password minimal 6 karakter
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Field buat Konfirmasi Password
                    
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                    // Tombol Sign Up
                    ElevatedButton(
                      onPressed: _handleRegister, // Panggil fungsi register
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFFFF7643), // Warna tombol
                        foregroundColor: Colors.white, // Warna teks tombol
                        minimumSize: const Size(double.infinity, 48), // Ukuran tombol
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                      child: const Text("Sign Up"),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    
                    // Teks "Already have an account? Sign In"
                    _buildAlreadyHaveAccountText(context),
                    const SizedBox(height: 20), // Padding di bawah
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget biar gak nulis TextFormField berulang-ulang
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    required String iconSvg,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    String? Function(String?)? validator, // Fungsi buat validasi
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always, // Label selalu di atas
        hintStyle: const TextStyle(color: Color(0xFF757575)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 12, 12), // Padding buat icon
          
        ),
        border: authOutlineInputBorder,
        enabledBorder: authOutlineInputBorder,
        focusedBorder: authOutlineInputBorder.copyWith(
          borderSide: const BorderSide(color: Color(0xFFFF7643)), // Warna border pas di-fokus
        ),
        errorBorder: authOutlineInputBorder.copyWith( // Warna border pas error
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: authOutlineInputBorder.copyWith( // Warna border pas error & di-fokus
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      validator: validator, // Pasang fungsi validatornya
    );
  }

  // Helper widget buat teks "Already have an account?"
  Widget _buildAlreadyHaveAccountText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account? ",
          style: TextStyle(color: Color(0xFF757575)),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context); // Balik ke halaman login
            // Atau bisa juga pake Navigator.pushReplacement kalo mau lebih pasti ke SignInScreen
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => SignInScreen()), // Pastiin SignInScreen udah di-import
            // );
          },
          child: const Text(
            "Sign In",
            style: TextStyle(
              color: Color(0xFFFF7643), // Warna link
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}