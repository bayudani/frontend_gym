import 'package:flutter/material.dart';
import 'package:gym_app/controllers/auth_controller.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class VerifyEmailPage extends StatefulWidget {
  final String email;

  const VerifyEmailPage({super.key, required this.email});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _handleVerify() {
    if (_formKey.currentState!.validate()) {
      Provider.of<AuthController>(context, listen: false).verifyEmail(
        email: widget.email,
        code: _pinController.text,
        context: context,
      );
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(fontSize: 22, color: Colors.white),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Verifikasi Email",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Cek Email Kamu",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Kami telah mengirimkan 6 digit kode verifikasi ke email:\n${widget.email}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 40),

                Pinput(
                  length: 6,
                  controller: _pinController,
                  validator: (value) {
                    return value?.length == 6 ? null : 'Kode harus 6 digit';
                  },
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                Consumer<AuthController>(
                  builder: (context, controller, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading ? null : _handleVerify,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child:
                            controller.isLoading
                                ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                                : const Text(
                                  "VERIFIKASI",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    //logika kirim ulang kode
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Fitur kirim ulang belum tersedia."),
                      ),
                    );
                  },
                  child: const Text(
                    "Tidak menerima kode? Kirim ulang",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
