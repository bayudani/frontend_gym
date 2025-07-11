import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gym_app/views/auth/register_page.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';

//==================================================================
// HALAMAN UTAMA (SignInScreen)
// Sekarang jadi StatelessWidget yang simpel, karena logikanya
// sudah dipindah ke dalam SignInForm.
//==================================================================
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  const Text(
                    "Welcome To",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const Text(
                    "Fit.ID",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                  
                  // Memanggil widget form yang sudah mandiri
                  const SignInForm(),
                  
                  const SizedBox(height: 20),
                  const NoAccountText(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


//==================================================================
// WIDGET FORM (SignInForm)
// Diubah jadi StatefulWidget agar bisa mengelola state-nya sendiri
// (TextEditingController) dan mendengarkan perubahan dari AuthController.
//==================================================================
class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  // Controller dibuat dan di-dispose di sini, lebih rapi dan aman.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Email",
              labelText: "Email",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintStyle: const TextStyle(color: Colors.white54),
              labelStyle: const TextStyle(color: Colors.white70),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 16),
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                child: SvgPicture.string(
                  mailIcon,
                  colorFilter: const ColorFilter.mode(
                      Colors.white70, BlendMode.srcIn),
                  width: 18,
                  height: 13,
                ),
              ),
              border: authOutlineInputBorder,
              enabledBorder: authOutlineInputBorder,
              focusedBorder: authOutlineInputBorder.copyWith(
                borderSide: const BorderSide(color: Color(0xFFFF7643)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            textInputAction: TextInputAction.done,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Password",
              labelText: "Password",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintStyle: const TextStyle(color: Colors.white54),
              labelStyle: const TextStyle(color: Colors.white70),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 16),
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                child: SvgPicture.string(
                  lockIcon,
                  colorFilter: const ColorFilter.mode(
                      Colors.white70, BlendMode.srcIn),
                  width: 15,
                  height: 18,
                ),
              ),
              border: authOutlineInputBorder,
              enabledBorder: authOutlineInputBorder,
              focusedBorder: authOutlineInputBorder.copyWith(
                borderSide: const BorderSide(color: Color(0xFFFF7643)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // --- KEAJAIBAN PROVIDER DIMULAI DARI SINI ---
          // Tombol dibungkus Consumer agar reaktif terhadap state isLoading.
          Consumer<AuthController>(
            builder: (context, controller, child) {
              return ElevatedButton(
                // Jika sedang loading, tombol akan non-aktif.
                onPressed: controller.isLoading
                    ? null
                    : () {
                        // Mengambil AuthController dari Provider untuk memanggil fungsi.
                        // listen: false karena kita hanya butuh memanggil fungsi, bukan me-rebuild widget ini.
                        final authController = Provider.of<AuthController>(context, listen: false);

                        authController.login(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          context: context,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                // Tampilkan loading indicator atau teks sesuai state dari controller.
                child: controller.isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Sign In",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}

//==================================================================
// WIDGET-WIDGET PEMBANTU (Tidak ada perubahan)
//==================================================================

class NoAccountText extends StatelessWidget {
  const NoAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Didn't have any account? ",
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => RegisterPage()),
            );
          },
          child: const Text(
            "Sign up here",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.white70),
  borderRadius: BorderRadius.all(Radius.circular(10)),
);


//==================================================================
// KONSTANTA SVG STRING (Tidak ada perubahan)
//==================================================================

const mailIcon =
    '''<svg width="18" height="13" viewBox="0 0 18 13" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M15.3576 3.39368C15.5215 3.62375 15.4697 3.94447 15.2404 4.10954L9.80876 8.03862C9.57272 8.21053 9.29421 8.29605 9.01656 8.29605C8.7406 8.29605 8.4638 8.21138 8.22775 8.04204L2.76041 4.11039C2.53201 3.94618 2.47851 3.62546 2.64154 3.39454C2.80542 3.16362 3.12383 3.10974 3.35223 3.27566L8.81872 7.20645C8.93674 7.29112 9.09552 7.29197 9.2144 7.20559L14.6469 3.27651C14.8753 3.10974 15.1937 3.16447 15.3576 3.39368ZM16.9819 10.7763C16.9819 11.4366 16.4479 11.9745 15.7932 11.9745H2.20765C1.55215 11.9745 1.01892 11.4366 1.01892 10.7763V2.22368C1.01892 1.56342 1.55215 1.02632 2.20765 1.02632H15.7932C16.4479 1.02632 16.9819 1.56342 16.9819 2.22368V10.7763ZM15.7932 0H2.20765C0.990047 0 0 0.998092 0 2.22368V10.7763C0 12.0028 0.990047 13 2.20765 13H15.7932C17.01 13 18 12.0028 18 10.7763V2.22368C18 0.998092 17.01 0 15.7932 0Z" fill="#757575"/>
</svg>''';

const lockIcon =
    '''<svg width="15" height="18" viewBox="0 0 15 18" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M9.24419 11.5472C9.24419 12.4845 8.46279 13.2453 7.5 13.2453C6.53721 13.2453 5.75581 12.4845 5.75581 11.5472C5.75581 10.6098 6.53721 9.84906 7.5 9.84906C8.46279 9.84906 9.24419 10.6098 9.24419 11.5472ZM13.9535 14.0943C13.9535 15.6863 12.6235 16.9811 10.9884 16.9811H4.01163C2.37645 16.9811 1.04651 15.6863 1.04651 14.0943V9C1.04651 7.40802 2.37645 6.11321 4.01163 6.11321H10.9884C12.6235 6.11321 13.9535 7.40802 13.9535 9V14.0943ZM4.53488 3.90566C4.53488 2.31368 5.86483 1.01887 7.5 1.01887C8.28488 1.01887 9.03139 1.31943 9.59477 1.86028C10.1564 2.41387 10.4651 3.14066 10.4651 3.90566V5.09434H4.53488V3.90566ZM11.5116 5.12745V3.90566C11.5116 2.87151 11.0956 1.89085 10.3352 1.14028C9.5686 0.405 8.56221 0 7.5 0C5.2875 0 3.48837 1.7516 3.48837 3.90566V5.12745C1.52267 5.37792 0 7.01915 0 9V14.0943C0 16.2484 1.79913 18 4.01163 18H10.9884C13.2 18 15 16.2484 15 14.0943V9C15 7.01915 13.4773 5.37792 11.5116 5.12745Z" fill="#757575"/>
</svg>''';